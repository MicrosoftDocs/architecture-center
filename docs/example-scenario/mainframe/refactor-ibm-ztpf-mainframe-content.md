There are a number of challenges with running and migrating mainframe systems:

* The pool of developers who understand the Assembler language and mainframe technology is diminishing. 
* Organizations that want to migrate from z/TPF mainframes to the cloud need a robust platform that can process high volume transactions.
* IBM mainframe hardware and software costs are expensive.

There are several approaches that you can take to transition from the z/TPF platform. To meet the requirements of z/TPS performance, this architecture uses a Kubernetes cluster. The solution delivers cloud-enabled applications and databases that are functionally equivalent to the z/TPF legacy counterparts. Migrating these critical systems into Azure requires a platform that supports a high-performance memory-sharing mechanism and a high-performance IP stack with low latency (microseconds) to deliver performance at the level of the z/TPF.

Additionally, Azure Cache for Redis, an Azure-based caching facility, is required to support session state. The z/TPF mainframe uses a shared memory feature called a *coupling facility* together with a low-latency IP stack called *HiperSockets*. This architecture uses drivers that provide shared I/O and memory across multiple nodes to provide similar functionality.

The Azure Cosmos DB NoSQL database is used for high-performance storage. This storage solution provides high speed and high-performance data persistence and retrieval.

This solution is designed to meet the following requirements:
- Refactored applications must remain functionally equivalent to their original counterparts.
- Refactored applications must perform as well as or better than the original applications.
- Refactored applications must be cloud-ready and delivered via a standard DevOps toolchain and DevOps best practices.

## Potential use cases
 
Here are some scenarios can benefit from refactoring to Azure:
- Modernize infrastructure and avoid the high costs, limitations, and rigidity that's associated with mainframes.
- Reduce operational and capital expenditure. 
- Move mainframe workloads to the cloud without the side effects of rewrites.
- Migrate mission-critical applications but maintain continuity with other on-premises applications.
- Take advantage of the horizontal and vertical scalability that Azure provides.
- Implement solutions that provide disaster recovery.

## Mainframe architecture (before migration)

diagram 

### Dataflow

1. Input over TCP/IP, including TN3270 and HTTP(S).
1. Input into the mainframe via standard mainframe protocols.                                
1. Receiving applications are usually only online systems.                                                               
1. Assembler, C++, or Saber Talk run in an enabled environment.  
1. NonSQL data and database services, like Azure Cosmos DB. 
1. Middleware and utility services manage services like tape storage, queueing, output, and web services within the environment.
1. Shared memory coupling.
1. Partitions are needed to run separate workloads or segregate work types within the environment.
1. Operating systems provide a specific interface between the engine and the software it runs.

## Azure architecture (after migration)

diagram 

### Dataflow 

1. Input, typically via either Azure ExpressRoute from remote clients or via other applications currently running in Azure. In either case, TCP/IP connections are the primary means of connection to the system. User access for web-based applications is provided over TLS port 443. You can use the web-application presentation layer virtually unchanged to minimize user retraining. Alternatively, you can update the web-application presentation layer with modern UX frameworks. To improve security by minimizing open ports, you can use Azure Bastion hosts for admin access to the VMs.
1. On Azure, an Azure load balancer is used to access the application compute clusters. Kubernetes provides robust load balancing and scaling. In this case, the front-end load balancer provides another level of failover capability to maintain business continuity if an entire cluster service goes down.
1. This solution supports deployment in containers, VMs, or virtual machine scale sets. Unlike VMs, containers and scale sets can scale in and out rapidly. Since the unit of scaling shifts to containers, infrastructure utilization is optimized.
1. Application servers receive the input in the compute clusters, and share application state and data using Redis Cache or RDMA (Remote Direct Memory Access)
1. The architecture can run on Red Hat Linux, SUSE Linux, or Microsoft Windows
1. A single root I/O virtualization driver (SR-IOV) driver is required for this architecture to meet the performance requirements. The SR-IOV specification enables multiple virtual machines (VMs) to share the same PCIe physical hardware resources. The driver used here is RDMA over Converged Ethernet (RoCE) or InfiniBand over Ethernet (IBoE) which allows communication between two hosts in the same Ethernet broadcast domain using an Ethernet link layer
1. Using RDMA/InfiniBand or RoCE drivers allow the two hosts to share its memory as one pool. 
1. Redis Memory Cache – an in-memory data structure store that provides a caching solution that improves application response time by storing copies of the most frequently used data and the session state.
1. Service Fabric Cluster - Service Fabric is Microsoft's container orchestrator for deploying and managing microservices across a cluster of machines, benefiting from the lessons learned running Microsoft services at massive scale.

Components

This example features the following Azure components. Several of these components and workflows are interchangeable or optional depending on your scenario. 
- [Azure ExpressRoute] extends your on-premises networks into Azure over a private, dedicated fiber connection from a connectivity provider. ExpressRoute establishes connections to Microsoft cloud services like Azure and Microsoft 365. 
- [Azure Bastion] provides seamless Remote Desktop Protocol (RDP) or secure shell (SSH) connectivity to virtual network VMs from the Azure portal over TLS. Azure Bastion maximizes administrative access security by minimizing open ports. 
- [Azure Load Balancer] distributes incoming traffic to the compute resource clusters. You can define rules and other criteria to distribute the traffic. 
- [Azure Kubernetes Service (AKS)] is a fully managed Kubernetes service to deploy and manage containerized applications. AKS offers serverless Kubernetes, an integrated continuous integration and continuous delivery (CI/CD) experience, and enterprise-grade security and governance. 
- [Azure Virtual Network] is the fundamental building block of Azure private networks. Azure VMs within virtual networks can communicate securely with each other, the internet, and on-premises networks. A virtual network is like a traditional on-premises network, but with Azure infrastructure benefits like scalability, high availability, and isolation. 
- [Azure Cache for Redis] adds a quick caching layer to application architecture to handle large volumes at high speed. Azure Cache for Redis scales performance simply and cost-effectively, with the benefits of a fully managed service. 
- [Azure databases] offer a choice of fully managed relational and NoSQL databases to fit modern application needs. Automated infrastructure management provides scalability, availability, and security. 
   - [Azure Cosmos DB] is a fully managed, fast NoSQL database with open APIs for any scale. 

alternatives 

instead of kubernetes clusters, you could use vms 

Considerations

The following considerations, based on the Azure Well-Architected Framework, apply to this solution: 

Performance Efficiency 

This architecture is designed for very high transactions.  We can accomplish this by leveraging the power of Azure’s compute and using shared I/O and Memory thereby creating coupled environment that delivers on the demand required for these applications. 

Operations 

Refactoring not only supports faster cloud adoption, but also promotes adoption of DevOps and Agile working principles. You have full flexibility in development and production deployment options. 
 
Resiliency 

Kubernetes provides a cluster autoscaler, this feature adjusts the number of nodes required based on the requested compute resources in the node pool. The cluster autoscaler monitors the Metrics API server every 10 seconds for any required changes in node count. If the cluster autoscale determines that a change is required, the number of nodes in your AKS cluster is increased or decreased accordingly

Security 

[Kubernetes] This architecture is primarily built on the Kubernetes which includes security components, such as pod security standards and Secrets.  In addition, Azure provides additional features such as Active Directory, Microsoft Defender for Containers, Azure Policy, Azure Key Vault, network security groups and orchestrated cluster upgrades.

[Azure Bastion] maximizes admin access security by minimizing open ports. Bastion provides secure and seamless RDP/SSH connectivity to virtual network VMs directly from the Azure portal over TLS. 

Use the [Pricing calculator] to estimate costs for your implementation of this solution.

## Next steps
- For more information, please contact [legacy2azure@microsoft.com].

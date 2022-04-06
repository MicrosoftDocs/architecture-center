There are a number of challenges with running and migrating mainframe systems:

* The pool of developers who understand the Assembler language and mainframe technology is diminishing. 
* Organizations that want to migrate from z/TPF mainframes to the cloud need a robust platform that can process high volume transactions.
* IBM mainframe hardware and software costs are expensive.

There are several approaches that you can take to transition from the z/TPF platform. To meet the requirements of z/TPS performance, this architecture uses a Kubernetes cluster. This solution delivers cloud-enabled applications and databases that are functionally equivalent to the z/TPF legacy counterparts. Migrating these critical systems into Azure requires a platform that supports a high-performance memory sharing mechanism and a high-performance IP stack with low latency (micro-seconds) to deliver performance at the level of the z/TPF.

Additionally, Redis Cache, an Azure based caching facility is required to support session state.  The z/TPF mainframe utilizes a shared memory feature called a Coupling Facility along with a low latency IP stack called Hipersockets. This reference architecture leverages drivers that provide shared I/O and memory across multiple nodes to provide similar functionality.

For high performance storage Azure based NoSQL solutions Cosmos DB is also being used.  This storage solution allows for high speed and high-performance data persistence and retrieval.

Azure z/TPF Architecture Refactoring solution was designed with the following requirements in mind:
- Refactored applications must remain functionally equivalent to their original counterparts
- Refactored applications should perform as well as, or better than, the original applications
- Refactored applications should be Cloud-ready and delivered using a standard DevOps toolchain and best practices

Use Cases
 
Many scenarios can benefit from refactoring using Azure Cloud. Possibilities include the following cases:
- Businesses seeking to modernize infrastructure and escape the exorbitant costs, limitations, and rigidity associated with mainframes.
- Reduce operational and capital expenditure costs. 
- Organizations opting to move mainframe workloads to the cloud without the side effects of rewrites.
- Organizations who need to migrate mission-critical applications while maintaining continuity with other on-premises applications.
- Teams looking for the horizontal and vertical scalability that Azure offers.
- Businesses that favor solutions offering disaster recovery options.

Mainframe Architecture (Pre-Migration)

diagram 

Mainframe Architecture Annotations

1.Input over TCP/IP including TN3270 and HTTP (S).                                                                                                                                                      
1.Input into the mainframe using standard mainframe protocols.                                
1. Receiving applications are usually only online systems.                                                               
1. Assembler, C++, or Saber Talk run in enabled environment.  
1. Data and Database services NonSQL e.g., Cosmos DB 
1. Middleware and utility services manage such services as tapes storage, queueing, output, and web services within the environment.
1. Shared Memory Coupling 
1. Partitions utilized are needed to run separate workloads or segregate work types within the environment.
1. Operating systems provide a specific interface between the engine and the and the software it’s running.

Azure Architecture (Post Migration)

diagram 

Azure Architecture Annotations
1. Input will typically come either via Express Route from remote clients, or by other applications currently running Azure.  In either case, TCP/IP 	connections will be the primary means of connection to the system.  User access provided over TLS port 443 for accessing web-based applications.  Web-based Applications presentation layer can be kept virtually unchanged to minimize end user retraining.  Alternatively, the web application presentation layer can be updated with modern UX frameworks as requirements necessitate.  Further, for admin access to the VMs, Azure VM Bastion hosts can be used to maximize security by minimizing open ports.                                                                                 
1. Once in Azure, access to the application compute clusters will be done using an Azure Load balancer. Kubernetes provides robust load balancing and scaling; the front-end Load Balancer in this case provides an additional level of failover capability maintaining business continuity if an entire cluster service were to go down.                             
1. This solutions can support deployment in containers, VMs or Virtual Machine Scale Sets. Unlike virtual machines, containers and VMSS can scale out and scale in rapidly. Since the unit of scaling shifts to containers, infrastructure utilization is optimized.                                                                  
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

Kubernetes This architecture is primarily built on the Kubernetes which includes security components, such as pod security standards and Secrets.  In addition, Azure provides additional features such as Active Directory, Microsoft Defender for Containers, Azure Policy, Azure Key Vault, network security groups and orchestrated cluster upgrades.

Azure Bastion maximizes admin access security by minimizing open ports. Bastion provides secure and seamless RDP/SSH connectivity to virtual network VMs directly from the Azure portal over TLS. 

Use the Pricing calculator to estimate costs for your implementation of this solution.

## Next Steps
- For more information, please contact legacy2azure@microsoft.com.

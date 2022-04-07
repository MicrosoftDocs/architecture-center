Mainframe systems are expensive to maintain, and the pool of developers who understand these systems is diminishing. But organizations migrating from z/TPF mainframes to the cloud need a robust platform that can process high volume transactions.

This solution delivers cloud-enabled applications and databases that are functionally equivalent to the z/TPF legacy counterparts. 

The solution is designed to meet these requirements:
- Refactored applications must remain functionally equivalent to their original counterparts.
- Refactored applications must perform as well as or better than the original applications.
- Refactored applications must be cloud-ready and delivered via a standard DevOps toolchain and DevOps best practices.

## Potential use cases
 
Here are some scenarios that can benefit from refactoring to Azure:
- Modernize infrastructure and avoid the high costs, limitations, and rigidity that's associated with mainframes.
- Reduce operational and capital expenditure. 
- Move mainframe workloads to the cloud without the side effects of rewrites.
- Migrate mission-critical applications but maintain continuity with other on-premises applications.
- Take advantage of the horizontal and vertical scalability that Azure provides.
- Implement solutions that provide disaster recovery.

## Mainframe architecture (before migration)

diagram 

### Dataflow

- Users input data over TCP/IP, including TN3270 and HTTP(S).
- Data is input into the mainframe via standard mainframe protocols.                                
- Applications receive the data. These applications are usually only online systems. Assembler, C++, or Saber Talk run in an enabled environment.  
- NonSQL data and database services, like Azure Cosmos DB, store data.
- Middleware and utility services manage services like tape storage, queueing, output, and web services within the environment.
- Shared memory coupling coordinates multiple processors.
- Partitions are used to run separate workloads or segregate work types within the environment.
- Operating systems provide interfaces between the engine and the software it runs.

## Azure architecture (after migration)

diagram 

Migrating mainframe systems to Azure requires a platform that supports a high-performance memory-sharing mechanism and a high-performance IP stack with low latency (microseconds) to deliver performance at the level of the z/TPF.

Azure Cache for Redis, an Azure-based caching facility, is required to support session state. 

The z/TPF mainframe uses a shared memory feature called a *coupling facility* together with a low-latency IP stack called *HiperSockets*. This architecture uses drivers that provide shared I/O and memory across multiple nodes to provide similar functionality.

The Azure Cosmos DB NoSQL database is used for high-performance storage. This storage solution provides high speed and high-performance data persistence and retrieval.

### Dataflow 

1. Input, typically via either Azure ExpressRoute from remote clients or via other applications currently running in Azure. In either case, TCP/IP connections are the primary means of connection to the system. User access for web-based applications is provided over TLS port 443. You can use the web-application presentation layer virtually unchanged to minimize user retraining. Alternatively, you can update the web-application presentation layer with modern UX frameworks. To improve security by minimizing open ports, you can use Azure Bastion hosts for admin access to the VMs.
1. On Azure, an Azure load balancer is used to access the application compute clusters. Kubernetes provides robust load balancing and scaling. In this case, the front-end load balancer provides another level of failover capability to maintain business continuity if an entire cluster service goes down.
1. Kubernetes is used for deployment. Because the unit of scaling shifts to containers, infrastructure utilization is optimized.
1. Application servers receive the input in the compute clusters and share application state and data by using Azure Cache for Redis or Remote Direct Memory Access (RDMA).
1. The architecture runs on Red Hat Enterprise Linux, SUSE Linux, or Windows.
1. A single root I/O virtualization (SR-IOV) driver is used to meet performance requirements. The SR-IOV specification enables multiple VMs to share the same PCIe physical hardware resources. The driver used here is either RDMA over Converged Ethernet (RoCE) or InfiniBand over Ethernet (IBoE). These drivers allow communication between two hosts in the same Ethernet broadcast domain by using an Ethernet link layer.
1. RDMA/InfiniBand or RoCE drivers allow the two hosts to share memory as one pool. 
1. Azure Cache for Redis provides a caching solution that improves application response time by storing copies of the most frequently used data and the session state.
1. Service Fabric clusters provides container orchestration.

### Components

This solution features the following Azure components. Several of these components and workflows are interchangeable or optional, depending on your scenario. 
- [Azure ExpressRoute](https://azure.microsoft.com/services/expressroute) extends your on-premises networks into Azure over a private, dedicated fiber connection from a connectivity provider. ExpressRoute establishes connections to cloud services like Azure and Microsoft 365. 
- [Azure Bastion](https://azure.microsoft.com/services/azure-bastion) is a fully managed service that helps secure remote access to your virtual machines. 
- [Azure Load Balancer](https://azure.microsoft.com/services/load-balancer) distributes incoming traffic to the compute resource clusters. You can define rules and other criteria to distribute the traffic. 
- [Azure Kubernetes Service (AKS)](https://azure.microsoft.com/services/kubernetes-service) is a fully managed Kubernetes service for deploying and managing containerized applications. AKS offers serverless Kubernetes, an integrated continuous integration and continuous delivery (CI/CD) experience, and enterprise-grade security and governance. 
- [Azure Virtual Network](https://azure.microsoft.com/services/virtual-network) is the fundamental building block of Azure private networks. Azure VMs in virtual networks can communicate with improved security with each other, the internet, and on-premises networks. A virtual network is like a traditional on-premises network, but with Azure infrastructure benefits like scalability, high availability, and isolation. 
- [Azure Cache for Redis](https://azure.microsoft.com/services/cache) adds a quick caching layer to application architecture to handle large volumes at high speed. Azure Cache for Redis scales performance simply and cost-effectively, providing the benefits of a fully managed service. 
- [Azure databases](https://azure.microsoft.com/product-categories/databases) offer a choice of fully managed relational and NoSQL databases to fit modern application needs. Automated infrastructure management provides scalability, availability, and security. 
   - [Azure Cosmos DB](https://azure.microsoft.com/services/cosmos-db) is a fully managed, fast NoSQL database with open APIs for any scale. 

### Alternatives 

This solution supports deployment in containers, VMs, or virtual machine scale sets. Unlike VMs, containers and scale sets can scale in and out rapidly. Because the unit of scaling shifts to containers, infrastructure utilization is optimized. 

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Performance efficiency 

This architecture is designed for high volume transactions. It uses Azure compute and shared I/O and memory to create a coupled environment that meets these needs. 

To meet the requirements of z/TPS performance, this architecture uses Kubernetes clusters. 

### Operations 

In addition to supporting faster cloud adoption, refactoring also promotes the adoption of DevOps and Agile working principles. It provides full flexibility in development and production deployment options. 
 
### Resiliency 

Kubernetes provides a cluster autoscaler that adjusts the number of nodes required based on the requested compute resources in the node pool. The cluster autoscaler monitors the Metrics API server every 10 seconds for any changes required in the node count. 

### Security 

This architecture is primarily built on Kubernetes, which includes security components like [Pod Security Standards](https://kubernetes.io/docs/concepts/security/pod-security-standards) and [Secrets](https://kubernetes.io/docs/concepts/configuration/secret). Azure provides additional features, like Azure Active Directory, Microsoft Defender for Containers, Azure Policy, Azure Key Vault, network security groups, and orchestrated cluster upgrades.

[Azure Bastion](/azure/bastion/bastion-overview) improves security for admin access by minimizing open ports. Azure Bastion provides highly secure RDP or SSH connectivity to virtual network VMs directly from the Azure portal, over TLS. 

### Cost optimization 

Use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate costs for your implementation of this solution.

## Next steps

For more information, contact [legacy2azure@microsoft.com](mailto:legacy2azure@microsoft.com).

See these additional resources:
- [Make the switch from mainframes to Azure](/azure/cloud-adoption-framework/infrastructure/mainframe-migration/migration-strategies)
- [Mainframe application migration](/azure/cloud-adoption-framework/infrastructure/mainframe-migration/application-strategies)
- []

## Related resources
- []
- []
- []
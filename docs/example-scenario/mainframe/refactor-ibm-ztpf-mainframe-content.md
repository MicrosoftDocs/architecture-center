Organizations migrating from z/TPF mainframes to the cloud need a robust platform that can process high volume transactions. This solution delivers cloud-enabled applications and databases that are functionally equivalent to the z/TPF legacy counterparts. 

## Architecture

### Mainframe architecture

:::image type="content" border="false" source="media/mainframe-migration-before.svg" alt-text="Diagram that shows the mainframe architecture before migration." lightbox="media/mainframe-migration-before.svg":::

*Download a [Visio file](https://arch-center.azureedge.net/mainframe-migration-after.vsdx) of this architecture.*

#### Dataflow

- Users input data over TCP/IP, including TN3270 and HTTP(S).
- Data is input into the mainframe via standard mainframe protocols.                                
- Applications receive the data. These applications are usually only online systems. Assembler, C++, or Saber Talk run in an enabled environment.  
- NonSQL data and database services, like Azure Cosmos DB, store data.
- Middleware and utility services manage tasks like tape storage, queueing, output, and web services within the environment.
- Shared memory coupling coordinates multiple processors.
- Partitions are used to run separate workloads or segregate work types within the environment.
- Operating systems provide interfaces between the engine and the software it runs.

### Azure architecture

:::image type="content" border="false" source="media/mainframe-migration-after.svg" alt-text="Diagram that shows the Azure architecture, after the migration." lightbox="media/mainframe-migration-after.svg"::: 

*Download a [Visio file](https://arch-center.azureedge.net/mainframe-migration-after.vsdx) of this architecture.*

Migrating mainframe systems to Azure requires a platform that supports a high-performance memory-sharing mechanism and a high-performance IP stack with low latency (microseconds) to deliver performance at the level of the z/TPF.

The z/TPF mainframe uses a shared memory feature called a *coupling facility* together with a low-latency IP stack called *HiperSockets*. This architecture uses drivers that provide shared I/O and memory across multiple nodes to implement similar functionality.

The Azure Cosmos DB NoSQL database is used for high-performance storage. This storage solution provides high speed and high-performance data persistence and retrieval.

#### Dataflow 

1. Input, typically via either Azure ExpressRoute from remote clients or via other applications currently running in Azure. In either case, TCP/IP connections provide the primary means of connection to the system. User access for web-based applications is provided over TLS port 443. To improve security by minimizing open ports, you can use Azure Bastion hosts for admin access to the VMs.
1. On Azure, an Azure load balancer is used to access the application compute clusters. Kubernetes provides robust load balancing and scaling. In this case, the front-end load balancer provides another level of failover capability to maintain business continuity if an entire cluster service goes down.
1. VMs, Kubernetes, or virtual machine scale sets are used for deployment. 
1. Application servers receive the input in the compute clusters and share application state and data by using Azure Cache for Redis or Remote Direct Memory Access (RDMA).
1. The architecture runs on Red Hat Enterprise Linux, SUSE Linux, or Windows.
1. A single root I/O virtualization (SR-IOV) driver is used to meet performance requirements. The SR-IOV enables multiple VMs to share the same PCIe physical hardware resources. The driver used here is either RDMA over Converged Ethernet (RoCE) or InfiniBand over Ethernet (IBoE). These drivers allow communication between two hosts in the same Ethernet broadcast domain via an Ethernet link layer.
1. RDMA/InfiniBand or RoCE drivers allow the two hosts to share memory as one pool. 
1. Azure Cache for Redis provides a caching solution that improves application response time by storing copies of the most frequently used data and the session state.
1. Service Fabric clusters provide container orchestration.

## Components

- [Azure Bastion](/azure/bastion/bastion-overview) is a fully managed service that provides secure remote access to your virtual machines directly from the Azure portal over TLS. In this architecture, Azure Bastion improves security for administrative access by minimizing open ports and eliminating the need for public IP addresses on VMs that host the refactored z/TPF applications.

- [Azure Cache for Redis](/azure/azure-cache-for-redis/cache-overview) is an in-memory data store that adds a quick caching layer to application architecture to handle large volumes at high speed. Azure Cache for Redis scales performance simply and cost-effectively, providing the benefits of a fully managed service. In this architecture, Azure Cache for Redis replaces the z/TPF mainframe's shared memory coupling facility by providing high-speed shared memory and session state management across multiple compute nodes.

- [Azure Cosmos DB](/azure/well-architected/service-guides/cosmos-db) is a fully managed, fast NoSQL database that has open APIs for any scale. In this architecture, Azure Cosmos DB provides the high-performance NoSQL storage solution that delivers the speed and performance required to match z/TPF mainframe database capabilities.

- [Azure databases](/sql/relational-databases/databases/databases) are a collection of cloud-based database services that provide a choice of fully managed relational and NoSQL databases to fit modern application needs. Automated infrastructure management provides scalability, availability, and security. In this architecture, Azure databases provide high-performance data persistence and retrieval to replace mainframe database systems.

- [Azure Kubernetes Service (AKS)](/azure/well-architected/service-guides/azure-kubernetes-service) is a fully managed Kubernetes service for deploying and managing containerized applications. AKS provides serverless Kubernetes, an integrated continuous integration and continuous delivery (CI/CD) experience, and enterprise-grade security and governance. In this architecture, AKS provides robust load balancing, scaling, and container orchestration for the refactored z/TPF applications to meet high-volume transaction requirements.

- [Azure Load Balancer](/azure/well-architected/service-guides/azure-load-balancer/reliability) is a network load balancer that distributes incoming traffic across healthy instances of services. You can define rules and other criteria to distribute the traffic. In this architecture, Load Balancer provides another level of failover capabilities to maintain business continuity by distributing traffic to the compute resource clusters that run the refactored z/TPF applications.

- [Azure Virtual Network](/azure/well-architected/service-guides/virtual-network) is the fundamental building block of Azure private networks that enables Azure VMs to communicate securely with each other, the internet, and on-premises networks. A virtual network is like a traditional on-premises network, but it provides Azure infrastructure benefits like scalability, high availability, and isolation. In this architecture, Virtual Network provides the secure network foundation for all components of the refactored z/TPF system.

- [ExpressRoute](/azure/well-architected/service-guides/azure-expressroute) is a connectivity service that extends your on-premises networks into Azure over a private, dedicated fiber connection from a connectivity provider. ExpressRoute establishes connections to cloud services like Azure and Microsoft 365. In this architecture, ExpressRoute provides high-bandwidth, low-latency connectivity between on-premises mainframe environments and the refactored z/TPF applications that run on Azure.

### Alternatives

This solution supports deployment in containers, VMs, or virtual machine scale sets. Unlike VMs, containers and scale sets can scale in and out rapidly. Because the unit of scaling is containers, infrastructure utilization is optimized. 

You can use the legacy web-application presentation layer with minimal changes to reduce user retraining. Alternatively, you can update the web-application presentation layer with modern UX frameworks.

## Scenario details

Mainframe systems are expensive to maintain, and the pool of developers who understand these systems is diminishing. But organizations migrating from z/TPF mainframes to the cloud need a robust platform that can process high volume transactions. This solution delivers cloud-enabled applications and databases that are functionally equivalent to the z/TPF legacy counterparts. 

The solution is designed to meet these requirements:
- Refactored applications must remain functionally equivalent to their original counterparts.
- Refactored applications must perform as well as or better than the original applications.
- Refactored applications must be cloud-ready and delivered via a standard DevOps toolchain and implement DevOps best practices.

### Potential use cases
 
Here are some scenarios that can benefit from refactoring to Azure:
- Modernize infrastructure and avoid the high costs, limitations, and rigidity that are associated with mainframes.
- Reduce operational and capital expenditure. 
- Move mainframe workloads to the cloud without the side effects of rewrites.
- Migrate mission-critical applications but maintain continuity with other on-premises applications.
- Take advantage of the horizontal and vertical scalability that Azure provides.
- Implement solutions that provide disaster recovery.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist). 

Kubernetes provides a cluster autoscaler that adjusts the number of nodes required based on the requested compute resources in the node pool. The cluster autoscaler monitors the Metrics API server every 10 seconds to determine if changes are needed in the node count. 

### Security 

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

This architecture is primarily built on Kubernetes, which includes security components like [Pod Security Standards](https://kubernetes.io/docs/concepts/security/pod-security-standards) and [Secrets](https://kubernetes.io/docs/concepts/configuration/secret). Azure provides additional security features, like Microsoft Entra ID, Microsoft Defender for Containers, Azure Policy, Azure Key Vault, network security groups, and orchestrated cluster upgrades.

[Azure Bastion](/azure/bastion/bastion-overview) improves security for admin access by minimizing open ports. Azure Bastion provides highly secure RDP or SSH connectivity to virtual network VMs directly from the Azure portal, over TLS. 

### Cost Optimization

Cost Optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

Use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate the costs for your implementation of this solution.

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

In addition to supporting faster cloud adoption, refactoring also promotes the adoption of DevOps and Agile working principles. It provides full flexibility in development and production deployment options.

### Performance Efficiency

Performance Efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

This architecture is designed for high volume transactions. It uses Azure compute and shared I/O and memory to create a coupled environment that meets these needs. 

To meet the requirements of z/TPS performance, this architecture uses Kubernetes clusters. 

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

 * Marlon Johnson | Senior Program Manager 
 
Other contributors:

 * [Bhaskar Bandam](https://www.linkedin.com/in/bhaskar-bandam-75202a9) | Senior Program Manager 

## Next steps

For more information, contact [legacy2azure@microsoft.com](mailto:legacy2azure@microsoft.com).

See these additional resources:
- [Azure Kubernetes Service (AKS)](/azure/aks)
- [Welcome to Azure Cosmos DB](/azure/cosmos-db/introduction)
- [Azure databases](../../index.yml?product=databases)
- [What is Azure Virtual Network?](/azure/virtual-network/virtual-networks-overview)

## Related resources

- [Mainframe application migration](/azure/cloud-adoption-framework/infrastructure/mainframe-migration/application-strategies?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json)
- [Make the switch from mainframes to Azure](/azure/cloud-adoption-framework/infrastructure/mainframe-migration/migration-strategies?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json)
- [Modernize mainframe and midrange data](/azure/architecture/example-scenario/mainframe/modernize-mainframe-data-to-azure)
- [Move archive data from mainframe systems to Azure](../../example-scenario/mainframe/move-archive-data-mainframes.yml)
- [Reengineer mainframe batch applications on Azure](../../example-scenario/mainframe/reengineer-mainframe-batch-apps-azure.yml)

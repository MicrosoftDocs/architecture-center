Advanced's Automated COBOL Refactoring solution refactors COBOL applications, as well those written in CA-Gen, CA-Telon, Natural, ADSO and other legacy languages, to deliver cloud-enabled applications and databases that are functionally equivalent to their legacy counterparts. This reduces costs, allows for deeper integration, and enables customization to meet business requirements. In addition, it unlocks a whole new world of quality and scalability, from automated testing to quality assurance, and the ability to benefit from containerized deployments and orchestration with Docker and Kubernetes.

## Mainframe architecture

Here's an example system where automated factoring can be used:

:::image type="content" source="media/refactor-mainframe-applications-advanced-pre.png" alt-text="Architecture diagram that shows a mainframe system that includes legacy-language applications." lightbox="media/refactor-mainframe-applications-advanced-pre.png":::

### Workflow

A. Users provide input over TCP/IP, using protocols such as TN3270, HTTP, and HTTPS.

B. Input arrives using standard mainframe protocols.

C. Batch and online applications process the input.

D. COBOL, PL/I, Assembler, and compatible languages run in an enabled environment.

E. Files and databases provide data storage. The database types include hierarchical, network, and relational.

F. Services perform tasks for the applications. Services that are commonly enabled include program execution, I/O operations, error detection, and protection.

G. Middleware and utility services manage such tasks as tape storage, queueing, output, and web support.

H. Operating systems provide the interface between the engine and the software that it runs.

I. Partitions run separate workloads, or segregate work types within the environment.

## Azure architecture

This is the architecture of the example system shown above when refactored for Azure. The letter callouts in the diagrams reveal where the refactored solution handles the corresponding mainframe functionality.

:::image type="content" source="media/refactor-mainframe-applications-advanced-post.png" alt-text="Architecture diagram that shows the system on Azure after refactoring." lightbox="media/refactor-mainframe-applications-advanced-post.png":::

*Download a [Visio file](https://arch-center.azureedge.net/refactor-mainframe-applications-advanced.vsdx) of this architecture.*

## Workflow

1. Input typically comes either through Azure ExpressRoute from remote clients, or from other Azure applications. In either case, TCP/IP connections are the primary means of connecting to the system. User access to web applications is over TLS port 443. You can keep the UI of the web applications the same to minimize end user retraining, or you can update it by using modern UX frameworks. Azure Bastion provides admin access to the virtual machines (VMs), maximizing security by minimizing open ports.
1. Once in Azure, access to the application compute clusters is through an Azure load balancer. This approach allows for scale-out compute resources to process the input work. Depending on input, you can load balance at either the application level or the network-protocol level.
1. Advanced supports deployment in containers, VMs, or Virtual Machine Scale Sets. Containers and Virtual Machine Scale Sets, unlike VMs, can scale out and in rapidly. Shifting the unit of scaling to containers optimizes infrastructure utilization.
1. Application servers receive the input in the compute clusters, and share application state and data using Azure Cache for Redis or Remote Direct Memory Access (RDMA).
1. Data services in the application clusters allow for multiple connections to persistent data sources. Possible data sources include:
   - Azure SQL Database.
   - Azure Cosmos DB.
   - Databases on VMs, such as Oracle and Db2.
   - Big data repositories such as Azure Databricks and Azure Data Lake.
   - Streaming data services such as Kafka and Azure Stream Analytics.
1. The application servers host various application programs based on the language's capability, such as Java classes or COBOL programs.
1. Data services use a combination of:
   1. **High-performance storage:** Azure Premium SSD and Azure Ultra Disk Storage.
   1. **File storage:** Azure NetApp Files and Azure Files.
   1. **Standard storage:** Azure Blob Storage, archive, and backup. The backup can be:

      1. Locally Redundant Storage (LRS).
      1. Zone-redundant storage (ZRS).
      1. Geo-redundant storage (GRS).
      1. Geo-zone-redundant storage (GZRS).

      For more information on redundancy, see [Azure Storage redundancy](/azure/storage/common/storage-redundancy).

1. Azure platform as a service (PaaS) data services provide scalable and highly available data storage to share across multiple compute resources in a cluster. These can also be geo-redundant.
1. Azure Data Factory can ingest data and synchronize with multiple data sources both within Azure and from external sources. Azure Blob storage is a common landing zone for external data sources.
1. Azure Site Recovery provides for disaster recovery of the VM and container cluster components.
1. Applications connect to private endpoints of the various PaaS services.

### Components

This example features the following Azure components. Several of these components and workflows are interchangeable or optional, depending on your scenario.

- [Azure Bastion](/azure/bastion/bastion-overview) is a fully managed service that provides secure Remote Desktop Protocol (RDP) or Secure Shell (SSH) connectivity to virtual network VMs directly from the Azure portal over Transport Layer Security (TLS). In this architecture, Azure Bastion maximizes admin access security by minimizing open ports to the VMs that host the refactored COBOL applications.

- [Azure Cache for Redis](/azure/azure-cache-for-redis/cache-overview) is a fully managed in-memory caching service that adds a quick caching layer to application architecture to handle large volumes at high speed. Azure Cache for Redis scales performance simply and cost-effectively, with the benefits of a fully managed service. In this architecture, Azure Cache for Redis enables application servers to share application state and data across compute clusters for the refactored mainframe applications.

- [Azure Data Factory](/azure/data-factory/introduction) is an extract, transform, and load (ETL) service for scale-out, serverless data integration and data transformation. It provides a code-free UI for intuitive authoring and single-pane-of-glass monitoring and management. In this architecture, Azure Data Factory provides data integration and transformation capabilities for migrating and processing mainframe data in the refactored solution.

- [Azure databases](/sql/relational-databases/databases/databases) are a collection of cloud-based database services that provide fully managed relational and NoSQL databases to fit modern application needs. Automated infrastructure management provides scalability, availability, and security. In this architecture, Azure databases provide persistent data storage solutions to replace mainframe database systems.

  - [Azure Cosmos DB](/azure/well-architected/service-guides/cosmos-db) is a fully managed, fast NoSQL database with open APIs for any scale. In this architecture, Azure Cosmos DB provides globally distributed NoSQL database services for refactored applications that require flexible, scalable data storage.

  - [Azure Database for PostgreSQL](/azure/well-architected/service-guides/postgresql) is a fully managed database based on the open-source PostgreSQL relational database engine. The Hyperscale (Citus) deployment option scales queries across multiple machines by using sharding for applications that require greater scale and performance. In this architecture, Azure Database for PostgreSQL provides open-source relational database services for refactored applications that require PostgreSQL capabilities.

  - [SQL Database](/azure/well-architected/service-guides/azure-sql-database-well-architected-framework) is a fully managed PaaS database engine that always runs on the latest stable version of SQL Server and a patched OS with high availability. Built-in PaaS database management capabilities include upgrading, patching, backups, and monitoring. In this architecture, SQL Database provides managed relational database services for refactored applications that require SQL Server compatibility.

- [Azure Kubernetes Service (AKS)](/azure/well-architected/service-guides/azure-kubernetes-service) is a fully managed Kubernetes service to deploy and manage containerized applications. AKS provides serverless Kubernetes, an integrated continuous integration and continuous delivery (CI/CD) experience, and enterprise-grade security and governance. In this architecture, AKS provides container orchestration for deploying and scaling the refactored COBOL applications with rapid scale-out capabilities.

- [Azure Load Balancer](/azure/well-architected/service-guides/azure-load-balancer/reliability) is a network load balancer that distributes incoming traffic across multiple targets to ensure high availability and reliability. You can define rules and other criteria to distribute the traffic. In this architecture, Load Balancer provides access to the application compute clusters and enables scale-out compute resources to process the input work from refactored mainframe applications.

- [Azure Private Link](/azure/private-link/private-link-overview) is a networking service that provides private connectivity from a virtual network to Azure services. Private Link eliminates public internet exposure to simplify network architecture and secure the connections between Azure endpoints. In this architecture, Private Link enables the refactored applications to connect securely to private endpoints of various PaaS services.

- [Azure Storage](/azure/well-architected/service-guides/azure-blob-storage) is scalable, secure cloud storage for all your data, applications, and workloads. In this architecture, Azure Storage provides various storage options to support the data requirements of refactored mainframe applications.

  - [Azure Disk Storage](/azure/well-architected/service-guides/azure-disk-storage) is high-performance, durable block storage for business-critical applications. Azure managed disks are block-level storage volumes that Azure manages on its Azure Virtual Machines (VMs). The available types of disk storage are Ultra Disk Storage, Premium SSD, and Azure Standard SSD. In this architecture, Azure Disk Storage provides high-performance storage for the refactored applications by using either Premium SSD or Ultra Disk Storage.

  - [Azure Files](/azure/well-architected/service-guides/azure-files) is a fully managed file share service that provides fully managed file shares in the cloud that can be accessed via the industry standard Server Message Block (SMB) protocol. Cloud and on-premises Windows, Linux, and macOS deployments can mount file shares concurrently. In this architecture, Azure Files provides shared file storage that can be accessed by multiple instances of the refactored applications.

- [Azure VMs](/azure/well-architected/service-guides/virtual-machines) is a cloud computing service that provides many sizes and types of on-demand, scalable computing resources. By using VMs, you get the flexibility of virtualization without having to buy and maintain physical hardware. In this architecture, VMs host the refactored mainframe applications and provide scalable compute resources as an alternative to containerized deployments.

- [Azure Virtual Network](/azure/well-architected/service-guides/virtual-network) is the fundamental building block of Azure private networks. VMs within virtual networks can communicate securely with each other, the internet, and on-premises networks. A virtual network is like a traditional on-premises network, but with Azure infrastructure benefits like scalability, high availability, and isolation. In this architecture, Virtual Network provides the secure network foundation for all components of the refactored mainframe system.

- [Blob Storage](/azure/well-architected/service-guides/azure-blob-storage) is scalable and secure object storage for archives, data lakes, high-performance computing, machine learning, and cloud-native workloads. In this architecture, Blob Storage provides object storage for unstructured data and archival requirements of the refactored mainframe applications.

- [ExpressRoute](/azure/well-architected/service-guides/azure-expressroute) is a connectivity service that extends your on-premises networks into Azure over a private, dedicated fiber connection from a connectivity provider. ExpressRoute establishes connections to Microsoft cloud services like Azure and Microsoft 365. In this architecture, ExpressRoute provides secure, high-bandwidth connectivity between on-premises mainframe environments and the refactored applications that run on Azure.

- [NetApp Files](/azure/well-architected/service-guides/azure-netapp-files) is a fully managed file storage service that provides enterprise-grade Azure file shares that are powered by NetApp, making it easy for enterprises to migrate and run complex, file-based applications with no code changes. In this architecture, NetApp Files provides high-performance file storage for enterprise-grade refactored mainframe applications that require advanced file system capabilities.

- [Site Recovery](/azure/site-recovery/site-recovery-overview) is a disaster recovery service that mirrors Azure VMs to a secondary Azure region for quick failover and data recovery if an Azure datacenter fails. In this architecture, Site Recovery provides business continuity and disaster recovery capabilities for the refactored mainframe applications.

## Scenario details

There are many reasons to look for alternatives to the COBOL-based mainframe applications that are still common:

- COBOL and CA-Gen/Natural/Telon/ASDO developers are retiring and no one is trained to replace them, resulting in a steadily diminishing talent pool. As the talent shortage grows, the costs and risks of relying on COBOL and other legacy languages increase.
- The applications weren't designed for modern IT, resulting in difficult integrations and limited flexibility.
- IBM mainframe hardware and software are expensive, and licensing and maintenance fees for ancillary mainframe applications and databases are rising.

Advanced's Automated COBOL Refactoring solution refactors COBOL applications, as well those written other legacy languages, to deliver cloud-enabled applications and databases that are functionally equivalent to their legacy counterparts. This reduces costs, allows for deeper integration, and enables customization to meet business requirements. In addition, it unlocks a whole new world of quality and scalability, from automated testing to quality assurance, and the ability to benefit from containerized deployments and orchestration with Docker and Kubernetes.

The refactored applications:

- Are functionally equivalent to the originals.
- Are easy to maintain—they attain SonarQube A ratings, and follow object-oriented concepts and paradigms.
- Perform as well as, or better than, the originals.
- Are cloud-ready and delivered by using a standard DevOps toolchain and best practices.

The refactoring process includes flow normalization, code restructuring, data layer extraction, data remodeling, and packaging for reconstruction. The process identifies cloned code and creates shared replacement objects, simplifying maintenance and manageability. Complex data and control dependency analysis locates and removes dead code.

Once the Advanced solution refactors the COBOL applications and associated databases, Java and C# developers can use standard DevOps tools and CI/CD concepts to extend application functionality. The refactoring process preserves business logic and optimizes performance. Additional benefits include elasticity, granular service definition, and easy integration with cloud-native services.

Automated COBOL Refactoring is available for most COBOL dialects and platforms, including z/OS, OpenVMS, and VME.

## Potential use cases

Advanced refactoring benefits many scenarios, including:

- Businesses seeking to:
  - Modernize infrastructure and escape the exorbitant costs, limitations, and rigidity associated with mainframes.
  - Avoid the risk associated with skills shortages around legacy systems and applications by going cloud-native and DevOps.
  - Reduce operational and capital expenditure costs.
- Organizations wanting to migrate mainframe workloads to the cloud without costly and error-prone manual rewrites.
- Organizations that need to migrate business-critical applications while maintaining continuity with other on-premises applications.
- Teams looking for the horizontal and vertical scalability that Azure offers.
- Businesses that favor solutions that have disaster recovery options.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

Resiliency is built into this solution by the load balancers. If one presentation or transaction server fails, other servers behind the load balancers can run the workloads according to the rules and health probes. Availability sets and geo-redundant storage are highly recommended.

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

This solution uses an Azure network security group to manage traffic between Azure resources. For more information, see [Network security groups](/azure/virtual-network/network-security-groups-overview).

Private Link for Azure SQL Database provides a private, direct connection that's isolated to the Azure networking backbone from the Azure VMs to Azure SQL Database.

[Azure Bastion](/azure/bastion/bastion-overview) maximizes admin access security by minimizing open ports. Bastion provides secure and seamless RDP/SSH connectivity to virtual network VMs directly from the Azure portal over TLS.

### Cost Optimization

Cost Optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

Azure avoids unnecessary costs by identifying the correct number of resource types, analyzing spending over time, and scaling to meet business needs without overspending.

- Azure provides cost optimization by running on VMs. You can turn off the VMs when they're not in use, and script a schedule for known usage patterns. For more information about cost optimization for VM instances, see [Azure Well-Architected Framework](/azure/well-architected/).
- The VMs in this architecture use either Premium SSD or Ultra Disk Storage. For more information about disk options and pricing, see [Managed Disks pricing](https://azure.microsoft.com/pricing/details/managed-disks).
- SQL Database optimizes costs with serverless compute and Hyperscale storage resources that automatically scale. For more information about SQL Database options and pricing, see [Azure SQL Database pricing](https://azure.microsoft.com/pricing/details/azure-sql-database/single).
- Use the [Pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate costs for your implementation of this solution.

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

Refactoring not only supports faster cloud adoption, but also promotes adoption of DevOps and Agile working principles. You have full flexibility in development and production deployment options.

### Performance Efficiency

Performance Efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

- The architecture uses [Azure Site Recovery](https://azure.microsoft.com/services/site-recovery) to mirror Azure VMs to a secondary Azure region for quick failover and disaster recovery if an Azure datacenter fails.
- [Azure auto-failover group replication](/azure/azure-sql/database/auto-failover-group-overview?tabs=azure-powershell) manages the database replication and failover to the secondary region.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.* 

Principal author:

 - [Bhaskar Bandam](https://www.linkedin.com/in/bhaskar-bandam-75202a9/) | Senior TPM
 
*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- For more information, please contact legacy2azure@microsoft.com.
- [Automated COBOL Refactoring Factsheet (PDF)](https://uat.modernsystems.oneadvanced.com/globalassets/modern-systems-assets/resources/application-modernization-collateral/mdsy-factsheets/automated-application-refactoring-factsheet.pdf)

## Related resources

- [Azure mainframe and midrange architecture concepts and patterns](/azure/architecture/mainframe/mainframe-midrange-architecture)
- [IBM z/OS mainframe migration with Avanade AMT](../../example-scenario/mainframe/avanade-amt-zos-migration.yml)
- [Rehost mainframe applications to Azure with Raincode compilers](../../reference-architectures/app-modernization/raincode-reference-architecture.yml)

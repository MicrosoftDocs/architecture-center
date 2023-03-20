Astadia’s automated COBOL refactoring solution delivers cloud-enabled applications and databases that do the same things as their legacy counterparts. The refactored applications run as Azure applications in virtual machines provided by Azure Virtual Machines. Azure ExpressRoute makes them available to users, and Azure Load Balancer distributes the load.

## Mainframe architecture

Here's a mainframe architecture that represents the kind of system that's suitable for the Astadia refactoring solution.

:::image type="content" source="media/refactor-mainframe-applications-astadia-pre.png" alt-text="Diagram for a mainframe architecture that's suitable for Astadia refactoring." lightbox="media/refactor-mainframe-applications-astadia-pre.png" :::

### Dataflow

1. TN3270 and HTTP(S) user input arrives over TCP/IP.
1. Mainframe input uses standard mainframe protocols.
1. There are batch and online applications.
1. Applications written in COBOL, PL/I, Assembler, and other languages run in an enabled environment.
1. Data is held in files and in hierarchical, network, and relational databases.
1. Commonly used services include program execution, I/O operations, error detection, and protection within the environment.
1. Middleware and utility services manage tape storage, queueing, output, and web activity.
1. Each operating system runs in its own partition.
1. Partitions segregate different workloads or work types.

## Azure architecture

Here's an Azure architecture to replace the mainframe functionality with refactored applications.

:::image type="content" source="media/refactor-mainframe-applications-astadia-post.png" alt-text="Architecture diagram for an Astadia refactoring solution." lightbox="media/refactor-mainframe-applications-astadia-post.png" :::

*Download a [Visio file](https://arch-center.azureedge.net/US-1930135-refactor-mainframe-applications-astadia.vsdx) of this architecture.*

### Dataflow

1. Input comes from remote clients and other users via ExpressRoute. TCP/IP is the primary way to connect to the system.
   - On-premises users access web-based applications over Transport Layer Security (TLS) port 443. The user interfaces stay the same to minimize end user retraining.
   - On-premises administrative access uses Azure Bastion hosts.
   - Azure users connect to the system via virtual network peering.
1. Load Balancer manages access to the application compute clusters. Load Balancer supports scale-out compute resources to handle input. It operates at level-7, application level, or level-4, network level, depending on the application input.
1. Astadia runtime libraries run refactored applications on Azure Virtual Machines. Compute resources use Azure Premium SSD or Azure Ultra Disk Storage managed disks with accelerated networking.
1. Data services in the application clusters support multiple connections to persistent data sources. Azure Private Link provides private connectivity from inside the virtual network to Azure services. Data sources include data services such as Azure SQL Database and Azure PostgreSQL.
1. Data storage is local-redundant or geo-redundant, depending on usage. It's a mixture of:
   - High-performance storage:
     - Premium SSD
     - Ultra Disk Storage
   - Azure Standard SSD, including blob, archive, and backup storage
1. Azure data services provide scalable and highly available data storage that compute clusters share. The storage can be geo-redundant.
   - Azure Blob Storage serves as a landing zone for data from external data sources.
   - Azure Data Factory ingests data and synchronizes multiple Azure and external data sources.
1. Azure Site Recovery provides disaster recovery for virtual machines (VMs) and container cluster components.
1. Services like Azure Active Directory, Azure Networking, Azure DevOps, Azure Stream Analytics, Azure Databricks, GitHub, and Power BI are easily integrated with the modernized system.

### Components

- [ExpressRoute](https://azure.microsoft.com/services/expressroute) extends on-premises networks into Azure over a private, dedicated fiber connection from a connectivity provider. ExpressRoute establishes connections to Microsoft cloud services like Azure and Microsoft 365.
- [Azure Bastion](https://azure.microsoft.com/services/azure-bastion) provides seamless Remote Desktop Protocol (RDP) or secure shell (SSH) connectivity to virtual network VMs from the Azure portal over TLS. Azure Bastion maximizes administrative access security by minimizing open ports.
- [Load Balancer](https://azure.microsoft.com/services/load-balancer) distributes incoming traffic to the compute resource clusters. It uses configurable rules and other criteria to distribute the traffic.
- [Azure Virtual Machines](https://azure.microsoft.com/services/virtual-machines) offers many sizes and types of on-demand, scalable VMs. With Azure Virtual Machines, you get the flexibility of virtualization and you don't have to buy and maintain physical hardware.
- [Azure Virtual Network](https://azure.microsoft.com/services/virtual-network) is the fundamental building block of Azure private networks. VMs within virtual networks communicate securely with each other, with the internet, and with on-premises networks. A virtual network is like a traditional on-premises network, but with Azure infrastructure benefits like scalability, high availability, and isolation.
- [Private Link](https://azure.microsoft.com/services/private-link) provides private connectivity from virtual networks to Azure services. Private Link simplifies network architecture and secures the connection between Azure endpoints by eliminating public internet exposure.
- [Azure Storage](https://azure.microsoft.com/product-categories/storage) is scalable, secure cloud storage for all your data, applications, and workloads.
  - [Azure Disk Storage](https://azure.microsoft.com/services/storage/disks) is high-performance, durable block storage for business-critical applications. Azure managed disks are block-level storage volumes that are managed by Azure on VMs. The available types of disks are Ultra Disk Storage, Premium SSD, Standard SSD, and Azure Standard HDD. This architecture uses either Premium SSD or Ultra Disk Storage.
  - [Azure Files](https://azure.microsoft.com/services/storage/files) provides fully managed file shares in the cloud that are accessed via the industry standard Server Message Block (SMB) protocol. Cloud and on-premises Windows, Linux, and macOS deployments share access by mounting file shares concurrently.
  - [Azure NetApp Files](https://azure.microsoft.com/services/netapp) provides enterprise grade Azure file shares that are powered by NetApp. NetApp Files makes it easy for enterprises to migrate and run complex, file-based applications without changing code.
  - [Blob Storage](https://azure.microsoft.com/services/storage/blobs) is scalable and secure object storage for archives, data lakes, high-performance computing, machine learning, and cloud-native workloads.
- Azure has fully managed relational, NoSQL, and in-memory databases to fit modern application needs. Automated infrastructure management provides scalability, availability, and security. For an overview of the database types, see [Types of Databases on Azure](https://azure.microsoft.com/product-categories/databases).
  - [SQL Database](https://azure.microsoft.com/products/azure-sql/database) is a fully managed database engine. SQL Database always runs on the latest stable version of SQL Server and a patched OS with high availability. Built-in database management capabilities include upgrading, patching, backups, and monitoring. With these tasks taken care of, you can focus on domain-specific, business-critical database administration and optimization.
  - [Azure Database for PostgreSQL](https://azure.microsoft.com/services/postgresql) is a fully managed database that's based on the open-source Postgres relational database engine. For applications that require greater scale and performance, the [Hyperscale (Citus) deployment option](/azure/postgresql/hyperscale) scales queries across multiple machines by sharding them.
  - [Azure Cosmos DB](https://azure.microsoft.com/services/cosmos-db) is a fully managed, fast NoSQL database with open APIs for any scale.
- [Site Recovery](https://azure.microsoft.com/services/site-recovery) mirrors VMs to a secondary Azure region for quick failover and disaster recovery if an Azure datacenter fails.
- [Data Factory](https://azure.microsoft.com/services/data-factory) is an extract, transfer, and load (ETL) service for scale-out serverless data integration and data transformation. It offers a code-free UI for intuitive authoring and single-pane-of-glass monitoring and management.

## Scenario details

There are important reasons why companies should replace their COBOL and mainframe systems:

- **Scarcity of domain experience:** Developers who understand COBOL and mainframe technology are retiring, and few developers are trained to replace them. The talent pool gets steadily smaller and the costs and risks of relying on COBOL rise.
- **Limited flexibility:** COBOL and the underlying systems that support it weren't designed for modern cloud-based applications. They're inflexible and hard to integrate.
- **Exorbitant costs:** IBM mainframe hardware and software costs are high. Licensing and maintenance fees for ancillary mainframe applications and databases are rising.

There *is* a way forward for COBOL and mainframe systems. Astadia’s automated COBOL refactoring solution delivers cloud-enabled applications and databases that do the same things as their legacy counterparts. The refactored applications run as Azure applications in virtual machines provided by Azure Virtual Machines. Azure ExpressRoute makes them available to users, and Azure Load Balancer distributes the load.

Refactoring reduces costs and allows for deeper integration and for customization to meet business requirements. The hassles and costs of COBOL and the mainframe give way to a new world of quality and scalability that includes:

- Automated testing and quality assurance.
- Docker and Kubernetes for containerized deployment and orchestration.

The refactoring solution creates applications that:

- Are functionally equivalent to their original counterparts.
- Are written in your choice of Java or C#.
- Follow object-oriented concepts and paradigms.
- Are easy to maintain.
- Perform as well as the applications they replace, or better.
- Are cloud-ready.
- Are delivered using a standard DevOps toolchain and best practices.

The refactoring process includes flow normalization, code restructuring, data layer extraction, data remodeling, and packaging for reconstruction. It identifies cloned code and replaces it with shared objects for simpler maintenance and manageability. The process also identifies and removes dead code by analyzing data and control dependencies.

Java and C# developers adapt refactored applications for cloud optimization by using standard DevOps tools and continuous integration and continuous delivery (CI/CD) concepts. Such tools and methods aren’t available for mainframe applications. Optimization delivers efficiencies and business benefits such as elasticity, granular service definition, and easy integration with cloud-native services.

### Potential use cases

Automated refactoring is available for most COBOL dialects and platforms, including z/OS, OpenVMS, and VME. Candidates for using it include organizations seeking to:

- Modernize infrastructure and escape the high costs, limitations, and rigidity of  mainframe systems.
- Avoid the risks of shortages of COBOL and mainframe developers.
- Reduce operational costs and capital expenditures.
- Move mainframe workloads to the cloud without the costs and risks of prolonged manual rewrites.
- Migrate mission-critical applications to the cloud while maintaining continuity with other on-premises applications.
- Make their systems horizontally and vertically scalable.
- Implement disaster recovery techniques.

## Considerations

The considerations in this section, based on the [Microsoft Well-Architected Framework](/azure/architecture/framework), apply to this solution.

### DevOps

Refactoring not only supports faster cloud adoption, but also promotes adoption of DevOps and agile development principles. You have full flexibility in development and production deployment options.

### Reliability

- The architecture uses Site Recovery to mirror VMs to a secondary Azure region for quick failover and disaster recovery if an Azure datacenter fails.
- The auto-failover groups feature of SQL Database provides data protection by managing database replication and failover to the secondary region. For more information, see [Auto-failover groups overview & best practices (Azure SQL Database)](/azure/azure-sql/database/auto-failover-group-sql-db).
- Resiliency is built into this solution by using Load Balancer. If one presentation or transaction server fails, other servers run the workloads.
- We recommend that you create availability sets for your VMs to increase availability. For more information, see [Availability sets overview](/azure/virtual-machines/availability-set-overview).
- We recommend that you use geo-replication to increase reliability. For more information, see [Azure Storage redundancy](/azure/storage/common/storage-redundancy).

### Scalability

This solution supports deployment in containers, VMs, or Virtual Machine Scale Sets. Containers and Virtual Machine Scale Sets, unlike VMs, scale out and in rapidly. Shifting the unit of scaling to containers optimizes infrastructure utilization.

### Security

- This solution uses an Azure network security group to manage traffic to and from Azure resources. For more information, see [Network security groups](/azure/virtual-network/network-security-groups-overview).
- Private Link for Azure SQL Database provides a private, direct connection that's isolated to the Azure networking backbone and that runs between VMs and SQL Database.
- Azure Bastion maximizes admin access security by minimizing open ports. It provides secure and seamless RDP/SSH connectivity to virtual network VMs directly from the Azure portal over TLS.

### Cost optimization

- Azure avoids unnecessary costs by identifying the correct number of resource types, analyzing spending over time, and scaling in advance to meet business needs without overspending.
- Azure minimizes costs by running on VMs. You can turn off the VMs that aren't being used, and provide a schedule for known usage patterns. For more information about cost optimization for VMs, see [Virtual Machines](/azure/architecture/framework/cost/optimize-vm).
- The VMs in this architecture use either Premium SSD or Ultra Disk Storage. For more information about disk options and pricing, see [Managed Disks pricing](https://azure.microsoft.com/pricing/details/managed-disks).
- SQL Database optimizes costs with serverless compute and Hyperscale storage resources that automatically scale. For more information about SQL Database options and pricing, see [Azure SQL Database pricing](https://azure.microsoft.com/pricing/details/azure-sql-database/single).
- Use the [Pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate costs for your implementation of this solution.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Richard Cronheim](https://www.linkedin.com/in/richcronheim) | Senior Program Manager

Other contributor:

- [Bhaskar Bandam](https://www.linkedin.com/in/bhaskar-bandam-75202a9) | Senior Program Manager

## Next steps

- For more information, contact legacy2azure@microsoft.com.

#### Azure

- [What is Accelerated Networking?](/azure/virtual-network/accelerated-networking-overview)
- [How network security groups filter network traffic](/azure/virtual-network/network-security-group-how-it-works).
- [Types of Databases on Azure](https://azure.microsoft.com/product-categories/databases)

#### Astadia website

- [Migrating Mainframe Applications to Azure](https://www.astadia.com/technologies/azure-cloud-migration)
- [United States Air Force (case study)](https://www.astadia.com/case-studies/united-states-air-force)
- [Jefferson County (case study)](https://www.astadia.com/case-studies/jefferson-county)

#### Other

- [Automated Data Migration](https://modernsystems.oneadvanced.com/services/automated-data-migration)

## Related sources

- [High-volume batch transaction processing](process-batch-transactions.yml)
- [General mainframe refactor to Azure](general-mainframe-refactor.yml)
- [IBM z/OS mainframe migration with Avanade AMT](asysco-zos-migration.yml)
- [IBM z/OS online transaction processing on Azure](ibm-zos-online-transaction-processing-azure.yml)
- [Micro Focus Enterprise Server on Azure VMs](micro-focus-server.yml)
- [Refactor IBM z/OS mainframe coupling facility (CF) to Azure](../../reference-architectures/zos/refactor-zos-coupling-facility.yml)
- [Refactor mainframe applications with Advanced](refactor-mainframe-applications-advanced.yml)
- [Refactor mainframe computer systems that run Adabas & Natural](refactor-adabas-aks.yml)
- [Refactor mainframe applications to Azure with Raincode compilers](../..//reference-architectures/app-modernization/raincode-reference-architecture.yml)
- [Use LzLabs Software Defined Mainframe (SDM) in an Azure VM deployment](lzlabs-software-defined-mainframe-in-azure.yml)
- [Migrate IBM mainframe applications to Azure with TmaxSoft OpenFrame](../../solution-ideas/articles/migrate-mainframe-apps-with-tmaxsoft-openframe.yml)

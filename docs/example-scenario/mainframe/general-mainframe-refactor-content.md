The following architecture illustrates a general refactoring approach that can use Azure Kubernetes Service (AKS) or Azure virtual machines (VMs). This choice depends on the portability of existing applications and your preference. Refactoring can accelerate the move into Azure by automatically converting code to Java or .NET and converting pre-relational databases to relational databases.

## Mainframe architecture

:::image type="complex" border="false" source="media/general-mainframe.svg" alt-text="Diagram that shows components of a typical mainframe system." lightbox="media/general-mainframe.svg":::
   A diagram that illustrates the components of a typical mainframe system. The diagram is divided into multiple sections: Communications, Transaction processing monitor and applications, Data and databases, Common services, Operating system on partition, and Partition. The diagram includes icons that represent an admin user using a TN3270 terminal emulator and a web interface user accessing via TLS 1.3 port 443. The Communications section includes various protocols such as LU 2/6.2, TN3270/TN3270E, Sockets, and UTS. The Transaction processing monitor and applications section includes batch new app domains, a transaction monitoring facility, and two Applications sections that include COBOL, PL/I, Assembler, and 4GL. The Common services section includes execution, I/O, error detection, and protection. The Data and databases section shows hierarchical or network database systems, data files, and relational databases. The Integration middleware section has three subsections. The Middleware subsection includes web services, management, transaction management, and queueing. The Environment integrators subsection includes queueing, management, and output. The Other services section includes tape storage and monitoring.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/mainframe-general-azure-refactor.vsdx) of this architecture.*

### Workflow

The following workflow corresponds to the previous diagram:

- **A:** On-premises users access the mainframe over Transmission Control Protocol/Internet Protocol (TCP/IP) by using standard mainframe protocols like TN3270 and HTTPS.

- **B:** Receiving applications can be either batch systems or online systems.

- **C:** Enabled environments support common business-oriented language (COBOL), Programming Language One (PL/I), Assembler, or compatible languages.

- **D:** Typical data and database services include hierarchical or network database systems, index or flat data files, and relational databases.

- **E:** Common services include program implementation, input/output operations, error detection, and protection.

- **F:** Middleware and utility services manage tape storage, queueing, output, and web services.

- **G:** Operating systems are the interface between the compute engine and the software.

- **H:** Partitions run separate workloads or segregate work types within the environment.

## Refactored Azure architecture

:::image type="complex" border="false" source="media/general-mainframe-refactor.svg" alt-text="Diagram that shows components of a refactored mainframe system on Azure." lightbox="media/general-mainframe-refactor.svg":::
   The image is a detailed diagram that shows components of a refactored mainframe system on Azure. The On-premises section includes icons for web browsing and firewall access via TCP port 443 to Azure. The Azure section contains several components: Azure load balancers, an Azure Kubernetes service cluster, virtual machines, and a network security group. This section has two subsections. One subsection contains a Kubernetes node, a Java app server, Java services, Partner Java classes, SSD managed disk, Accelerated networking with RDMA, Azure Files, Azure NetApp Files, and CIFS or NFS. The second subsection contains the refactored app server, client transaction runtimes, partner data services integration, applications like COBOL and PL/I App 1 and App 2, SSD managed disk, Accelerated networking with RDMA, Azure Files, and CIFS or NFS. Multiple double-sided arrows connect these subsections to other sections in the diagram. The Azure SQL databases section includes a primary database server and a secondary database server, connected by double-sided arrows to the Private Link for Azure SQL Database section. The Azure Blob Storage account section contains a landing zone from external sources and Azure Blob containers. The data services section includes Azure Data Factory, Azure Files storage account, and Azure Site Recovery. A section that groups Microsoft Entra ID, Azure Networking, Azure Stream Analytics, Azure Databricks, and Power BI can be integrated with the system.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/mainframe-general-azure-refactor.vsdx) of this architecture.*

### Workflow

The following workflow corresponds to the previous diagram:

1. Input comes from remote clients via Azure ExpressRoute or from other Azure users. TCP/IP is the primary way to connect to the system.

   - On-premises users can access web-based applications over Transport Layer Security (TLS) port 443. The presentation layers of the web applications can remain unchanged to minimize user retraining. Or you can update the presentation layers with modern UX frameworks.

   - On-premises administrative access uses Azure Bastion hosts to maximize security by minimizing open ports.

   - Azure users connect to the system via virtual network peering.

1. In Azure, Azure Load Balancer manages access to the application compute clusters. Load Balancer supports scale-out compute resources to handle input. You can use a level-7 application level or level-4 network level load balancer, depending on how the application input reaches the compute cluster entry point.

1. Application compute clusters can run on Azure VMs or run in containers in AKS clusters. Mainframe system emulation for PL/I or COBOL applications typically uses VMs. Applications refactored to Java or .NET use containers. Some mainframe system emulation software also supports deployment in containers. Compute resources use Azure Premium SSD disks or Azure Ultra Disk Storage with accelerated networking and remote direct memory access (RDMA).

1. Application servers in the compute clusters host the applications based on language capability, such as Java classes or COBOL programs. The servers receive application input and share application state and data by using Azure Managed Redis or RDMA.

1. Data services in the application clusters support multiple connections to persistent data sources. Azure Private Link provides private connectivity from within the virtual network to Azure services. Data sources can include:

   - Platform as a service (PaaS) data services like Azure SQL Database, Azure Cosmos DB, and Azure Database for PostgreSQL - Hyperscale.

   - Databases on VMs, such as Oracle or Db2.

   - Big data repositories like [Azure Databricks](https://azure.microsoft.com/products/databricks) and Azure Data Lake Storage.

   - Streaming data services like Apache Kafka and [Azure Stream Analytics](https://azure.microsoft.com/products/stream-analytics).

1. Data storage can be either local-redundant or geo-redundant, depending on usage. Data storage can use a combination of:

   - High-performance storage with Ultra Disk Storage or Premium SSD.

   - File storage with Azure NetApp Files or Azure Files.
   
   - Standard storage, including blob, archive, and backup options.

1. Azure PaaS data services provide scalable and highly available data storage that you can share among compute cluster resources. This storage can also be geo-redundant.

   - Azure Blob Storage is a common landing zone for external data sources.

   - Azure Data Factory supports data ingestion and synchronization of multiple Azure and external data sources.

1. Azure Site Recovery provides disaster recovery (DR) for VM and container cluster components.

1. Services like [Microsoft Entra ID](https://www.microsoft.com/security/business/identity-access/microsoft-entra-id), [Azure Networking](https://azure.microsoft.com/products/category/networking), Stream Analytics, Azure Databricks, and [Power BI](https://www.microsoft.com/power-platform/products/power-bi/) can easily integrate with the modernized system.

### Components

This example features the following Azure components. Several of these components and workflows are interchangeable or optional, depending on your scenario.

- [ExpressRoute](/azure/well-architected/service-guides/azure-expressroute) is a service that extends your on-premises networks into Azure over a private, dedicated fiber connection from a connectivity provider. In this architecture, ExpressRoute establishes connections to Microsoft cloud services like Azure and Microsoft 365.

- [Azure Bastion](/azure/bastion/bastion-overview) is a PaaS service that provides seamless Remote Desktop Protocol (RDP) or secure shell (SSH) connectivity to virtual network VMs from the Azure portal over TLS. In this architecture, Azure Bastion maximizes administrative access security by minimizing open ports.

- [Load Balancer](/azure/well-architected/service-guides/azure-load-balancer) is a service that distributes incoming traffic to the compute resource clusters. Use this component to define rules and other criteria to distribute the traffic. Load Balancer allows for scale-out compute resources to process the input work, which helps ensure efficient load distribution.

- [AKS](/azure/well-architected/service-guides/azure-kubernetes-service) is a fully managed Kubernetes service for deploying and managing containerized applications. In this architecture, AKS provides serverless Kubernetes, an integrated continuous integration and continuous delivery (CI/CD) experience, and enterprise-grade security and governance.

- [Azure Virtual Machines](/azure/well-architected/service-guides/virtual-machines) is a service that provides many sizes and types of on-demand, scalable computing resources. This component provides the flexibility of virtualization without the need to buy and maintain physical hardware.

- [Azure Virtual Network](/azure/well-architected/service-guides/virtual-network) serves as the fundamental building block of Azure private networks. A virtual network is like a traditional on-premises network, but it has Azure infrastructure benefits like scalability, high availability, and isolation. This component allows Azure VMs within virtual networks to communicate more securely with each other, the internet, and on-premises networks.

- [Private Link](/azure/private-link/private-link-overview) is a service that provides private connectivity from a virtual network to Azure services. In this architecture, Private Link simplifies network architecture and secures the connection between Azure endpoints by eliminating exposure to the public internet.

- [Azure Managed Redis](/azure/redis/overview) is a fully managed service that adds a caching layer to application architecture to handle large volumes at high speed. This architecture component scales performance simply and cost-effectively.

- [Azure Storage](/azure/storage/common/storage-introduction) is a cloud-based service that provides scalable, secure cloud storage for all your data, applications, and workloads. In this architecture, Storage provides the necessary storage infrastructure for various data types and applications.

  - [Azure Disk Storage](/azure/virtual-machines/managed-disks-overview) is a high-performance, durable block storage service for business-critical applications. Azure managed disks are block-level storage volumes that Azure manages on Azure VMs. The available types of disks are Ultra Disk Storage, Premium SSD, and Azure Standard SSD. This architecture uses either Premium SSD disks or Ultra Disk Storage.

  - [Azure Files](/azure/well-architected/service-guides/azure-files) is a fully managed cloud-based file storage service that provides file shares in the cloud. These file shares are accessible via the industry-standard Server Message Block (SMB) protocol. In this architecture, Azure Files provides managed file shares for cloud and on-premises deployments. Cloud and on-premises Windows, Linux, and macOS deployments can mount Azure Files file shares concurrently.

  - [Azure NetApp Files](/azure/well-architected/service-guides/azure-netapp-files) is a fully managed file storage service that provides enterprise-grade Azure file shares powered by NetApp. Use it to migrate and run complex, file-based applications without requiring code changes.

  - [Blob Storage](/azure/well-architected/service-guides/azure-blob-storage) is scalable and secure object storage for archives, data lakes, high-performance computing, machine learning, and cloud-native workloads. In this architecture, Blob Storage serves as a common landing zone for external data sources.

- [Azure databases](https://azure.microsoft.com/product-categories/databases) provide a choice of fully managed relational and NoSQL databases to fit modern application needs. Automated infrastructure management provides scalability, availability, and security.

  - [SQL Database](/azure/well-architected/service-guides/azure-sql-database-well-architected-framework) is a fully managed PaaS database engine. In this architecture, it provides scalable and highly available data storage to share across multiple compute resources in a cluster. SQL Database always runs on the latest stable version of SQL Server and a patched operating system that has 99.99% availability. Built-in PaaS database management capabilities include upgrading, patching, backups, and monitoring. You can use SQL Database to focus on domain-specific, business-critical database administration and optimization.

  - [Azure Database for PostgreSQL](/azure/well-architected/service-guides/postgresql) is a fully managed database based on the open-source Postgres relational database engine. In this architecture, it provides the [Hyperscale (Citus) deployment option](https://techcommunity.microsoft.com/blog/adforpostgresql/when-to-use-hyperscale-citus-to-scale-out-postgres/1958269), which scales queries across multiple machines by using sharding. This capability is helpful for applications that require greater scale and performance.

  - [Azure Cosmos DB](/azure/well-architected/service-guides/cosmos-db) is a fully managed, fast NoSQL database that has open APIs for any scale. In this architecture, Azure Cosmos DB provides scalable and highly available data storage for various applications.

- [Site Recovery](/azure/site-recovery/site-recovery-overview) is a DR service that mirrors Azure VMs to a secondary Azure region. This capability enables quick failover and recovery if an Azure datacenter failure occurs. In this architecture, Site Recovery supports DR for both the VM and container cluster components.

## Scenario details

Refactoring workloads to Azure can transform mainframe applications that run on Windows Server or Linux. You can run these applications more cost effectively by using cloud-based Azure infrastructure as a service and PaaS.

The general refactoring approach for mainframe applications drives infrastructure transformation and shifts systems from legacy proprietary technologies to standardized, benchmarked, open solutions. This transformation supports agile DevOps principles, which are the foundation of today's high-productivity, open-systems standards. Refactoring replaces isolated legacy infrastructures, processes, and applications with a unified environment that enhances business and IT alignment.

This general refactoring approach can use AKS or Azure VMs. The choice depends on the portability of existing applications and your preference. Refactoring can accelerate the move to Azure by automatically converting code to Java or .NET and converting pre-relational databases to relational databases.

Refactoring supports various methods for moving client workloads to Azure. One method is to convert and migrate the entire mainframe system to Azure in a single, comprehensive process. This approach eliminates the need for interim mainframe maintenance and facility support costs. However, this method carries some risk because all application conversion, data migration, and testing processes must align to ensure a smooth transition from the mainframe to Azure.

Another method is to migrate applications from the mainframe to Azure gradually, with the aim to transition over time. This approach provides cost savings for each application. It also provides an opportunity to learn from each conversion to inform and improve subsequent migrations. This method provides a more manageable and less intensive alternative to migrating everything at once by modernizing each application according to its own schedule.

### Potential use cases

Refactoring on Azure can help organizations to:

- Modernize infrastructure and avoid the high costs, limitations, and rigidity of mainframes.
- Migrate mainframe workloads to the cloud while avoiding the complexities of a complete redevelopment.
- Migrate business-critical applications while maintaining continuity with other on-premises applications.
- Benefit from horizontal and vertical scalability on Azure.
- Gain DR capabilities.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability helps ensure that your application can meet the commitments that you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

In this architecture, [Site Recovery](/azure/site-recovery/site-recovery-overview) mirrors the Azure VMs to a secondary Azure region for quick failover and DR if the primary Azure datacenter fails.

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

- This solution uses an Azure network security group (NSG) to manage traffic between Azure resources. For more information, see [NSGs](/azure/virtual-network/network-security-groups-overview).

- Private Link provides private, direct connections isolated to the Azure networking backbone between the Azure VMs and Azure services.

- Azure Bastion maximizes administrative access security by minimizing open ports. Azure Bastion provides highly secure and seamless RDP and SSH connectivity to virtual network VMs from the Azure portal over TLS.

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

- Azure avoids unnecessary costs by identifying the correct number of resource types, analyzing spending over time, and scaling to meet business needs without overspending. Azure provides cost optimization by running on VMs. You can turn off the VMs when they're not in use and script a schedule for known usage patterns. For more information, see [Azure Well-Architected Framework](/azure/well-architected/) and [Recommendations for optimizing component costs](/azure/well-architected/cost-optimization/optimize-component-costs).

- The VMs in this architecture use either Premium SSD disks or Ultra Disk Storage. For more information, see [Managed disks pricing](https://azure.microsoft.com/pricing/details/managed-disks).

- SQL Database optimizes costs by using serverless compute and Hyperscale storage resources that automatically scale. For more information, see [SQL Database pricing](https://azure.microsoft.com/pricing/details/azure-sql-database/single).

Use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate costs for your implementation of this solution.

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

Refactoring supports faster cloud adoption and promotes the adoption of both DevOps and Agile working principles. You have full flexibility in development and production deployment options.

### Performance Efficiency

Performance Efficiency refers to your workload's ability to scale to meet user demands efficiently. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

The [load balancers](/azure/load-balancer/load-balancer-overview) integrate performance efficiency into this solution. If one presentation or transaction server fails, the other servers behind the load balancers handle the workloads.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [Jonathon Frost](https://www.linkedin.com/in/jjfrost/) | Principal Software Engineer
- [Philip Brooks](https://www.linkedin.com/in/philipbbrooks/) | Senior TPM

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- For more information, contact [legacy2azure@microsoft.com](mailto:legacy2azure@microsoft.com).
- [What is ExpressRoute?](/azure/expressroute/expressroute-introduction)
- [What is Virtual Network?](/azure/virtual-network/virtual-networks-overview)
- [Introduction to Azure managed disks](/azure/virtual-machines/managed-disks-overview)
- [What is Private Link?](/azure/private-link/private-link-overview)
- [What is SQL Database?](/azure/azure-sql/database/sql-database-paas-overview)
- [What is Azure Files?](/azure/storage/files/storage-files-introduction)

## Related resources

- [Rehost mainframe applications to Azure with Raincode compilers](../../reference-architectures/app-modernization/raincode-reference-architecture.yml)
- [Unisys mainframe migration](../../reference-architectures/migration/unisys-mainframe-migration.yml)
- [IBM z/OS mainframe migration with Avanade AMT](avanade-amt-zos-migration.yml)
- [High-volume batch transaction processing](process-batch-transactions.yml)
- [Modernize mainframe and midrange data](/azure/architecture/example-scenario/mainframe/modernize-mainframe-data-to-azure)

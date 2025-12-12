CloudFrame Renovate migrates COBOL code to Java Spring Boot Batch quickly, without compromising quality, precision, functional equivalency, or performance. Renovate is a DIY tool that uses guided actions and automation to help make code migration easy. Just provide the inputs and download Maven or Gradle Java projects. No specialized skills or staff are required.

## Legacy IBM zSeries architecture

:::image type="content" source="media/cloudframe-refactor.svg" alt-text="Diagram that shows the mainframe architecture before migration." lightbox="media/cloudframe-refactor.svg" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/cloudframe-refactor-to-azure-architecture.vsdx) of the architectures in this article.*

### Workflow

A. Data is input over TCP/IP, including TN3270 and HTTP(S).

B. Data is input into the mainframe via standard mainframe protocols.

C. Middleware and utility services manage services like tape storage, queueing, output, and web services within the environment.

D. The batch application execution environment includes scheduling, workload management, and SPOOL operations.

E. Online transaction processing environments provide high availability, workload management, and XA-compliant transaction management.

F. Business applications written in COBOL, PL/I, or Assembler (or compatible languages) run in environments enabled for batch and online.

G. Shared business services standardize solutions for shared services like logging, error handling, I/O, and pre-SOA business services.

H. Data is stored in data and database services like hierarchical, network, and relational database subsystems and indexed and sequential data files.

I. Operating system partitions (virtual machines) provide the interface between the engine and the software.

J. The Processor Resource / System Manager (PR/SM) hypervisor performs direct hardware virtualization to partition physical machines into virtual machines (VMs).

## Migrated Azure architecture

:::image type="content" source="media/cloudframe-refactor-after.svg" alt-text="Diagram that shows the architecture after migration to Azure." lightbox="media/cloudframe-refactor-after.svg" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/cloudframe-refactor-to-azure-architecture.vsdx) of the architectures in this article.*

### Workflow

1. Data is typically input either via Azure ExpressRoute from remote clients or from other applications currently running Azure. In either case, TCP/IP is the primary means of connection to the system. TLS port 443 provides user access to web-based applications. You can use the web application presentation layer with minimal changes to reduce the need for training. Or you can update the web application presentation layer with modern UX frameworks as needed. You can use Azure VM bastion hosts to provide admin access to the VMs. Doing so improves security by minimizing open ports.

2. In Azure, Azure load balancers manage access to the application compute clusters to provide high availability. This approach enables scale-out of compute resources to process the input work. Layer 7 (application layer) and Layer 4 (transport layer) load balancers are available. The type used depends on the application architecture and API payloads at the entry point of the compute cluster.

3. You can deploy to a VM in a compute cluster or in a pod that can be deployed in a Kubernetes cluster. Java Business Services and applications created via Renovate run equally well on Azure VMs and Azure Kubernetes containers. For a more detailed analysis  of compute options, see [this Azure compute service decision tree](../../guide/technology-choices/compute-decision-tree.md).

4. Application servers receive the input in the compute clusters and share application state and data by using Azure Cache for Redis or Remote Direct Memory Access (RDMA).

5. Business services and applications in the application clusters allow for multiple connections to persistent data sources. These data sources can include PaaS services like Azure SQL Database and Azure Cosmos DB, databases on VMs, such as Oracle or Db2, and big data repositories like Azure Databricks and Azure Data Lake. Application data services can also connect to streaming data services like Kafka and Azure Stream Analytics.

6. Renovate runtime services provide backward compatibility with mainframe data architectures and emulation of mainframe QSAM and VSAM file systems, decoupling data migration to UTF-8 from refactoring to Java and rehosting in Azure. Additional runtime services include compatibility with SORT, IDCAMS, IE utilities, GDG retention management, and more.

7. Data services use a combination of high-performance storage (Ultra SSD / Premium SSD), file storage (Azure NetApp Files / Azure Files) and standard storage (blob, archive, backup) that can be either locally redundant or geo-redundant, depending on the use.

8. Azure platform as a service (PaaS) data services provide scalable, highly available geo-redundant data storage that's shared across compute resources in a cluster.

9. Azure Data Factory enables data ingestion and synchronization with multiple data sources both within Azure and from external sources. Azure Blob Storage is a common landing zone for external data sources.

10. Azure Site Recovery provides disaster recovery of the VM and container cluster components.

### Components

- [Azure Cache for Redis](/azure/azure-cache-for-redis/cache-overview) is a distributed, managed cache that helps you build scalable and responsive applications by providing fast access to your data. In this architecture, Azure Cache for Redis enables application servers in the compute clusters to share application state and data.

- [Azure Kubernetes Service (AKS)](/azure/well-architected/service-guides/azure-kubernetes-service) is a managed Kubernetes service that simplifies the deployment, management, and scaling of containerized applications by using Kubernetes. In this architecture, AKS provides a container orchestration platform where Java applications created via Renovate can be deployed in pods as an alternative to VMs. It provides benefits such as improved resource utilization, faster deployment times, and enhanced scalability.

- [Azure managed disks](/azure/virtual-machines/managed-disks-overview) are block-level storage volumes that Azure manages and you use with Azure VMs. In this architecture, Azure managed disks provide high-performance storage for the data services layer and we recommend either a Premium SSD or Ultra Disks type.

- [Azure Virtual Machines](/azure/well-architected/service-guides/virtual-machines) is a compute service that provides on-demand, scalable computing resources with the flexibility of virtualization without having to buy and maintain physical hardware. In this architecture, Virtual Machines hosts the Java Business Services and applications created via Renovate in compute clusters and provides the primary execution environment for the migrated mainframe workloads.

- [Azure Virtual Network](/azure/well-architected/service-guides/virtual-network) is a networking service that creates private networks in Azure and enables secure communication between Azure resources, the internet, and on-premises networks. In this architecture, Virtual Network provides the networking foundation and secure communication channels for all Azure resources in the migrated environment.

- [Data Factory](/azure/data-factory/introduction) is a cloud-based data integration service that orchestrates and automates the movement and transformation of data. In this architecture, Data Factory enables data ingestion and synchronization with multiple data sources both within Azure and from external sources, while Blob Storage serves as a common landing zone for external data sources.

- [Site Recovery](/azure/site-recovery/site-recovery-overview) is a disaster recovery service that replicates VMs and physical servers to provide business continuity during outages. In this architecture, Site Recovery provides disaster recovery for the VM and container cluster components.

- [SQL Database](/azure/well-architected/service-guides/azure-sql-database) is a fully managed PaaS database engine that handles most database management functions, like upgrading, patching, backups, and monitoring, without your involvement. SQL Database always runs on the latest stable version of the SQL Server database engine and a patched OS. In this architecture, SQL Database serves as one of the persistent data sources that business services and applications can connect to for data storage and retrieval.

## Scenario details

Using existing mainframe data and processes reduces risk and accelerates time to value. CloudFrame Renovate provides backward compatibility with mainframe data architectures and support for mainframe utilities like SORT. You can stage binary snapshots of VSAM and QSAM data in CloudFrame's emulated file systems, backed by Azure services like Blob Storage, Azure Cosmos DB, disk storage, and Azure SQL.

Refactoring mainframe applications by using Renovate moves application and infrastructure transformation from proprietary legacy solutions into standardized, benchmarked, open technologies. This transformation also moves teams toward Agile DevOps operating models.

Renovate-generated Java code is easy to understand, is rated A by SonarQube, and produces results that are functionally equivalent and data equivalent. The resulting code can be maintained by your current developers, using your DevOps processes and toolchains. Developers don't need knowledge about mainframes or COBOL to maintain the refactored application. The resulting code is highly maintainable, and the transformation risk is low.

By using Renovate's incremental modernization approach, you, and not the tool or tool vendor, can determine the granularity and speed of change. Refactoring with Renovate is a fast, low-risk way to move COBOL workloads to cloud-native Java on Azure.

### Potential use cases

Refactoring to Azure by using Renovate can help organizations and teams that want these benefits:

- More control of the modernization processes through the use of DIY tools.
- An incremental approach to modernization.
- Automated refactoring tools that can be configured according to custom requirements.
- Migration of mainframe workloads to the cloud without the consequential side effects of a complete rewrite.
- A modern infrastructure without the cost structures, limitations, and rigidity of mainframes.
- Migration of core applications while maintaining continuity with other on-premises applications.
- Solutions that offer various options for disaster recovery.
- The horizontal and vertical scalability that Azure provides.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability helps ensure that your application can meet the commitments that you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

High availability and performance are built into this solution because of the load balancers and compute autoscaling. If one presentation, transaction, or batch server fails, the other server behind the load balancer handles the workload. The architecture uses [Site Recovery](/azure/site-recovery/site-recovery-overview) to mirror Azure VMs. It uses PaaS storage and database services for replication to a secondary Azure region for quick failover and disaster recovery if an Azure datacenter fails. Finally, you can fully automate the deployment and operational architecture.

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

Security in Azure is achieved through a layered approach of policy, process, automated governance and incident reporting, training, network vulnerability analysis, penetration testing, encryption, and DevSecOps operating models. Services like Microsoft Entra ID, Azure Virtual Network, Azure Private Link, and network security groups are fundamental to achieving this enhanced security.

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

Azure provides cost optimization by running VMs and Kubernetes pods on commodity hardware, scripting a schedule to turn off VMs that aren't in use, and using Kubernetes pods to increase deployment density. Reserved and spot instances can further reduce costs. Microsoft Cost Management provides cost transparency by giving you a single, unified view of costs versus budgets. [Azure Reservations](/azure/cost-management-billing/reservations/save-compute-costs-reservations) and [Azure savings plan for compute](https://azure.microsoft.com/pricing/offers/savings-plan-compute/#benefits-and-features) generate significant discounts off of pay-as-you-go pricing. You can use these offerings separately or together to compound the savings. Use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate the cost of implementing the solution.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- Jim Dugan | Principal TPM

Other contributors:

- [Bhaskar Bandam](https://www.linkedin.com/in/bhaskar-bandam-75202a9) | Senior TPM

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- For more information about this architecture, contact [legacy2azure@microsoft.com](mailto:legacy2azure@microsoft.com).
- For more information about Renovate, see the [CloudFrame](https://cloudframe.ac-page.com/renovate-dl) website.
- For more information about the components of this architecture, see these articles:
  - [Virtual machines in Azure](/azure/virtual-machines/overview)
  - [Azure Kubernetes Service](/azure/aks/intro-kubernetes)
  - [What is Azure Virtual Network?](/azure/virtual-network/virtual-networks-overview)
  - [What is Azure SQL Database?](/azure/azure-sql/database/sql-database-paas-overview)
  - [About Site Recovery](/azure/site-recovery/site-recovery-overview)

## Related resources

- [Mainframe migration overview](/azure/cloud-adoption-framework/infrastructure/mainframe-migration)
- [Make the switch from mainframes to Azure](/azure/cloud-adoption-framework/infrastructure/mainframe-migration/migration-strategies)

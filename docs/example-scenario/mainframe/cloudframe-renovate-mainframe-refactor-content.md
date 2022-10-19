CloudFrame Renovate migrates COBOL code to Java Spring Boot / Batch quickly, without compromising quality, precision, functional equivalency, or performance. Renovate is a Do-It-Yourself (DIY) COBOL to Java refactoring tool that uses both guided actions and automation to ensure ease of use and success. Simply provide the inputs and download Maven or Gradle Java projects; no specialized skills or consulting staff are required. 

CloudFrame Renovate generated Java code is easy to understand, SonarQube A Rated, and produces functional and data equivalent results. The resulting code is ready to be maintained by your existing developers utilizing your DevOps processes and toolchains. No mainframe or COBOL knowledge is required to maintain the newly refactored application.

## Differentiators

- Highly maintainable code
- Automated COBOL to Java transformation
- Very low transformation risk
- Functional and data equivalent results guaranteed

## IBM z Series Mainframe Architecture (Pre-Migration)

diagram 

### Mainframe Architecture Annotations

A.	Input over TCP/IP including TN3270 and HTTP(S). 
B.	Input into the mainframe using standard mainframe protocols.
C.	Middleware and utility services manage such services as tapes storage, queueing, output, and web services within the environment. 
D.	Batch Application execution environment includes scheduling, workload management, and SPOOL operations.
E.	Online transaction processing environments provide high-availability, workload management, and XA compliant transaction management.
F.	Business applications written in COBOL, PL/I or Assembler (or compatible languages) run in batch and online enabled environments.
G.	Business shared services standardize solutions for common/shared services such as logging, error handling, I/O, and pre-SOA business services.
H.	Data and Database services such as hierarchical, network, and relational database subsystems, and indexed and sequential data files. 
I.	Operating systems partitions, aka virtual machines, provide the specific interface between the engine and the and the software it’s running.  
J.	Hypervisor, Processor Resource / System Manager (PR/SM), performs direct hardware virtualization to partition physical into virtual machines.

## Azure Architecture (Post Migration)

diagram 

### Workflow

1.	Input will typically come either via Express Route from remote clients, or by other applications currently running Azure.  In either case, TCP/IP 	connections will be the primary means of connection to the system.  User access provided over TLS port 443 for accessing web-based applications.  Web-based Applications presentation layer can be kept virtually unchanged to minimize end user retraining.  Alternatively, the web application presentation layer can be updated with modern UX frameworks as requirements necessitate.  Further, for admin access to the VMs, Azure VM Bastion hosts can be used to maximize security by minimizing open ports.                                                                                 
2.	Once in Azure, Azure Load balancers manage access to the application compute clusters, assuring high availability.  This approach allows for scale out compute resources to process the input work.  Both Layer 7 (Application Layer) and Layer 4 (Transport Layer) load balancers are available.  The type used will reflect the application architecture and API payloads at the entry point of the compute cluster.                               
3.	This is an opportunity to decide to deploy to a virtual machine in a compute cluster, or a pod that can be deployed in a Kubernetes cluster.  Java Business Services and Applications created using CloudFrame will run equally well in Azure VMs and Azure Kubernetes containers.  For a more detailed compute options analysis, consult this [Azure Compute Service decision tree](/azure/architecture/guide/technology-choices/compute-decision-tree).
4.	Application servers receive the input in the compute clusters and share application state and data using Redis Cache or RDMA (Remote Direct Memory Access).
5.	Business Services and Applications in the application clusters allow for multiple connections to persistent data sources.  These data sources may include PaaS such as Azure SQL DB and Cosmos DB, databases on VMs such as Oracle or Db2, or Big Data repositories such as Databricks and Azure Data Lake.  Application data services may also connect to streaming data services such as Kafka and Azure Stream Analytics.
6.	CloudFrame Renovate™ runtime services provide backward compatibility with mainframe data architecture and emulation of mainframe QSAM and VSAM file systems, decoupling data migration to UTF-8 from refactoring to Java and rehosting in Azure. Additional runtime services include compatibility with SORT, IDCAMS, IE* utilities, GDG retention management, and more.
7.	Data services use a combination of high-performance storage (ultra/premium SSD), file storage (NetApp/Azure files) and standards storage (Blob, archive, backup) that can be either local redundant or geo-redundant depending on the usage.  
8.	Azure PaaS data services provide scalable highly available geo-redundant data storage shared across compute resources in a cluster.  
9.	Azure Data Factory allows for data ingestion and synchronization with multiple data sources both within Azure and from external sources.  Azure Blob storage is a common landing zone for external data sources. 
10.	Azure Site Recovery (ASR) used for Disaster Recovery of the VM and container cluster components.

### Components

- [Azure Virtual Machines] (VMs) is one of several types of on-demand, scalable computing resources that Azure offers. An Azure VM gives you the flexibility of virtualization without having to buy and maintain the physical hardware that runs it. 
- [Azure Kubernetes Service] - Azure Kubernetes Service (AKS) offers the quickest way to start developing and deploying cloud-native apps, with built-in code-to-cloud pipelines and guardrails. Get unified management and governance for on-premises, edge, and multicloud Kubernetes clusters. Interoperate with Azure security, identity, cost management, and migration services. 
- [Azure SSD managed disks] are block-level storage volumes that are managed by Azure and used with Azure Virtual Machines. The available types of disks are Ultra Disk, Premium SSDs, Standard SSDs, and Standard Hard Disk Drives (HDDs). For this architecture, we recommend either Premium SSDs or Ultra Disk SSDs.
- [Azure Virtual Networks] - Azure Virtual Network (VNet) is the fundamental building block for your private network in Azure. VNet enables many types of Azure resources, such as Azure Virtual Machines (VM), to securely communicate with each other, the internet, and on-premises networks. VNet is similar to a traditional network that you'd operate in your own data center but brings with it additional benefits of Azure's infrastructure such as scale, availability, and isolation.
- [Azure SQL Database] - Azure SQL Database is a fully managed platform as a service (PaaS) database engine that handles most of the database management functions such as upgrading, patching, backups, and monitoring without user involvement. Azure SQL Database is always running on the latest stable version of the SQL Server database engine and patched OS with 99.99% availability. PaaS capabilities that are built into Azure SQL Database enable you to focus on the domain-specific database administration and optimization activities that are critical for your business.
- [Azure Cache for Redis] is a distributed, managed cache that helps you build highly scalable and responsive applications by providing super-fast access to your data.
- [Azure Data Factory] is a cloud-based data integration service that orchestrates and automates the movement and transformation of data.
- [Azure Site Recovery] contributes to your business continuity and disaster recovery (BCDR) strategy, by orchestrating and automating replication of Azure VMs between regions, on-premises virtual machines and physical servers to Azure, and on-premises machines to a secondary datacenter.

## Scenario details

Utilizing existing mainframe data and processes reduces risk and accelerates time to value. CloudFrame Renovate provides backward compatibility with mainframe data architecture and support for mainframe utilities such as SORT (and others). Binary snapshots of VSAM and QSAM data can be staged in CloudFrame's emulated file systems, backed by Azure services such as Blob Storage, Cosmos DB, Disk Storage, and SQL.

Refactoring mainframe applications using CloudFrame Renovate drives application and infrastructure transformation from proprietary legacy solutions into standardized, benchmarked, open technologies. This transformation also drives teams toward Agile DevOps operating models. 

CloudFrame's incremental modernization approach enables the customer, not the tool or tool vendor, to prescribe the granularity and velocity of change. Refactoring with CloudFrame Renovate is the fastest, lowest-risk method to move Cobol workloads to cloud-native Java on Microsoft Azure. 

## Potential use cases 

Many scenarios can benefit from refactoring with CloudFrame Renovate to Azure. Possibilities include the following cases:

- Organizations that want to gain more control of their modernization processes using DIY tools.
- Businesses seeking an incremental, non-Big Bang approach to modernization.
- Development teams looking for automated refactoring tools that can be configured according to their requirements.
- Organizations opting to move mainframe workloads to the cloud without the consequential side effects of a complete rewrite.
- Businesses seeking to modernize infrastructure and escape the mainframes' cost structures, limitations, and rigidity.
- Mainframe customers who need to migrate core applications while maintaining continuity with other on-premises applications.
- Businesses that favor solutions offering various options for disaster recovery.
- Teams looking for the horizontal and vertical scalability that Azure offers.

## Considerations

The following considerations, based on the Azure Well-Architected Framework, apply to this solution:

### Reliability

High availability and performance are built into this solution because of the load balancers and compute auto-scaling. If one presentation, transaction, or batch server fails, the other server behind the load balancer shoulders the workload.  The architecture uses both [Azure Site Recovery](https://azure.microsoft.com/services/site-recovery), to mirror Azure VMs, and PaaS storage and database services, for replication, to a secondary Azure region for quick failover and DR if an Azure datacenter fails. Finally, the deployment and operational architecture may be fully automated.

### Security

Security in Azure is achieved through a layered approach of policy, process, automated governance and incident reporting, training, network vulnerability analysis, penetration testing, encryption, and DevSecOps operating models. Services such as Azure Active Directory, Azure VNet, Azure Private Link, Azure Network Security Groups are fundamental to achieving this.

### Cost optimization

Azure provides cost optimization by running VMs and Kubernetes pods on commodity hardware, scripting a schedule to turn off the VMs when not in use, and Kubernetes pods for increasing deployment density. Additionally, reserved and spot instances can further reduce costs. Microsoft Cost Management provides cost transparency through a ‘Single Pane of Glass’ lens of costs versus budgets. Use [Azure Pricing Calculator](https://azure.microsoft.com/pricing/calculator) to estimate the cost of implementing the solution. [Azure Reservations](/azure/cost-management-billing/reservations/save-compute-costs-reservations) is another method to help you save money by committing to one-year or three-year plans for multiple products

## Contributors

This article is maintained by Microsoft. It was originally written by the following contributors.

Principal authors: Jim Dugan

Other contributors: Bhaskar Bandam

## Next steps

- For more information, please contact legacy2azure@microsoft.com.
- More information regarding [Cloudframe Renovate](https://cloudframe.ac-page.com/renovate-dl)

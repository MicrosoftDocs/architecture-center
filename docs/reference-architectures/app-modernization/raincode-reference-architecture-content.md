This architecture shows how the Raincode COBOL compiler modernizes mainframe legacy applications by seamlessly migrating and integrating them with a modern, Azure-based technology stack without changing a single line of code. With Raincode's compiler technology, you can keep current optimized mainframe applications and deploy them on the cloud, allowing you to preserve decades of development while greatly enhancing performance and flexibility. Raincode's solution is aimed at transforming the mainframe to an Azure-native architecture by preserving the business logic while transforming the entire architecture. Raincode supports application flexibility across Linux and Windows with containerized or virtual machine (VM) deployments on Azure.

## Architecture

### Legacy IBM z/OS architecture

The following diagram shows an example of a legacy COBOL-based mainframe architecture, before migration to Azure.

:::image type="content" source="media/raincode-reference-architecture-01.svg" alt-text="Graphical example of legacy COBOL-based mainframe architecture." lightbox="media/raincode-reference-architecture-01.svg" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/raincode-reference-architecture.vsdx) of this architecture.*

#### Workflow

The following annotations map from the source IBM z/OS to Azure:

A. IBM 3270 terminal emulation for demand and online users is replaced by a web browser to access system resources in Azure.

B. COBOL and other legacy application code is converted to C\#/.NET. Raincode generates 100-percent thread-safe and managed code for .NET and .NET Core.

C. Raincode COBOL compiler modernizes mainframe legacy applications by seamlessly migrating and integrating them with a modern, cloud-based technology stack without changing a single line of code.

D. Workload automation, scheduling, reporting, and system monitoring functions can retain current platforms, as they are Azure capable today.

E. Legacy database structures like Db2 and IDMS can be migrated to Azure SQL Database with all the DR/HA capabilities that Azure provides. Raincode also supports static or dynamic SQL queries through SQL Server or on Azure SQL DB.

F. File structures (VSAM, flat files, virtual tape, and the like) map easily to Azure data constructs within structured files and/or blob storage. Features like redundant geographic replication and Azure Auto Failover Group Replication are available to provide data protection.

G. An optional printer subsystem manages on-premises printers.

H. z/OS running on Logical Partitions (LPARs).

I. LPARs represent a subset of a computer's hardware resources. Each LPAR can host a separate OS. While this example shows only Z/OS instances, other LPARs running on the same hardware can host other operating environments, like z/VM, or other engines, like zIIP or IFL.

### Postmigration, Azure-based architecture

This diagram shows how the legacy architecture can be migrated to Azure, taking advantage of the Raincode compiler and many other modern Azure services.


:::image type="content" source="media/raincode-reference-architecture-02.svg" alt-text="Legacy architecture migration to Azure workflow." lightbox="media/raincode-reference-architecture-02.svg" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/raincode-reference-architecture.vsdx) of this architecture.*

#### Workflow

1. User access provided over TLS port 443 for accessing web-based applications. Web-based Applications presentation layer can be kept virtually unchanged to minimize end user retraining. Alternatively, the web application presentation layer can be updated with modern UX frameworks as requirements necessitate.

2. In Azure, access to the application compute clusters is through Azure Load Balancer, allowing for scale-out compute resources to process the input work.

3. Raincode system emulation software can also support deployment in containers. With Raincode's cutting-edge compiler technology, you can keep current optimized mainframe applications and deploy them on .NET Core.

4. Cloud-native applications are a collection of independent and autonomous services packaged as lightweight containers.

    Unlike virtual machines, containers can scale out and scale in rapidly. Since the unit of scaling shifts to containers, infrastructure utilization is    optimized.

5. Data services use a combination of high-performance storage on Ultra or Premium solid-state disks (SSDs), file storage on Azure NetApp Files or Azure Files, and standard blob, archive, and backup storage that can be locally redundant or geo-redundant.

6. Azure SQL Database using either Hyperscale or Business Critical tiers for both high IOPS and high uptime SLA. Further, Private Link for Azure SQL Database is used to provide a private, direct connection isolated to the Azure Networking Backbone from the Azure VM to the Azure SQL Database. Raincode data migration tools can convert DMS/RDMS schemas to SQL.

7. Azure Blob Storage is a common landing zone for external data sources.

8. An implementation of Active Directory needs to be created or already in place. Raincode provides RACF and Top Secret identity integration using Active Directory extensions.

### Components

-   [Azure Kubernetes Service (AKS)](https://azure.microsoft.com/services/kubernetes-service/) is a fully managed Kubernetes service for deploying and managing containerized applications in container-based compute clusters.

-   [Azure Virtual Network (VNet)](/azure/virtual-network/virtual-networks-overview) is the fundamental building block for your private network in Azure. VNet enables many types of Azure resources, such as Azure Virtual Machines (VM), to securely communicate with each other, the internet, and on-premises networks. VNet is similar to a traditional network that you'd operate in your own datacenter, but it brings more benefits of Azure's infrastructure, such as scale, availability, and isolation.

-   [Azure Files](/azure/storage/files/storage-files-introduction) offers fully managed file shares in the cloud that are accessible via the industry-standard Server Message Block (SMB) protocol. Azure file shares can be mounted concurrently by cloud or on-premises deployments of Windows, Linux, and macOS.

-   [Azure ExpressRoute](/azure/expressroute/expressroute-introduction) lets you extend your on-premises networks into the Microsoft cloud over a private connection facilitated by a connectivity provider. With ExpressRoute you can establish connections to Microsoft cloud services, such as Microsoft Azure and Office 365.

-   [Azure Load Balancer](/azure/load-balancer/load-balancer-overview) operates at layer four of the Open Systems Interconnection (OSI) model. It's the single point of contact for clients. Load Balancer distributes inbound flows that arrive at the load balancer's front end to back-end pool instances. These flows are according to configured load balancing rules and health probes. The back-end pool instances can be Azure Virtual Machines or instances in a virtual machine scale set.

-   [Azure SQL Database](/azure/azure-sql/database/sql-database-paas-overview) is a fully managed platform as a service (PaaS) database engine that always runs the latest stable version of SQL Server and patched OS, with
    99.99-percent availability. SQL Database handles upgrading, patching, backups, monitoring, and most other database management functions without user involvement. These PaaS capabilities let you focus on business-critical, domain-specific database administration and optimization.

-   [Azure Cosmos DB](https://azure.microsoft.com/services/cosmos-db/) is an Azure PaaS service for NoSQL databases.

-   [Azure Database for PostgreSQL](https://azure.microsoft.com/services/postgresql/) is an Azure PaaS service for PostgreSQL databases.

## Scenario details

This architecture illustrates how the Raincode solution runs on Azure. Raincode on Azure supports the following features:

-   100-percent thread-safe and managed code for .NET and .NET Core.

-   A solution primarily aimed at transforming mainframes to a cloud-native architecture.

-   Native support for static or dynamic SQL queries through SQL Server either on-premises or on Azure SQL DB.

-   Support for Db2 (through Microsoft's HIS) and SQL Server.

-   Visual Studio integration, featuring a debugger, compiler, configurations,# IntelliSense, code colorizer, and project management.

-   Support for all COBOL data types, with mainframe memory representation.

-   Seamless integration with PL/I and ASM370 compilers.

-   A repository with call graphs, statistics, and other compile-time information.

-   Native EBCDIC support at compile time and runtime.

Migrating to a modern, distributed cloud infrastructure using Raincode allows you to:

-   Facilitate new development and maintenance in C\#.

-   Free yourself from the financial burden of COBOL licensing costs.

-   Adopt a flexible and scalable platform by using the latest technologies through .NET Core.

-   Integrate with modern applications such as web and mobile to improve customer experience.

-   Transform your monolithic legacy applications into micro- or service-oriented architecture (SOA).

-   Control your total cost of ownership (TCO) by using Azure's scalability and availability features.

### Potential use cases

Many use cases can benefit from the Raincode compiler; possibilities include:

-   Businesses seeking to modernize infrastructure and escape the high costs, limitations, and rigidity associated with mainframes.

-   Reducing Technical Debt by going cloud native and DevOps.

-   Reducing operational and capital expenditure costs.

-   Organizations opting to move IBM zSeries mainframe workloads to the cloud without the side effects of a complete redevelopment.

-   IBM zSeries mainframe customers who need to migrate mission-critical applications while maintaining continuity with other on-premises applications.

-   Teams looking for the horizontal and vertical scalability that Azure offers.

-   Businesses that favor solutions offering disaster recovery options.

-   Taking advantage of the latest software development innovations: tools, frameworks, languages, and practices.

## Considerations

The following considerations apply to this solution.

### Availability

-   Raincode architecture uses [Azure Site Recovery](https://azure.microsoft.com/services/site-recovery/) to mirror Azure VMs to a secondary Azure region for quick failover and disaster recovery (DR) if an Azure datacenter fails.

### Operations

-   Each service of a cloud-native application goes through an independent life cycle, which is managed through an agile DevOps process.

-   Multiple continuous integration/continuous delivery (CI/CD) pipelines can work in tandem to deploy and manage a cloud-native application.

### Performance efficiency

-   Cloud-native applications are a collection of independent and autonomous services that are packaged as lightweight containers.

-   Unlike virtual machines, containers can rapidly scale out and scale in.

-   Since the unit of scaling shifts to containers, infrastructure usage is optimized.

### Security

-   This solution uses an [Azure network security group (NSG)](/azure/virtual-network/network-security-groups-overview) to manage traffic between Azure resources.

-   [Private Link for Azure SQL Database](/azure/azure-sql/database/private-endpoint-overview) provides a private, direct connection that is isolated to the Azure networking backbone, from the Azure VMs to Azure SQL Database.

### Cost optimization

-   The Raincode COBOL compiler facilitates new development in C\# and eliminates the financial burden of COBOL licensing costs.

-   Native support for SQL and CICS. The source code debugged is the same as the source being maintained, rather than the output of a pre-processor.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.* 

Principal author:

 - [Jonathon Frost](https://www.linkedin.com/in/jjfrost/) | Principal Software Engineer
 
*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

For more information, please contact <legacy2azure@microsoft.com> or check out the following resources:

-   Read the [Raincode technical landscape](https://www.raincode.com/technical-landscape/cobol).

-   [Mainframe and midrange migration](https://azure.microsoft.com/migration/mainframe)

-   [Mainframe rehosting on Azure virtual machines](/azure/virtual-machines/workloads/mainframe-rehosting/overview)

## Related resources

-   [Modernize mainframe & midrange data](/azure/architecture/example-scenario/mainframe/modernize-mainframe-data-to-azure)

-   [Mainframe file replication and sync on Azure](../../solution-ideas/articles/mainframe-azure-file-replication.yml)

-   [Replicate and sync mainframe data in Azure](../migration/sync-mainframe-data-with-azure.yml)

-   [Refactor IBM z/OS mainframe Coupling Facility (CF) to Azure](../zos/refactor-zos-coupling-facility.yml)

-   [IBM z/OS mainframe migration with Avanade AMT](../../example-scenario/mainframe/asysco-zos-migration.yml)

-   [Migrate IBM mainframe applications to Azure with TmaxSoft OpenFrame](../../solution-ideas/articles/migrate-mainframe-apps-with-tmaxsoft-openframe.yml)
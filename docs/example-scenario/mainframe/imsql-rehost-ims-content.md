This architecture shows how to use Raincode's IMSql to rehost IMS Database Manager (IMS DB) and IMS Transaction Manager (IMS TM) systems on .NET and SQL Server in the simplest way: by using virtual machines. You can recompile legacy applications to target .NET and interact with IMSql in the same way that they interact with IMS on a mainframe. IMSql transitions mainframe applications to an Azure-native architecture while thoroughly preserving the business logic.

## Architecture

### IBM z/OS architecture, before migration

:::image type="content" source="media/mainframe-architecture.svg" alt-text="Diagram that shows the mainframe architecture before migration." lightbox="media/mainframe-architecture.svg" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/imsql-rehosting-ims-pre-migration-mainframe.vsdx) of this architecture.*

#### Dataflow

A. Users connect via TCP/IP by using protocols like TN3270 and HTTPS.

B. Input into the mainframe uses standard mainframe communication protocols.  

C. Applications receive the data. These applications are either batch or online systems.  
D. COBOL, PL/I, Assembler, or other compatible languages run in an enabled environment.  

E. Database systems, commonly hierarchical/network and relational systems, store data.  

F. Common services, like program execution, I/O operations, error detection, and protection within the environment, provide support.  

G. Middleware and utilities manage services like tape storage, queueing, output, and web services within the environment.  

H. Operating systems run on partitions.  

I. Partitions run separate workloads and segregate work types within the environment.  

### Azure architecture, after migration  

:::image type="content" source="media/imsql-virtual-machines.svg" alt-text="Diagram that shows the IMSql architecture after migration to virtual machines." lightbox="media/imsql-virtual-machines.svg" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/imsql-rehosting-raincode-app-modernization.vsdx) of this architecture.*

#### Dataflow

1. IBM 3270 terminal emulators connect to IMS TM applications that are deployed on Azure unchanged via the IMSql Terminal Server.
1. Batch processes written in JCL are run unchanged via transient Azure container instances that run the Raincode JCL interpreter. Compiled legacy programs access IMS DB by using standard IMS APIs. Raincode JCL can store its catalog on any file-based storage. 
1. Read/write SQL Server views on the IMS data enable modern applications or business intelligence (like Power BI) to communicate directly with IMS applications, abstracting away mainframe elements like data structures and character encodings.
1. Raincode Console provides a web-based administration environment for IMSql. 
1. SQL Server Service Broker is the communications backbone for IMSql components.

### Components

- [Azure Virtual Network](https://azure.microsoft.com/services/virtual-network) is the fundamental building block for your private network in Azure. Virtual Network enables many types of Azure resources, like virtual machines (VMs), to communicate with each other, the internet, and on-premises networks, all with improved security. Virtual Network is like a traditional network that you operate in your own datacenter, but it provides more of the benefits of the Azure infrastructure, like scale, availability, and isolation.  
- [Azure Virtual Machine Scale Sets](https://azure.microsoft.com/services/virtual-machine-scale-sets) provides automated and load-balanced VM scaling that simplifies the management of your applications and increases availability.
- [Azure SQL Managed Instance](https://azure.microsoft.com/services/azure-sql/sql-managed-instance), part of the Azure SQL service portfolio, is a managed, highly secure, always up-to-date SQL instance in the cloud.

### Alternatives

- You can use SQL Server in an Azure virtual machine as an alternative to SQL Managed Instance. We recommend SQL Managed Instance in this architecture because of benefits like high availability, seamless integration with various Azure services, and management of underlying security patches and maintenance.

- You can use an Azure single-VM architecture as an alternative to Virtual Machine Scale Sets. You might want to use single VMs for workloads that have constant load and performance demands and don't need scaling. This architecture uses Virtual Machine Scale Sets to handle typical IMS workloads.

## Scenario details

This architecture shows how to seamlessly rehost to Azure a mainframe workload that has critical IMS features and capabilities. You don't need to translate or modify your existing application. The architecture uses IMSql and Azure SQL.

- Raincode compilers generate 100 percent thread-safe managed code for .NET. The .NET assemblies are loaded dynamically and called by IMSql processing servers. 
- IMSql is intrinsically non-transformational. It keeps the source (COBOL, PL/I) as is. The IMS-specific CBLTDLI and PLITDLI calls and EXEC DLI statements aren't changed. This capability ensures optimal maintainability of the resulting system. It extends to IMS DB data: the data is imported as is, in bulk, with no changes, cleansing, or normalization. 
- IMSql uses the robust, versatile, and scalable SQL Server as a database, transaction processor, and execution platform.
- IMSql operates in three modes:  
   - Online
   - Batch
   - Load and Unload (for data migration or for JCLs that produce or consume sequential files)
- On mainframes, Database Descriptions (DBDs) and Program Specification Blocks (PSBs) are compiled to create the database and the program's description. Similarly, on IMSql, DBDs and PSBs are compiled into an XML representation. This representation enables IMS-aware programs to determine which database segments pertain to them. It also drives the generation of various server-side artifacts for IMSql, like the database schema and stored procedures.

### Potential use cases  
  
- Modernize infrastructure and eliminate the high costs, limitations, and rigidity associated with IMS, or, more generally, with mainframes.  
- Reduce technical debt by implementing cloud-native solutions and supporting a DevOps strategy.  
- Move IMS workloads to the cloud without the side effects of a complete redevelopment.
- Move IMS business-critical applications while maintaining continuity with other on-premises applications.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Overview of the reliability pillar](/azure/architecture/framework/resiliency/overview).

- This OLTP architecture can be deployed in multiple regions and can incorporate a geo-replication data layer.
- The Azure database services support zone redundancy and can fail over to a secondary node during outages or to enable maintenance activities.

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

This solution uses an Azure network security group to manage traffic to and from Azure resources. For more information, see [Network security groups](/azure/virtual-network/network-security-groups-overview).

These security options are available in Azure database services:

- Data encryption at rest
- Dynamic data masking
- Always Encrypted data

For general guidance on designing highly secure SQL solutions, see [Azure security recommendations](/sql/relational-databases/security/security-center-for-sql-server-database-engine-and-azure-sql-database?view=sql-server-ver16).

### Cost optimization

Cost optimization is about reducing unnecessary expenses and improving operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

- Azure provides cost optimization by running on Windows VMs. You can turn off the VMs when they're not being used and script a schedule for known usage patterns. Azure helps you avoid unnecessary costs by identifying the right number of resource types, analyzing spending over time, and scaling to meet business needs without overspending.  
- SQL Managed Instance provides various pricing tiers, like general purpose and business critical, to optimize costs based on usage and business criticality.
- Use [Azure Reservations](/azure/cost-management-billing/reservations/save-compute-costs-reservations) and [Azure savings plan for compute](https://azure.microsoft.com/pricing/offers/savings-plan-compute/#benefits-and-features) with a one-year or three-year contract and receive significant savings off pay-as-you-go prices.

Use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate the cost of implementing this solution.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Bhaskar Bandam](https://www.linkedin.com/in/bhaskar-bandam-75202a9) | Senior Program Manager

Other contributor:

- [Mick Alberts](https://www.linkedin.com/in/mick-alberts-a24a1414) | Technical Writer

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps 

- [IMSql user guide](https://www.raincode.com/docs/IMSql/UserGuide.html#_imsql_user_guide)
- [What is Azure Virtual Network?](/azure/virtual-network/virtual-networks-overview)

For more information, contact [legacy2azure@microsoft.com](mailto:legacy2azure@microsoft.com).

## Related resources

See the companion architecture: 
- [Rehost IMS DC and IMS DB on Azure by using IMSql](rehost-ims-raincode-imsql.yml)

More related resources:

- [General mainframe refactor to Azure](general-mainframe-refactor.yml)
- [Mainframe access to Azure databases](../../solution-ideas/articles/mainframe-access-azure-databases.yml)
- [Re-engineer mainframe batch applications on Azure](reengineer-mainframe-batch-apps-azure.yml)
- [Rehost a general mainframe on Azure](mainframe-rehost-architecture-azure.yml)
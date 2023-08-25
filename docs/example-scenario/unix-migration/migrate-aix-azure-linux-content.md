This solution describes a migration from an IBM AIX Unix platform to Red Hat Enterprise Linux (RHEL) in Azure. The real-world example was a Health and Human Services application for a large customer. Low transaction time and latency were important requirements for both the legacy and the Azure systems. A key functionality is storing customer information in a database that links into a network file store containing related graphical images. Azure addresses this need with Azure NetApp Files.

## Architecture

The following diagram shows the pre-migration, on-premises AIX legacy system architecture:

:::image type="content" source="media/aix-on-premises-system.svg" alt-text="Diagram that shows the pre-migration AIX system architecture." border="false" lightbox="media/aix-on-premises-system.svg":::

*Download a [Visio file](https://arch-center.azureedge.net/UNIX-AIX-Azure-RHEL-migration.vsdx) of this architecture.*

- Network appliances provide an extensive network routing and load-balancing layer (**A**).

- The presentation tier (**B**) uses three Java web front-end machines in their own subnet, which segments network traffic by firewalls.

- Firewalls (**C**) provide network boundaries between all participating tiers and subsystems. While firewalls are effective, they're also an administrative burden.

- The system provides user requests to the application tier (**D**), which has three web application servers.

- The application tier calls into the DB2 database and the network attached storage (NAS):

  - The database (**E**) is DB2 on AIX. Three DB2 servers are configured in a HA/DR cluster.

  - The application stores binary objects like pictures and PDFs for customers and users in a NAS subsystem (**F**).

- Management and administration servers and the MQ servers (**G**) are in their own subnet, segmented by firewalls.

- Lightweight Directory Access Protocol (LDAP) identity management services (**H**) are in their own subnet, segmented by firewalls.

The following diagram shows the Azure RHEL post-migration system architecture:

:::image type="content" source="media/rhel-azure-system.svg" alt-text="Diagram that shows the post-migration Azure architecture." border="false" lightbox="media/rhel-azure-system.svg":::

*Download a [Visio file](https://arch-center.azureedge.net/UNIX-AIX-Azure-RHEL-migration.vsdx) of this architecture.*

### Dataflow

1. Traffic into the Azure system routes through Azure ExpressRoute and Azure Traffic Manager:

   - ExpressRoute provides a secure, reliable private connection to Azure virtual networks. ExpressRoute connects to Azure with low latency, high reliability and speed, and bandwidths up to 100 Gbps.
   - Traffic Manager distributes the public-facing application traffic across Azure regions.

1. A network management layer provides endpoint security, routing, and load-balancing services. This layer uses Azure Load Balancer and Azure Web Application Firewall.

1. Azure App Service serves as the presentation tier. App Service is a platform-as-a-service (PaaS) layer for .NET or Java applications. You can configure App Service for availability and scalability within and across Azure regions.

1. The solution encapsulates each application tier in its own virtual network, segmented with network security groups.

1. [Availability sets](/azure/virtual-machines/availability-set-overview) and shared Azure Storage provide HA and scalability for virtual machines (VMs) at the application tier level. Application cluster servers share transaction state, and scale up VMs as necessary.

1. The application uses a [private endpoint](/azure/private-link/tutorial-private-endpoint-sql-portal) connection to store and access data in Azure SQL Database. SQL Database runs in a business continuity configuration, which provides geo-replication and autofailover groups for automatic and cross-geographic BCDR.

1. Azure NetApp Files provides a shared NAS, with fast access to binary data and replication to the secondary region.

1. The secondary region provides BCDR with the following components:

   - Azure Site Recovery backs up VM images for DR failover in an active-passive configuration. Site Recovery creates consistent VM image replicas in the secondary region and keeps the VM images in sync.
   - SQL Database business continuity configuration keeps the database transactions consistent. SQL Database provisions replica databases and keeps them in sync with synchronous or asynchronous data replication.

The system also contains the following components:

- One or more VMs in the Management virtual network provide management and administration functionality.

- Azure Service Bus implements the MQ Series infrastructure and provides message queue services for the applications. For more information on migrating from MQ Series to Azure Service Bus, see [Migrate from ActiveMQ to Azure Service Bus](/azure/service-bus-messaging/migrate-jms-activemq-to-servicebus).

- Azure Active Directory (Azure AD) provides identity and access management for all Azure entities and identities migrated from the legacy LDAP services.

### Components

- [Azure ExpressRoute](https://azure.microsoft.com/services/expressroute) extends an on-premises network into Microsoft cloud services over a private connection, facilitated by a connectivity provider. ExpressRoute provides a secure, reliable private connection to the Azure system, with low latency and high speed and bandwidth.

- [Azure Traffic Manager](https://azure.microsoft.com/services/traffic-manager) is a DNS-based traffic load balancer that distributes traffic across Azure regions, with high availability and quick responsiveness.

- [Azure Load Balancer](https://azure.microsoft.com/services/load-balancer) supports high availability by distributing incoming network traffic among backend VMs according to configured load-balancing rules and health probes. Load Balancer operates at layer 4 of the Open Systems Interconnection (OSI) model.

- [Azure Web Application Firewall](https://azure.microsoft.com/services/web-application-firewall) is a cloud-native WAF service that protects web apps against malicious attacks and common web vulnerabilities.

- [Azure App Service](https://azure.microsoft.com/services/app-service) is a fully managed web hosting service for quickly and easily deploying enterprise web apps for any platform on a scalable and reliable cloud infrastructure.

- [Azure Virtual Machines](https://azure.microsoft.com/services/virtual-machines) is one of several Azure services that provide on-demand, scalable computing resources. With Azure VMs, you get the flexibility of virtualization without having to buy and maintain physical hardware.

  - [Azure SSD managed disks](/azure/virtual-machines/windows/managed-disks-overview) are block-level storage volumes for Azure VMs.
  - [Azure virtual network interface cards (NICs)](/azure/virtual-network/virtual-network-network-interface) let Azure VMs communicate with internet, Azure, and on-premises resources. You can add several virtual NICs to an Azure VM, so child VMs can have their own dedicated network interface devices and IP addresses.

- [Azure Virtual Network](https://azure.microsoft.com/services/virtual-network) is the fundamental building block for Azure private networks. Virtual Network lets many types of Azure resources, such as VMs, securely communicate with each other, the internet, and on-premises networks. Virtual Network offers Azure infrastructure benefits like scalability, availability, and isolation.

- [Azure Files](https://azure.microsoft.com/services/storage/files) storage offers fully managed file shares in the cloud that are accessible via the industry-standard Server Message Block (SMB) protocol. Cloud and on-premises Windows, Linux, and macOS deployments can mount Azure file shares concurrently.

- [Azure SQL Database](https://azure.microsoft.com/products/azure-sql/database) is a fully managed database PaaS that always runs on the latest OS and stable SQL Server database engine version, with highest availability. SQL Database handles database management functions, such as upgrades, patching, backups, and monitoring, without user involvement.

- [Azure NetApp Files](https://azure.microsoft.com/services/netapp) offers enterprise-grade Azure file shares powered by NetApp. Azure NetApp Files makes it easy for enterprises to migrate and run complex, file-based applications with no code changes.

- [Azure Site Recovery](https://azure.microsoft.com/services/site-recovery) is an Azure-native DR service. Site Recovery deploys replication, failover, and recovery processes to help keep applications running during planned and unplanned outages.

- [Azure Service Bus](https://azure.microsoft.com/services/service-bus) is a reliable cloud messaging service with simple hybrid integration.

- [Azure AD](https://azure.microsoft.com/services/active-directory) is Microsoft's cloud-based enterprise identity and access management service. Azure AD single sign-on and multifactor authentication help users sign in and access resources, while protecting from cybersecurity attacks.

### Alternatives

[Azure App Service environments](/azure/app-service/environment/intro) are appropriate for application workloads that require high scale, isolation, and secure network access. This feature offers fully isolated and dedicated environments for securely running App Service apps at high scale. App Service environments can host the following types of apps:

- Linux web apps, as in the current example
- Windows web apps
- Docker containers
- Mobile apps
- Functions

## Scenario details

One distinct difference between the legacy system and the cloud implementation is in handling network segmentation. The legacy system segmented networks with firewalls. A cloud platform like Azure segments networks with virtual networks and network security groups that filter traffic based on several criteria.

Another difference between the systems is their high availability (HA) and disaster recovery (DR) models. In the legacy system, HA/DR primarily used backups, and to some extent used redundant servers in the same datacenter. This configuration provided modest DR, but almost no HA capabilities. Improving HA/DR was a key driver for moving to the Azure platform. Azure uses clustering, shared storage, and Azure Site Recovery to provide a high level of HA/DR.

### Potential use cases

Key drivers for moving from on-premises IBM AIX to RHEL in Azure might include the following factors:

- **Updated hardware and reduced costs.** On-premises, legacy hardware components continually go out of date and out of support. Cloud components are always up to date. Month-to-month costs can be less in the cloud.

- **Agile DevOps environment.** Deploying compliance changes in an on-premises AIX environment can take weeks. You might have to set up similar performance engineering environments many times to test changes. In an Azure cloud environment, you can set up user acceptance testing (UAT) and development environments in hours. You can implement changes through a modern, well-defined DevOps continuous integration and continuous delivery (CI/CD) pipeline.

- **Improved Business Continuity and Disaster Recovery (BCDR).** In on-premises environments, recovery time objectives (RTOs) can be long. In the example on-premises AIX environment, the RTO via traditional backups and restores was two days. Migrating to Azure reduced the RTO to two hours.

## Considerations

The following considerations, based on the [Microsoft Azure Well-Architected Framework](/azure/architecture/framework), apply to this solution:

### Availability

- Azure NetApp Files can keep the file store in the secondary region updated with [Cross-region replication of Azure NetApp Files Volumes](/azure/azure-netapp-files/cross-region-replication-introduction). This Azure feature provides data protection through cross-region volume replication. You can fail over critical applications if there is a region-wide outage. Cross-region volume replication is currently in preview.

- Application cluster servers scale up VMs as necessary, which increases availability within Azure regions.

### Operations

For proactive monitoring and management, consider using [Azure Monitor](https://azure.microsoft.com/services/monitor) for monitoring migrated AIX workloads.

### Performance efficiency

- The potential bottlenecks in this architecture are the storage and compute subsystems. Make sure to choose your storage and VM SKUs accordingly.

- The available VM disk types are ultra disks, premium solid-state drives (SSDs), standard SSDs, and standard hard disk drives (HDDs). For this solution, it's best to use either premium SSDs or ultra disks.

- To estimate sizing for VMs coming from an AIX system, keep in mind that the AIX CPUs are about 1.4 times faster than most x86 vCPUs. This guideline can vary by workload.

- Place multiple VMs that need to communicate with each other in a [proximity placement group](/azure/virtual-machines/workloads/sap/sap-proximity-placement-scenarios). Locating the VMs close to each other provides the lowest communication latency.

### Scalability

- [Azure ExpressRoute](https://azure.microsoft.com/services/expressroute) supports high scale for implementations that use significant bandwidth, either for initial replication or ongoing changed data replication.

- Infrastructure management, including scalability, is automated in Azure databases.

- You can scale out the application tier by adding more application server VM instances.

### Security

- This solution uses Azure network security groups to manage traffic between Azure resources. For more information, see [Network security groups](/azure/virtual-network/network-security-groups-overview).

- Follow [Azure best practices for network security](/azure/security/fundamentals/network-best-practices) as closely as possible.

- For VM or infrastructure-as-a-service (IaaS) security, follow the [Security best practices for IaaS workloads in Azure](/azure/security/fundamentals/iaas).

### Cost optimization

- Migrating AIX workloads to Linux in Azure can bring substantial cost savings. You eliminate hardware maintenance, reduce facility costs, and can usually reduce operational costs by a factor of eight to 10. Azure can accommodate added capacity for seasonal or periodic workloads as needed, which reduces overall cost.

- Migrating AIX workloads to Azure can also reduce costs by using cloud-native services. Examples include:

  - Using Azure App Service for the presentation tier instead of setting up multiple VMs.
  - Segmenting workloads with Azure virtual networks instead of using hardware-based firewalls.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

 * [Jonathon Frost](https://www.linkedin.com/in/jjfrost) | Principal Program Manager

## Next steps

- [Migrating AIX Workloads to Azure: Approaches and Best Practices](https://techcommunity.microsoft.com/t5/azure-global/migrating-aix-workloads-to-azure-approaches-and-best-practices/ba-p/1085983).
- [AIX to Red Hat Enterprise Linux Strategic Migration Planning Guide](https://docslib.org/doc/9964312/aix-to-red-hat-enterprise-linux-strategic-migration-planning-guide).
- For more information, contact [legacy2azure@microsoft.com](mailto:legacy2azure@microsoft.com).

## Related resources

- [High availability and disaster recovery scenarios for IaaS apps](../infrastructure/iaas-high-availability-disaster-recovery.yml)
- [Multi-tier web application built for HA/DR](../infrastructure/multi-tier-app-disaster-recovery.yml)
- [Multi-region N-tier application](../../reference-architectures/n-tier/multi-region-sql-server.yml)
- [Run a Linux VM on Azure](../../reference-architectures/n-tier/linux-vm.yml)

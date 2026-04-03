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

  - The database (**E**) is DB2 on AIX. Three DB2 servers are configured in a high availability/disaster recovery (HA/DR) cluster.

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

1. The application uses a [private endpoint](/azure/private-link/tutorial-private-endpoint-sql-portal) connection to store and access data in Azure SQL Database. SQL Database runs in a business continuity configuration, which provides geo-replication and auto-failover groups for automatic and cross-geographic BCDR.

1. Azure NetApp Files provides a shared NAS, with fast access to binary data and replication to the secondary region.

1. The secondary region provides BCDR with the following components:

   - Azure Site Recovery backs up VM images for DR failover in an active-passive configuration. Site Recovery creates consistent VM image replicas in the secondary region and keeps the VM images in sync.
   - SQL Database business continuity configuration keeps the database transactions consistent. SQL Database provisions replica databases and keeps them in sync with synchronous or asynchronous data replication.

The system also contains the following components:

- One or more VMs in the Management virtual network provide management and administration functionality.

- Azure Service Bus implements the MQ Series infrastructure and provides message queue services for the applications. For more information on migrating from MQ Series to Azure Service Bus, see [Migrate from ActiveMQ to Azure Service Bus](/azure/service-bus-messaging/migrate-jms-activemq-to-servicebus).

- Microsoft Entra ID provides identity and access management for all Azure entities and identities migrated from the legacy LDAP services.

### Components

- [Azure ExpressRoute](/azure/well-architected/service-guides/azure-expressroute) is a service that extends an on-premises network into Microsoft cloud services over a private connection that a connectivity provider facilitates. In this architecture, ExpressRoute provides a secure, reliable private connection to the Azure system, with low latency and high speed and bandwidth.

- [Azure Traffic Manager](/azure/well-architected/service-guides/traffic-manager/reliability) is a domain name system (DNS)-based traffic load balancer that distributes traffic across Azure regions. In this architecture, Traffic Manager distributes public-facing application traffic across Azure regions with high availability and quick responsiveness.

- [Azure Load Balancer](/azure/well-architected/service-guides/azure-load-balancer/reliability) supports high availability by distributing incoming network traffic among back-end VMs according to configured load-balancing rules and health probes. Load Balancer operates at layer 4 of the Open Systems Interconnection (OSI) model. In this architecture, Load Balancer works with Azure Web Application Firewall to provide the network management layer that replaces the legacy network appliances.

- [Azure Web Application Firewall](/azure/web-application-firewall/ag/ag-overview) is a cloud-native service that protects web applications from malicious attacks and vulnerabilities. In this architecture, it provides endpoint security and protection and replaces the multiple firewalls that segment network traffic in the legacy AIX system.

- [Azure App Service](/azure/well-architected/service-guides/app-service-web-apps) is a fully managed web hosting service for deploying enterprise web apps for any platform on a scalable and reliable cloud infrastructure. In this architecture, App Service acts as the presentation tier. It replaces the Java web front-end machines and provides PAAS capabilities for .NET or Java applications.

- [Azure Virtual Machines](/azure/well-architected/service-guides/virtual-machines) is a service that provides on-demand, scalable computing resources. Virtual Machines provides the flexibility of virtualization without having to buy and maintain physical hardware. In this architecture, the service hosts the application tier servers in availability sets that have shared storage.

  - [Azure solid-state drive (SSD) managed disks](/azure/virtual-machines/windows/managed-disks-overview) are block-level storage volumes for Azure VMs.
  - [Azure virtual network interface cards (NICs)](/azure/virtual-network/virtual-network-network-interface) let Azure VMs communicate with the internet, Azure, and on-premises resources. You can add several virtual NICs to an Azure VM, so child VMs can have their own dedicated network interface devices and IP addresses.

- [Azure Virtual Network](/azure/well-architected/service-guides/virtual-network) is the foundation for Azure private networks. Virtual Network provides Azure infrastructure benefits like scalability, availability, and isolation. In this architecture, Virtual Network enables Azure resources, such as VMs, to securely communicate with each other, the internet, and on-premises networks.

- [Azure Files](/azure/well-architected/service-guides/azure-files) provides fully managed file shares in the cloud that can be accessed via the industry-standard Server Message Block (SMB) protocol. Cloud and on-premises Windows, Linux, and macOS deployments can mount Azure file shares concurrently. In this architecture, Azure Files provides shared file storage capabilities as part of the overall storage strategy for the migrated application.

- [Azure SQL Database](/azure/well-architected/service-guides/azure-sql-database-well-architected-framework) is a fully managed database PaaS that always runs on the latest OS and most stable SQL Server database engine version to provide the highest availability. In this architecture, SQL Database handles database management functions, such as upgrades, patching, backups, and monitoring, without user involvement.

- [Azure NetApp Files](/azure/well-architected/service-guides/azure-netapp-files) provides enterprise-grade Azure file shares powered by NetApp. This architecture uses Azure NetApp Files to help enterprises easily migrate and run complex, file-based applications with no code changes.

- [Azure Site Recovery](/azure/site-recovery/site-recovery-overview) is an Azure-native DR service. In this architecture, Site Recovery deploys replication, failover, and recovery processes to help keep applications running during planned and unplanned outages.

- [Azure Service Bus](/azure/well-architected/service-guides/service-bus/reliability) is a reliable cloud messaging service with simple hybrid integration. In this architecture, Service Bus provides message queue services for the applications.

- [Microsoft Entra ID](/entra/fundamentals/whatis) is a cloud-based enterprise identity and access management service from Microsoft. In this architecture, Microsoft Entra single sign-on and multifactor authentication help users sign in and access resources, while providing protection from cybersecurity attacks.

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

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/well-architected).

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

- Azure NetApp Files can keep the file store in the secondary region updated with [Cross-region replication of Azure NetApp Files Volumes](/azure/azure-netapp-files/cross-region-replication-introduction). This Azure feature provides data protection through cross-region volume replication. You can fail over critical applications if there is a region-wide outage. Cross-region volume replication is currently in preview.

- Application cluster servers scale up VMs as necessary, which increases availability within Azure regions.

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

- This solution uses Azure network security groups to manage traffic between Azure resources. For more information, see [Network security groups](/azure/virtual-network/network-security-groups-overview).

- Follow [Azure best practices for network security](/azure/security/fundamentals/network-best-practices) as closely as possible.

- For VM or infrastructure-as-a-service (IaaS) security, follow the [Security best practices for IaaS workloads in Azure](/azure/security/fundamentals/iaas).

### Cost Optimization

Cost Optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

- Migrating AIX workloads to Linux in Azure can bring substantial cost savings. You eliminate hardware maintenance, reduce facility costs, and can usually reduce operational costs by a factor of eight to 10. Azure can accommodate added capacity for seasonal or periodic workloads as needed, which reduces overall cost.

- Migrating AIX workloads to Azure can also reduce costs by using cloud-native services. Examples include:

  - Using Azure App Service for the presentation tier instead of setting up multiple VMs.
  - Segmenting workloads with Azure virtual networks instead of using hardware-based firewalls.

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

For proactive monitoring and management, consider using [Azure Monitor](https://azure.microsoft.com/services/monitor) for monitoring migrated AIX workloads.

### Performance Efficiency

Performance Efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

- [Azure ExpressRoute](https://azure.microsoft.com/services/expressroute) supports high scale for implementations that use significant bandwidth, either for initial replication or ongoing changed data replication.

- Infrastructure management, including scalability, is automated in Azure databases.

- You can scale out the application tier by adding more application server VM instances.

- The potential bottlenecks in this architecture are the storage and compute subsystems. Make sure to choose your storage and VM SKUs accordingly.

- The available VM disk types are Ultra Disks, Premium SSDs, Standard SSDs, and Standard HDDs. For this solution, it's best to use either Premium SSDs or Ultra Disks.

- To estimate sizing for VMs coming from an AIX system, keep in mind that the AIX CPUs are about 1.4 times faster than most x86 vCPUs. This guideline can vary by workload.

- Place multiple VMs that need to communicate with each other in a [proximity placement group](/azure/virtual-machines/workloads/sap/sap-proximity-placement-scenarios). Locating the VMs close to each other provides the lowest communication latency.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

 * [Jonathon Frost](https://www.linkedin.com/in/jjfrost) | Principal Program Manager

## Next steps

- [Migrating AIX Workloads to Azure: Approaches and Best Practices](https://techcommunity.microsoft.com/t5/azure-global/migrating-aix-workloads-to-azure-approaches-and-best-practices/ba-p/1085983).
- [AIX to Red Hat Enterprise Linux Strategic Migration Planning Guide](https://docslib.org/doc/9964312/aix-to-red-hat-enterprise-linux-strategic-migration-planning-guide).
- For more information, contact [legacy2azure@microsoft.com](mailto:legacy2azure@microsoft.com).

## Related resources

- [Multi-tier web application built for HA/DR](../infrastructure/multi-tier-app-disaster-recovery.yml)
- [Run a Linux VM on Azure](../../reference-architectures/n-tier/linux-vm.yml)

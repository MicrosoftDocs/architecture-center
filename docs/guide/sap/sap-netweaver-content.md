<!-- cSpell:ignore lbrader netweaver jump-box jump-boxes ACLs HANA SWDs SMLG ABAP SAPGUI SAPGUIs SPOF WSFC ASCS MSEE Iperf SIOS sapmnt -->

This guide presents a set of proven practices for running SAP NetWeaver in a Windows environment, on Azure, with high availability. The database is AnyDB, the SAP term for any supported database management system (DBMS) besides SAP HANA.

## Architecture

The following diagram shows SAP NetWeaver in a Windows environment.

:::image type="content" source="media/sap-netweaver-win.png" alt-text="Architecture diagram that shows a solution for SAP NetWeaver on Windows. The database is AnyDB on Azure VMs with availability sets." lightbox="media/sap-netweaver-avset-afs-ppg.png" border="false":::

_Download a [Visio file](https://arch-center.azureedge.net/sap-netweaver-win.vsdx) of this architecture._

> [!NOTE]
> To deploy this architecture, you need appropriate licensing of SAP products and other non-Microsoft technologies.

This guide describes a production system. The system is deployed with specific virtual machine (VM) sizes that you can change to accommodate the needs of your organization. The system can be reduced to a single VM. In this guide, the network layout is greatly simplified to demonstrate architectural principles. It's not intended to describe a full enterprise network.

### Workflow

**Virtual networks.** The [Azure Virtual Network](/azure/virtual-network/virtual-networks-overview) service connects Azure resources to each other with enhanced security. In this architecture, the virtual network connects to an on-premises network via an Expressroute gateway that's deployed in the hub of a [hub-spoke topology](../../reference-architectures/hybrid-networking/hub-spoke.yml). The spoke is the virtual network that's used for the SAP applications and the database tiers. The hub virtual network is used for shared services like Bastion and backup.

**Virtual network peering.** This architecture uses a hub-and-spoke networking topology with multiple virtual networks that are [peered together](/azure/virtual-network/virtual-network-peering-overview). This topology provides network segmentation and isolation for services that are deployed on Azure. Peering enables transparent connectivity between peered virtual networks through the Microsoft backbone network. It doesn't incur a performance penalty if deployed within a single region. The virtual network is divided into separate subnets for each tier: application (SAP NetWeaver), the database, and shared services like Bastion and 3rd party Backup solution.

**VMs.** This architecture uses VMs for the application tier and database tier, grouped in the following way:

- **SAP NetWeaver.** The application tier uses Windows VMs to run SAP Central Services and SAP application servers. For high availability, the VMs that run Central Services are configured in a Windows server failover cluster. They're supported by either Azure file shares or Azure shared disks.

- **AnyDB.** The database tier runs AnyDB as the database, which can be Microsoft SQL Server, Oracle, or IBM Db2.

- **Bastion service.** Administrators use an improved-security VM that's called a bastion host, to connect to other VMs. It's typically a part of shared services, and backup services. If Secure Shell Protocol (SSH) and Remote Desktop Protocol (RDP) are the only services that are used for server administration, an [Azure Bastion](/azure/bastion/bastion-overview) host is a great solution. If you use other management tools, like SQL Server Management Studio or SAP Frontend, use a traditional, self-deployed jump box.

**Private DNS service.** [Azure Private DNS](/azure/dns/private-dns-overview) provides a reliable and secure DNS service for your virtual network. Azure Private DNS manages and resolves domain names in the virtual network, without the need to configure a custom DNS solution.

**Load balancers.** To distribute traffic to VMs in the SAP application tier subnet for high availability, we recommend that you use [Azure Standard Load Balancer](/azure/load-balancer/load-balancer-standard-availability-zones). It's important to note that Standard Load Balancer is secure by default, and no VMs that are behind Standard Load Balancer have outbound internet connectivity. To enable outbound internet in the VMs, you must update your [Standard Load Balancer configuration](/azure/virtual-machines/workloads/sap/high-availability-guide-standard-load-balancer-outbound-connections). For SAP web-based application high availability, use the built-in [SAP Web Dispatcher](https://help.sap.com/doc/saphelp_em900/9.0/en-US/48/8fe37933114e6fe10000000a421937/content.htm?no_cache=true), or another commercially available load balancer. Base your selection on:

- Your traffic type, such as HTTP or SAP GUI.
- The network services that you need, such as Secure Sockets Layer (SSL) termination.

For some internet-facing inbound/outbound design examples, see [Inbound and outbound internet connections for SAP on Azure](./sap-internet-inbound-outbound.yml).

Standard Load Balancer supports multiple front-end virtual IPs. This support is ideal for cluster implementations that involve these components:

- Advanced Business Application Programming (ABAP) SAP Central Service (ASCS)
- Enqueue Replication Service (ERS)

The Standard SKU also supports multi-systems identifier (multi-SID) SAP clusters. In other words, [multiple SAP systems on Windows](/azure/virtual-machines/workloads/sap/high-availability-guide) can share a common high availability infrastructure to save cost. Evaluate the cost savings, and avoid placing too many systems in one cluster. Azure supports no more than five SIDs per cluster.

**Application gateway.** Azure Application Gateway is a web traffic load balancer that you can use to manage the traffic to your web applications. Traditional load balancers operate at the transport layer (OSI layer 4 - TCP and UDP). They route traffic based on the source IP address and the port to a destination IP address and port. Application Gateway can make routing decisions based on additional attributes of an HTTP request, such as the URI path or host headers. This type of routing is known as application layer (OSI layer 7) load balancing.

**Network security groups.** To restrict incoming, outgoing, and intra-subnet traffic in a virtual network, create [network security groups](/azure/virtual-network/tutorial-filter-network-traffic-cli).

**Application security groups.** To define fine-grained, workload-based network security policies that are centered on applications, use [application security groups](/azure/virtual-network/security-overview) instead of explicit IP addresses. Application security groups provide a way to group VMs by name and help you secure applications by filtering traffic from trusted segments of your network.

**Gateway.** A gateway connects distinct networks, extending your on-premises network to the Azure virtual network. We recommend that you use [ExpressRoute](../../reference-architectures/hybrid-networking/expressroute.yml) to create private connections that don't go over the public internet, but you can also use a [site-to-site](../../reference-architectures/hybrid-networking/expressroute.yml) connection. To reduce latency or increase throughput, consider [ExpressRoute Global Reach](/azure/expressroute/expressroute-global-reach) and [ExpressRoute FastPath](/azure/expressroute/about-fastpath), as discussed later in this article.

**Azure Storage.** Storage provides data persistence for a VM in the form of a virtual hard disk. We recommend [Azure managed disks](/azure/virtual-machines/windows/managed-disks-overview).

## Recommendations

This architecture describes a small production-level deployment. Deployments differ based on business requirements, so consider these recommendations as a starting point.

### VMs

In application server pools and clusters, adjust the number of VMs based on your requirements. For detailed information about running SAP NetWeaver on VMs, see [Azure Virtual Machines planning and implementation for SAP NetWeaver](/azure/virtual-machines/workloads/sap/planning-guide).

For details about SAP support for Azure VM types and throughput metrics (SAPS), see [SAP note 1928533](https://launchpad.support.sap.com/#/notes/1928533). To access SAP notes, you need an SAP Service Marketplace account.

### SAP Web Dispatcher

The Web Dispatcher component is used for load-balancing SAP traffic among the SAP application servers. To achieve high availability for the Web Dispatcher component, Load Balancer is used to implement either the failover cluster of Web Dispatcher instances or the parallel Web Dispatcher setup. For a detailed description of the solution, see [High Availability of SAP Web Dispatcher](https://help.sap.com/doc/saphelp_nw73ehp1/7.31.19/en-US/CA/6FBD35746DBD2DE10000009B38F889/frameset.htm).

### Application servers pool

The SAP SMLG transaction is commonly used to manage logon groups for ABAP application servers and to load balance logon users. Other transactions, like SM61 for batch server groups and RZ12 for remote function call (RFC) groups, also load balance logon users. These transactions use the load-balancing capability within the message server of SAP Central Services to distribute incoming sessions or workloads among the SAP application servers pool for SAP GUIs and RFC traffic.

### SAP Central Services cluster

This architecture runs Central Services on VMs in the application tier. Central Services is a potential single point of failure (SPOF) when it's deployed to a single VM. To implement a highly available solution, use either a file-share cluster or a shared-disk cluster.

For highly available file shares, there are several options. We recommend that you use [Azure Files](/azure/storage/files/storage-files-introduction) shares as fully managed, cloud-native Server Message Block (SMB) or Network File System (NFS) shares. An alternative to Azure Files is [Azure NetApp Files](/azure/azure-netapp-files/azure-netapp-files-introduction), which provides high-performance NFS and SMB shares.

You can also implement the highly available file shares on the Central Services instances by using a Windows server failover cluster with [Azure Files](/azure/virtual-machines/workloads/sap/high-availability-guide-windows-azure-files-smb). This solution also supports a Windows cluster with shared disks by using an Azure shared disk as the cluster shared volume. If you prefer to use shared disks, we recommend that you use [Azure shared disks](/azure/virtual-machines/disks-shared#linux) to set up a [Windows Server failover cluster for SAP Central Services cluster](/azure/virtual-machines/workloads/sap/sap-high-availability-infrastructure-wsfc-shared-disk).

There are also partner products like [SIOS DataKeeper Cluster Edition](https://azuremarketplace.microsoft.com/marketplace/apps/sios_datakeeper.sios-datakeeper-8) from SIOS Technology Corp. This add-on replicates content from independent disks that are attached to the ASCS cluster nodes and then presents the disks as a cluster shared volume to the cluster software.

In case of cluster network partitioning, the cluster software uses quorum votes to select a segment of the network and its associated services to serve as the brain of the fragmented cluster. Windows offers many quorum models. This solution uses [Cloud Witness](/windows-server/failover-clustering/deploy-cloud-witness) because it's simpler and provides more availability than a compute node witness. The [Azure file share witness](/windows-server/failover-clustering/file-share-witness) is another alternative for providing a cluster quorum vote.

On an Azure deployment, the application servers connect to the highly available Central Services by using the virtual host names of the ASCS or ERS services. These host names are assigned to the cluster front-end IP configuration of the load balancer. Load Balancer supports multiple front-end IPs, so both the ASCS and ERS virtual IPs (VIPs) can be bound to one load balancer.

### Networking

This architecture uses a hub-spoke topology. The hub virtual network acts as a central point of connectivity to an on-premises network. The spokes are virtual networks that peer with the hub and isolate the SAP workloads. Traffic flows between the on-premises datacenter and the hub through a gateway connection.

#### Network interface cards (NICs)

NICs enable all communication among VMs on a virtual network. Traditional on-premises SAP deployments implement multiple NICs per machine to segregate administrative traffic from business traffic.

On Azure, the virtual network is a software-defined network that sends all traffic through the same network fabric. So it's not necessary to use multiple NICs for performance reasons. But if your organization needs to segregate traffic, you can deploy multiple NICs per VM and connect each NIC to a different subnet. You can then use network security groups to enforce different access control policies.

Azure NICs support multiple IPs. This support conforms with the practice that SAP recommends of using virtual host names for installations. For a complete outline, see [SAP note 962955](https://launchpad.support.sap.com/#/notes/962955). To access SAP notes, you need an SAP Service Marketplace account.

#### Subnets and network security groups

This architecture subdivides the virtual network address space into subnets. You can associate each subnet with a network security group that defines the access policies for the subnet. Place application servers on a separate subnet. By doing so, you can secure them more easily by managing the subnet security policies rather than the individual servers.

When you associate a network security group with a subnet, the network security group applies to all the servers within the subnet and offers fine-grained control over the servers. Set up network security groups by using the [Azure portal](/azure/virtual-network/tutorial-filter-network-traffic), [PowerShell](/azure/virtual-network/tutorial-filter-network-traffic-powershell), or the [Azure CLI](/azure/virtual-network/tutorial-filter-network-traffic-cli).

#### ExpressRoute Global Reach

If your network environment includes two or more ExpressRoute connections, [ExpressRoute Global Reach](/azure/expressroute/expressroute-global-reach) can help you reduce network hops and latency. This technology is a Border Gateway Protocol (BGP) route peering that's set up between two or more ExpressRoute connections to bridge two ExpressRoute routing domains. Global Reach reduces latency when network traffic traverses more than one ExpressRoute connection. It's currently available only for private peering on ExpressRoute circuits.

At this time, there are no network access control lists or other attributes that can be changed in Global Reach. So all routes learned by a given ExpressRoute circuit (from on-premises and Azure) are advertised across the circuit peering to the other ExpressRoute circuit. We recommend that you establish network traffic filtering on-premises to restrict access to resources.

#### ExpressRoute FastPath

[FastPath](/azure/expressroute/about-fastpath), FastPath is designed to improve the data path performance between your on-premises network and your virtual network. When enabled, FastPath sends network traffic directly to virtual machines in the virtual network, bypassing the gateway.

For all new ExpressRoute connections to Azure, FastPath is the default configuration. For existing ExpressRoute circuits, contact Azure support to activate FastPath.

FastPath doesn't support virtual network peering. If other virtual networks are peered with one that's connected to ExpressRoute, the network traffic from your on-premises network to the other spoke virtual networks is sent to the virtual network gateway. The workaround is to connect all virtual networks to the ExpressRoute circuit directly.  This feature is currently in public preview.

### Load balancers

[SAP Web Dispatcher](https://help.sap.com/doc/saphelp_nw73ehp1/7.31.19/en-US/CA/6FBD35746DBD2DE10000009B38F889/frameset.htm) handles load balancing of HTTP(S) traffic to a pool of SAP application servers. This software load balancer provides application layer services (referred to as layer 7 in the ISO networking model) that can perform SSL termination and other offloading functions.

[Azure Load Balancer](https://azure.microsoft.com/blog/azure-load-balancer-new-distribution-mode) is a network transmission layer service (layer 4) that balances traffic by using a five-tuple hash from the data streams. The hash is based on source IP, source port, destination IP, destination port, and protocol type. In SAP deployments on Azure, Load Balancer is used in cluster setups to direct traffic to the primary service instance or to the healthy node if there's a fault.

We recommend that you use [Standard Load Balancer](/azure/load-balancer/load-balancer-standard-overview) for all SAP scenarios. If VMs in the back-end pool require public outbound connectivity, or if they're used in an Azure zone deployment, Standard Load Balancer requires [additional configurations](/azure/virtual-machines/workloads/sap/high-availability-guide-standard-load-balancer-outbound-connections) because they're secure by default. They don't allow outbound connectivity unless you explicitly configure it.

For traffic from SAP GUI clients that connect to an SAP server via DIAG protocol or RFC, the Central Services message server balances the load through SAP application server [logon groups](https://wiki.scn.sap.com/wiki/display/SI/ABAP+Logon+Group+based+Load+Balancing). For this type of setup, you don't need another load balancer.

### Storage

Some organizations use standard storage for their application servers. Standard managed disks aren't supported. See [SAP note 1928533](http://service.sap.com/sap/support/notes/1928533). To access SAP notes, you need an SAP Service Marketplace account. We recommend that you use premium [Azure managed disks](/azure/storage/storage-managed-disks-overview) in all cases. A recent update to [SAP note 2015553](https://launchpad.support.sap.com/#/notes/2015553) excludes the use of Standard HDD storage and Standard SSD storage for a few specific use cases.

Application servers don't host business data. So you can also use the smaller P4 and P6 premium disks to help minimize costs. By doing so, you can benefit from the [single-instance VM SLA](https://azure.microsoft.com/support/legal/sla/virtual-machines/v1_6) if you have a central SAP stack installation.

For high-availability scenarios, you can use [Azure file shares](/azure/storage/files/storage-files-introduction) and [Azure shared disks](/azure/virtual-machines/disks-shared). [Azure Premium SSD managed disks and Azure Ultra Disk Storage](/azure/storage/storage-managed-disks-overview) are available for Azure shared disks, and Premium SSD is available for Azure file shares.

Storage is also used by [Cloud Witness](/windows-server/failover-clustering/deploy-cloud-witness) to maintain quorum with a device in a remote Azure region, away from the primary region where the cluster resides.

For the backup data store, we recommend Azure [cool and archive access tiers](/azure/storage/blobs/access-tiers-overview). These storage tiers provide a cost-effective way to store long-lived data that's infrequently accessed.

[Azure Premium SSD v2 Disk Storage](https://azure.microsoft.com/en-us/updates/general-availability-azure-premium-ssd-v2-disk-storage/) Azure Premium SSD v2 Disk Storage is the most advanced general purpose block storage solution available, designed for performance-critical workloads like online transaction processing systems that consistently need sub-millisecond latency combined with high IOPS and throughput.

[Ultra Disk Storage](/azure/virtual-machines/linux/disks-enable-ultra-ssd) greatly reduces disk latency. As a result, it benefits performance-critical applications like the SAP database servers. To compare block storage options in Azure, see [Azure managed disk types](/azure/virtual-machines/windows/disks-types).

For a high-availability, high-performance shared data store, use [Azure NetApp Files](/azure/azure-netapp-files/azure-netapp-files-introduction). This technology is particularly useful for the database tier when you use [Oracle](/azure/azure-netapp-files/performance-oracle-single-volumes), and also when you [host application data](/azure/virtual-machines/workloads/sap/high-availability-guide-windows-netapp-files-smb).

## Performance considerations

SAP application servers communicate constantly with the database servers. For performance-critical applications that run on database platforms, enable [Write Accelerator](/azure/virtual-machines/windows/how-to-enable-write-accelerator) for the log volume if you're using Premium SSD (v1). Doing so can improve log-write latency. Write Accelerator is available for M-series VMs. To optimize inter-server communications, use [accelerated networking](https://azure.microsoft.com/blog/linux-and-windows-networking-performance-enhancements-accelerated-networking).

To optimize inter-server communications, use [Accelerated Networking](/azure/virtual-network/accelerated-networking-overview?tabs=redhat). This option is available to most general-purpose and compute-optimized VM instance sizes with two or more vCPUs support Accelerated Networking. On instances that support hyperthreading, VM instances with four or more vCPUs support Accelerated Networking.

To achieve high IOPS and disk throughput, follow the common practices in storage volume [performance optimization](/azure/virtual-machines/linux/premium-storage-performance), which apply to Azure storage layout. For example, you can position multiple disks together to create a striped disk volume to improve I/O performance. Enabling the read cache on storage content that changes infrequently enhances the speed of data retrieval.

[Premium SSD v2](/azure/virtual-machines/disks-types) is a new generation of Azure storage that offers higher performance than Premium SSDs while generally being less costly. You can set a Premium SSD v2 to any supported size you prefer, and make granular adjustments to the performance without downtime.

[Ultra Disk Storage](/azure/virtual-machines/linux/disks-enable-ultra-ssd) is available for I/O-intensive applications. Where these disks are available, we recommend them over [Write Accelerator](/azure/virtual-machines/windows/how-to-enable-write-accelerator) premium storage. You can individually increase or decrease performance metrics like IOPS and MB/s without needing to reboot.

For guidance about optimizing Azure storage for SAP workloads on SQL Server, see [Azure Virtual Machines planning and implementation for SAP NetWeaver](/azure/virtual-machines/workloads/sap/planning-guide).

The placement of a network virtual appliance (NVA) between the application and the database layers for any SAP application stack is not supported. This practice introduces significant processing time for data packets, which leads to unacceptable application performance.

### Proximity placement groups

Some SAP applications require frequent communication with the database. The physical proximity of the application and the database layers affects network latency, which can adversely affect application performance.

To optimize network latency, you can use [proximity placement groups](/azure/virtual-machines/workloads/sap/sap-proximity-placement-scenarios), which set a logical constraint on the VMs that are deployed in availability sets. Proximity placement groups favor co-location and performance over scalability, availability, or cost. They can greatly improve the user experience for most SAP applications. For scripts that are available on GitHub from the SAP deployment team, see [Scripts](https://github.com/Azure/SAP-on-Azure-Scripts-and-Utilities).

### Availability zones

[Availability zones](/azure/availability-zones/az-overview) provide a way for you to deploy VMs across datacenters, which are physically separated locations within a specific Azure region. Their purpose is to enhance service availability. But deploying resources across zones can increase latency, so keep performance considerations in mind.

Administrators need a clear network latency profile between all zones of a target region before they can determine the resource placement with minimum inter-zone latency. To create this profile, deploy small VMs in each zone for testing. Recommended tools for these tests include [PsPing](/sysinternals/downloads/psping) and [Iperf](https://sourceforge.net/projects/iperf). When the tests are done, remove the VMs that you used for testing. As an alternative, consider using an [Azure inter-zone latency check tool](https://github.com/Azure/SAP-on-Azure-Scripts-and-Utilities/blob/main/AvZone-Latency-Test/AvZone-Latency-Test.ps1).

## Scalability considerations

For the SAP application layer, Azure offers a wide range of VM sizes for scaling up and scaling out. For an inclusive list, see [SAP note 1928533 - SAP Applications on Azure: Supported Products and Azure VM Types](https://launchpad.support.sap.com/#/notes/1928533). To access SAP notes, you need an SAP Service Marketplace account.

You can scale SAP application servers and the Central Services clusters up and down. You can also scale them out or in by changing the number of instances that you use. The AnyDB database can scale up and down but doesn't scale out. The SAP database container for AnyDB doesn't support sharding.

## Availability considerations

Resource redundancy is the general theme in highly available infrastructure solutions. For single-instance VM availability SLAs for various storage types, see [SLA for Virtual Machines](https://azure.microsoft.com/support/legal/sla/virtual-machines/v1_9). To increase the service availability on Azure, deploy VM resources with virtual machine scale set with flexible orchestration, availability zones, or availability set.

With Azure, SAP workload deployment can either be regional or zonal depending on the availability and resiliency requirements of the SAP applications. Azure provides [different deployment options](/azure/sap/workloads/sap-high-availability-architecture-scenarios#comparison-of-different-deployment-types-for-sap-workload) like flexible scale set with FD=1, availability zones, or availability sets to enhance the availability of the resources. To have a comprehensive understanding of the available deployment options and their applicability across different Azure regions (including across zones, within a single zone, or in a region without zones), it is important to refer to the [Azure VMs HA architecture and scenarios for SAP NetWeaver](/azure/sap/workloads/sap-high-availability-architecture-scenarios) document.

In this distributed installation of the SAP application, the base installation is replicated to achieve high availability. For each layer of the architecture, the high availability design varies.

### Web Dispatcher in the application servers tier

The Web Dispatcher component is used as a load balancer for SAP traffic among the SAP application servers. To achieve [high availability of SAP Web Dispatcher](https://help.sap.com/doc/saphelp_nw73ehp1/7.31.19/48/9a9a6b48c673e8e10000000a42189b/frameset.htm), Load Balancer implements either the failover cluster or the parallel Web Dispatcher setup.

For internet-facing communications, we recommend a stand-alone solution in the perimeter network, which is also known as _DMZ_, to satisfy security concerns.

[Embedded Web Dispatcher](https://help.sap.com/viewer/00b4e4853ef3494da20ebcaceb181d5e/LATEST/en-US/2e708e2d42134b4baabdfeae953b24c5.html) on ASCS is a special option. If you use this option, consider proper sizing because of the extra workload on ASCS.

### Central Services in the application servers tier

High availability of the Central Services is implemented with a Windows server failover cluster. When the cluster storage for the failover cluster is deployed on Azure, you can configure it in two ways: as a clustered shared disk or as a clustered file share.

- We recommend that you use [Azure Files](/azure/storage/files/storage-files-introduction) as fully managed, cloud-native SMB or NFS shares. Another way is to use [Azure NetApp Files](/azure/azure-netapp-files/azure-netapp-files-introduction), which provides high-performance, enterprise-class NFS and SMB shares.

- There are two ways to set up clusters with shared disks on Azure. First, we recommend that you use [Azure shared disks](/azure/virtual-machines/disks-shared) to set up a [Windows server failover cluster for SAP Central Services](/azure/virtual-machines/workloads/sap/sap-high-availability-infrastructure-wsfc-shared-disk). For an implementation example, see [ASCS cluster using Azure shared disks](/azure/virtual-machines/workloads/sap/sap-high-availability-infrastructure-wsfc-shared-disk). Another way to implement a clustered shared disk is to use SIOS DataKeeper to perform the following tasks:

  - Replicate the content of independent disks that are attached to the cluster nodes.
  - Abstract the drives as a cluster shared volume for the cluster manager.

  For implementation details, see [Clustering SAP ASCS on Azure with SIOS](https://techcommunity.microsoft.com/t5/Running-SAP-Applications-on-the/Clustering-SAP-ASCS-Instance-using-Windows-Server-Failover/ba-p/367898).

By using Standard Load Balancer, you can enable the [high availability port](/azure/load-balancer/load-balancer-ha-ports-overview). Doing so lets you avoid configuring load-balancing rules for many SAP ports. Also, when you set up Azure load balancers, enable the direct server return feature, which is also called _Floating IP_ or _DSR_. Doing so provides a way for server responses to bypass the load balancer. This direct connection keeps the load balancer from becoming a bottleneck in the path of data transmission. For the ASCS and database clusters, we recommend that you enable DSR.

### Application services in the application servers tier

High availability for the SAP application servers is achieved by load balancing traffic within a pool of application servers without the need of cluster software, SAP Wed Dispatcher, or the Azure load balancer.  The SAP message server can load balance client traffic to the application servers defined in an ABAP logon group by the transaction SMLG.  

### Database tier

In this architecture, the source database runs on AnyDB—a DBMS like SQL Server, SAP ASE, IBM Db2, or Oracle. The native replication feature of the database tier provides either manual or automatic failover between replicated nodes.

For implementation details about specific database systems, see [Azure Virtual Machines DBMS deployment for SAP NetWeaver](/azure/virtual-machines/workloads/sap/dbms_guide_general).

### VMs deployed across availability zones

An availability zone is a construct that consists of one or more datacenters, designed to improve workload availability and protect application services and VMs against datacenter outages. VMs in a single zone are treated as if they were in a single fault domain. When you select zonal deployment, VMs in the same zone are distributed to fault domains on a best-effort basis.

In [Azure regions](https://azure.microsoft.com/global-infrastructure/regions) that support multiple zones, at least three zones are available. But the maximum distance between datacenters in these zones isn't guaranteed. To deploy a multitier SAP system across zones, you need to know the network latency within a zone and across targeted zones. You also need to know how sensitive your deployed applications are to network latency.

Take these [considerations](/azure/virtual-machines/workloads/sap/sap-ha-availability-zones) into account when you decide to deploy resources across availability zones:

- Latency between VMs in one zone
- Latency between VMs across chosen zones
- Availability of the same Azure services (VM types) in the chosen zones

> [!NOTE]
> Availability zones support intra-region high availability, but they aren't effective for disaster recovery (DR). The distances between zones are too short. Typical DR sites should be at least 100 miles away from the primary region.

**Active/inactive deployment example**

In this example deployment, the [active/passive](/azure/virtual-machines/workloads/sap/sap-ha-availability-zones#activepassive-deployment) status refers to the application service state within the zones. In the application layer, all four active application servers of the SAP system are in zone 1. Another set of four passive application servers is built in zone 2 but is shut down. They're activated only when they're needed.

The two-node clusters for Central Services and the database services are stretched across two zones. If zone 1 fails, Central Services and the database services run in zone 2. The passive application servers in zone 2 get activated. With all components of this SAP system now co-located in the same zone, network latency is minimized.

**Active/active deployment example**

In an [active/active](/azure/virtual-machines/workloads/sap/sap-ha-availability-zones#activeactive-deployment) deployment, two sets of application servers are built across two zones. Within each zone, two application servers in each set of servers are inactive, because they're shut down. As a result, there are active application servers in both zones during normal operations.

Central Services and the database services run in zone 1. The application servers in zone 2 might have longer network latency when they connect to Central Services and the database services because of the physical distance between zones.

If zone 1 goes offline, Central Services and the database services fail over to zone 2. You can bring the dormant application servers online to provide full capacity for application processing.

## DR considerations

Every tier in the SAP application stack uses a different approach to provide DR protection. For DR strategies and implementation details, refer to these 2 articles: [Disaster recovery overview and infrastructure guidelines for SAP workload](/azure/sap/workloads/disaster-recovery-overview-guide) and [Disaster recovery guidelines for SAP application](/azure/sap/workloads/disaster-recovery-sap-guide?tabs=linux).

> [!NOTE]
> If there's a regional disaster that causes a mass failover event for many Azure customers in one region, the target region's [resource capacity](/azure/site-recovery/azure-to-azure-common-questions#capacity) isn't guaranteed. Like all Azure services, Site Recovery continues to add features and capabilities. For the latest information about Azure-to-Azure replication, see the [support matrix](/azure/site-recovery/azure-to-azure-support-matrix).

## Management and operations considerations

To help keep your system running in production, consider the following points.

### Azure Center for SAP Solutions

Azure Center for SAP Solutions is an end-to-end solution that enables you to create and run SAP systems as a unified workload on Azure and provides a more seamless foundation for innovation. Also, Azure Center for SAP Solutions guided deployment experience takes care of creating the necessary compute, storage and networking components needed to run your SAP system. It then helps automate the installation of the SAP software according to Microsoft best practices.You can take advantage of the management capabilities for both new and existing Azure-based SAP systems.  Refer to [Azure Center for SAP Solutions](/azure/sap/center-sap-solutions/overview) for more details.

If you need more control over maintenance events or hardware isolation, for either performance or compliance, consider deploying your VMs on [dedicated hosts](/azure/virtual-machines/dedicated-hosts).

### Backup

Databases are critical workloads that require a low recovery point objective (RPO) and long-term retention.

- For SAP on SQL Server, one approach is to use [Azure Backup](/azure/backup/backup-azure-sql-database) to back up SQL Server databases that run on VMs. Another option is to use [Azure Files snapshots](https://azure.microsoft.com/mediahandler/files/resourcefiles/sql-server-data-files-in-microsoft-azure/SQL_Server_Data_Files_in_Microsoft_Azure.pdf) to back up SQL Server database files.

- For SAP on Oracle/Windows, see the "Backup/restore" section in [Azure VM DBMS Deployment for SAP](/azure/virtual-machines/workloads/sap/dbms_guide_oracle).

- For other databases, see the backup recommendations for your database provider. If the database supports the Windows Volume Shadow Copy Service (VSS), use VSS snapshots for application-consistent backups.

### Identity management

Use a centralized identity management system like AzureAD and AzureAD DS (Domain Services) to control access to resources at all levels:

- Provide access to Azure resources by using [Azure role-based access control (Azure RBAC)](/azure/role-based-access-control/overview).

- Grant access to Azure VMs by using Lightweight Directory Access Protocol (LDAP), Azure Active Directory (Azure AD), Kerberos, or another system.

Support access within the applications themselves by using the services that SAP provides. Or use [OAuth 2.0 and Azure AD](/azure/active-directory/develop/active-directory-protocols-oauth-code).

### Monitoring

To maximize the availability and performance of applications and services on Azure, use [Azure Monitor](/azure/azure-monitor/overview), a comprehensive solution for collecting, analyzing, and acting on telemetry from your cloud and on-premises environments. Azure Monitor shows how applications are performing and proactively identifies issues that affect them and the resources that they depend on.  For the SAP applications running on SAP HANA and other major database solutions, refer to the article [Azure Monitor for SAP solutions](/azure/sap/monitor/about-azure-monitor-sap-solutions) to learn how Azure Monitor for SAP helps in managing SAP services availability and performance.

## Security considerations

SAP has its own user management engine (UME) to control role-based access and authorization within the SAP application and databases. For detailed application security guidance, see [SAP NetWeaver Security Guide](https://help.sap.com/doc/saphelp_nw73ehp1/7.31.19/4a/af6fd65e233893e10000000a42189c/frameset.htm).

For more network security, consider using a [perimeter network](../../reference-architectures/dmz/secure-vnet-dmz.yml) that uses an NVA to create a firewall in front of the subnet for Web Dispatcher.

You can deploy an NVA to filter traffic between virtual networks, but don't place it between the SAP application and the database. Also, check the routing rules that are configured on the subnet and avoid directing traffic to a single-instance NVA. Doing so can lead to maintenance downtime and network or clustered-node failures.

For infrastructure security, data is encrypted in transit and at rest. For information about network security, see the "Security recommendations" section in [Azure Virtual Machines planning and implementation for SAP NetWeaver](/azure/virtual-machines/workloads/sap/planning-guide#security-recommendations). This article also specifies the network ports that you need to open on the firewalls to allow application communication.

You can use [Azure Disk Encryption](/azure/security/azure-security-disk-encryption-overview) to encrypt Windows VM disks. This service uses the BitLocker feature of Windows to provide volume encryption for the operating system and the data disks. The solution also works with Azure Key Vault to help you control and manage the disk-encryption keys and secrets in your key vault subscription. Data on the VM disks is encrypted at rest in your Azure storage.

For data-at-rest encryption, SQL Server transparent data encryption (TDE) encrypts SQL Server, Azure SQL Database, and Azure Synapse Analytics data files. For more information, see [SQL Server Azure Virtual Machines DBMS deployment for SAP NetWeaver](/azure/virtual-machines/workloads/sap/dbms_guide_sqlserver).

To monitor threats from inside and outside the firewall, consider deploying [Microsoft Sentinel (preview)](https://www.microsoft.com/security/blog/2021/05/19/protecting-sap-applications-with-the-new-azure-sentinel-sap-threat-monitoring-solution). The solution provides continuous threat detection and analytics for SAP systems that are deployed on Azure, in other clouds, or on-premises. For deployment guidance, see [Deploy Threat Monitoring for SAP in Microsoft Sentinel](/azure/sentinel/sap-deploy-solution).

As always, manage security updates and patches to safeguard your information assets. Consider using an end-to-end [automation approach](/azure/automation/update-management/manage-updates-for-vm) for this task.

## Cost considerations

Use the [Azure pricing calculator][azure-pricing-calculator] to estimate costs.

For more information, see the cost section in [Microsoft Azure Well-Architected Framework][aaf-cost].

If your workload requires more memory and fewer CPUs, consider using one of the [constrained vCPU VM](/azure/virtual-machines/constrained-vcpu) sizes to reduce software licensing costs that are charged per vCPU.

### VMs

This architecture uses VMs for the application tier and the database tier. The SAP NetWeaver tier uses Windows VMs to run SAP services and applications. The database tier runs AnyDB as the database, such as SQL Server, Oracle, or IBM DB2. VMs are also used as jump boxes for management.

There are several payment options for VMs:

- For workloads that have no predictable time of completion or resource consumption, consider the pay-as-you-go option.

- Consider using [Azure Reservations](/azure/cost-management-billing/reservations/save-compute-costs-reservations) if you can commit to using a VM over a one-year or three-year term. VM reservations can significantly reduce costs. You might pay as little as 72 percent of the cost of a pay-as-you-go service.

Use [Azure spot VMs][az-spot-vms] to run workloads that can be interrupted and don't require completion within a predetermined time frame or an SLA. Azure deploys spot VMs when there's available capacity and evicts them when it needs the capacity back. Costs that are associated with spot VMs are lower than for other VMs. Consider spot VMs for these workloads:

- High-performance computing scenarios, batch processing jobs, or visual rendering applications
- Test environments, including continuous integration and continuous delivery workloads
- Large-scale stateless applications

Azure reserved VM Instances lower your total cost of ownership by combining Azure Reserved VM Instances rates with a pay-as-you-go subscription to manage costs across predictable and variable workloads.  See [Azure Reserved Virtual Machine Instances](/azure/virtual-machines/prepay-reserved-vm-instances).

### Load Balancer

In this scenario, Load Balancer is used to distribute traffic to VMs in the application-tier subnet.

You're charged only for the number of configured load-balancing and outbound rules, plus the data that's processed through the load balancer. Inbound network address translation (NAT) rules are free. There's no hourly charge for Standard Load Balancer when no rules are configured.

### ExpressRoute

In this architecture, ExpressRoute is the networking service that's used to create private connections between an on-premises network and Azure virtual networks.

All inbound data transfer is free. All outbound data transfer is charged based on a pre-determined rate. For more information, see [Azure ExpressRoute pricing][expressroute-pricing].

## Communities

Communities can answer questions and help you set up a successful deployment. Consider these resources:

- [Running SAP Applications on the Microsoft Platform blog](https://techcommunity.microsoft.com/t5/Running-SAP-Applications-on-the/SAP-on-Azure-General-Update-March-2019/ba-p/377456?advanced=false&collapse_discussion=true&q=sap%20azure%20general%20update&search_type=thread)
- [Azure Community Support](https://azure.microsoft.com/support/forums)
- [SAP Community](https://www.sap.com/community.html)
- [Stack Overflow for SAP](http://stackoverflow.com/tags/sap/info)

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributor.*

Principal author:

- [Ben Trinh](https://www.linkedin.com/in/bentrinh) | Principal Architect

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

For more information and for examples of SAP workloads that use some of the same technologies as this architecture, see these articles:

- [Azure Virtual Machines planning and implementation for SAP NetWeaver](/azure/virtual-machines/workloads/sap/planning-guide)
- [Use Azure to host and run SAP workload scenarios](/azure/virtual-machines/workloads/sap/get-started)

## Related resources

- [Run SAP production workloads using an Oracle Database on Azure](../../example-scenario/apps/sap-production.yml)

<!-- links -->

[aaf-cost]: /azure/architecture/framework/cost/overview
[azure-pricing-calculator]: https://azure.microsoft.com/pricing/calculator
[expressroute-pricing]: https://azure.microsoft.com/pricing/details/expressroute
[az-spot-vms]: /azure/virtual-machines/windows/spot-vms

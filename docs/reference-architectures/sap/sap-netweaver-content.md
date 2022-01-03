<!-- cSpell:ignore lbrader netweaver jump-box jump-boxes ACLs HANA SWDs SMLG ABAP SAPGUI SAPGUIs SPOF WSFC ASCS MSEE Iperf SIOS sapmnt -->

This reference architecture shows a set of proven practices for running SAP NetWeaver in a Windows environment, on Azure, with high availability. The database is AnyDB, the SAP term for any supported database management system (DBMS) besides SAP HANA.

The first diagram shows SAP NetWeaver in a Windows environment in an availability set scenario. The architecture uses Azure NetApp Files for the shared files layer and a proximity placement group for improved performance:

![Diagram that shows a reference architecture for SAP NetWeaver on Windows. The database is AnyDB on Azure VMs with availability sets.](./images/sap-netweaver-availability-set-proximity-placement-group-netapp.jpg)

_Download a [Visio file](https://arch-center.azureedge.net/sap-netweaver-AVSet-Netapp-PPG.vsdx) that shows this architecture._

The second diagram shows SAP NetWeaver in a Windows environment. Availability Zones are used for improved resilience:

![Diagram that shows a reference architecture for SAP NetWeaver on Windows. The database is AnyDB on Azure VMs with Availability Zones.](./images/sap-netweaver-availability-zones.jpg)

_Download a [Visio file](https://arch-center.azureedge.net/sap-netweaver-AVZones.vsdx) that shows this architecture._

> [!NOTE]
> To deploy this reference architecture, you need appropriate licensing of SAP products and other non-Microsoft technologies.

## Architecture

This reference architecture describes a production system. It's deployed with specific virtual machine (VM) sizes that can be changed to accommodate your organization's needs. It can be reduced to a single VM. The network layout is greatly simplified to demonstrate the architectural principals. It's not intended to describe a full enterprise network.

These components are required:

**Virtual networks.** The [Azure Virtual Network](/azure/virtual-network/virtual-networks-overview) service connects Azure resources to each other with enhanced security. In this architecture, the virtual network connects to an on-premises environment via a virtual private network (VPN) gateway deployed in the hub of a [hub-spoke topology](../../reference-architectures/hybrid-networking/hub-spoke.yml). The spoke is the virtual network used for the SAP applications and the database tiers.

**Virtual network peering.** This architecture uses a hub-and-spoke networking topology with multiple virtual networks that are [peered together](/azure/virtual-network/virtual-network-peering-overview). This topology provides network segmentation and isolation for services deployed on Azure. Peering enables transparent connectivity between peered virtual networks through the Microsoft backbone network. It doesn't incur a performance penalty if deployed within a single region. The virtual network is subdivided into separate subnets for each tier application (SAP NetWeaver), the database, and shared services (like Jumpbox and Active Directory).

**Virtual machines.** This architecture uses virtual machines for the application tier and database tier, grouped like so:

- **SAP NetWeaver.** The application tier uses Windows virtual machines to run SAP Central Services and SAP application servers. The VMs that run Central Services are configured as a Windows Server Failover Cluster (WSFC) for high availability. They're supported by either Azure File Shares (AFS) or Azure shared disks.

- **AnyDB.** The database tier runs AnyDB as the database, such as Microsoft SQL Server, Oracle, or IBM Db2.

- **Jumpbox** (also called a _bastion host_). Administrators use this improved-security virtual machine to connect to the other virtual machines. It's typically a part of shared services, like domain controllers and backup services. If Secure Shell Protocol (SSH) and Remote Desktop Protocol (RDP) are the only services used for server administration, an [Azure Bastion](/azure/bastion/bastion-overview) host is an alternative. But if you use other management tools, like SQL Server Management Studio or SAP Front End, use a traditional, self-deployed jump box.

- **Windows Server Active Directory domain controllers.** The domain controllers are used for identity management of all virtual machines and users in the domain.

**Load balancers.** Load balancers are used to distribute traffic to virtual machines in the application-tier subnet. For high availability, use the built-in SAP Web Dispatcher, [Azure Load Balancer](/azure/load-balancer/load-balancer-overview), or network appliances. Your choice depends on the traffic type (like HTTP or SAP GUI) or the required network services, like Secure Sockets Layer (SSL) termination.

**Availability sets.** VMs for all pools and clusters (Web Dispatcher, SAP application servers, Central Services, and databases) are grouped into separate [availability sets](/azure/virtual-machines/windows/tutorial-availability-sets). At least two virtual machines are provisioned per role. Availability sets increase the availability of the applications and VMs. They do so through management of host system faults or maintenance events by distributing role instances onto multiple hosts. An alternative is to use [Availability Zones](/azure/virtual-machines/workloads/sap/sap-ha-availability-zones) to improve workload availability, as described later in this article.

**Zone-redundant gateway.** Azure ExpressRoute or VPN gateways can be deployed across zones to guard against zone failures. See [Zone-redundant virtual network gateways](/azure/vpn-gateway/about-zone-redundant-vnet-gateways) to understand the differences between a zonal deployment and a zone-redundant deployment.

**Proximity placement group.** This logical group places a constraint on VMs deployed in an availability set or a virtual machine scale set. A [proximity placement group](https://azure.microsoft.com/blog/introducing-proximity-placement-groups) favors collocation, meaning that virtual machines are in the same datacenter to minimize application latency.

**Network security groups.** To restrict incoming, outgoing, and intra-subnet traffic in the virtual network, create [network security groups](/azure/virtual-network/tutorial-filter-network-traffic-cli).

**Application security groups.** To define fine-grained network security policies based on workloads that are centered on applications, use [application security groups](/azure/virtual-network/security-overview) instead of explicit IP addresses. They let you group VMs by name and help you secure applications by filtering traffic from trusted segments of your network.

**Gateway.** A gateway connects distinct networks, extending your on-premises network to the Azure virtual network. We recommend that you use [ExpressRoute](../../reference-architectures/hybrid-networking/expressroute.yml) to create private connections that don't go over the public internet, but you can also use a [site-to-site](../../reference-architectures/hybrid-networking/expressroute.yml) connection. To reduce latency or increase throughput, consider [ExpressRoute Global Reach](/azure/expressroute/expressroute-global-reach) and [ExpressRoute FastPath](/azure/expressroute/about-fastpath), as discussed later in this article.

**Azure Storage.** Azure Storage provides data persistence for a virtual machine in the form of a virtual hard disk (VHD). We recommend [Azure managed disks](/azure/virtual-machines/windows/managed-disks-overview).

## Recommendations

This architecture describes a small production-level deployment. Your deployment will differ based on your business requirements, so consider these recommendations a starting point.

### Virtual machines

In application server pools and clusters, adjust the number of virtual machines based on your requirements. The [Azure Virtual Machines planning and implementation guide](/azure/virtual-machines/workloads/sap/planning-guide) includes details about running SAP NetWeaver on virtual machines.

For details about SAP support for Azure virtual machine types and throughput metrics (SAPS), see [SAP note 1928533](https://launchpad.support.sap.com/#/notes/1928533). (To access SAP notes, you need an SAP Service Marketplace account.)

### SAP Web Dispatcher (SWD)

The Web Dispatcher component is used as a load balancer for SAP traffic among the SAP application servers. To achieve high availability for the Web Dispatcher component, Azure Load Balancer is used to implement either the failover cluster of SWDs or the parallel SWD setup. See [High Availability of the SAP Web Dispatcher](https://help.sap.com/doc/saphelp_nw73ehp1/7.31.19/48/9a9a6b48c673e8e10000000a42189b/frameset.htm) for a detailed description of the solution.

### Application servers pool

The SAP SMLG transaction is commonly used to manage logon groups for ABAP application servers and to load balance logon users. Other transactions, like SM61 for batch server groups and RZ12 for RFC groups, also load balance logon users. These transactions use the load-balancing capability within the message server of SAP Central Services to distribute incoming sessions or workloads among the SAP application servers pool for SAP GUIs and RFC traffic.

### SAP Central Services Cluster

This reference architecture runs Central Services on VMs in the application tier. Central Services is a potential single point of failure (SPOF) when it's deployed to a single VM. To implement a highly available solution, use either a file-share cluster or a shared-disk cluster.

For highly available file-shares, there are several options. We recommend that you use [Azure Files](/azure/storage/files/storage-files-introduction) shares as fully managed, cloud-native SMB or NFS shares. An alternative to Azure Files is [Azure NetApp Files](/azure/azure-netapp-files/azure-netapp-files-introduction), which provides high-performance NFS and SMB shares.

You can also implement the highly available file shares on the Central Service instances by using WSFC with ([Azure Files](https://docs.microsoft.com/azure/virtual-machines/workloads/sap/high-availability-guide-windows-azure-files-smb)). This solution also supports Windows Cluster with shared disks by using an Azure shared disk as the cluster shared volume (CSV). If you prefer to use shared disks, we recommend that you use [Azure shared disks](/azure/virtual-machines/disks-shared#linux) to set up a [Windows Server failover cluster for SAP Central Services Cluster](/azure/virtual-machines/workloads/sap/sap-high-availability-infrastructure-wsfc-shared-disk).

There are also third-party products like [SIOS DataKeeper Cluster Edition](https://azuremarketplace.microsoft.com/marketplace/apps/sios_datakeeper.sios-datakeeper-8) from SIOS Technology Corp. This add-on replicates contents from independent disks attached to the ASCS cluster nodes and then presents the disks as a CSV to the cluster software.

In the case of cluster network partitioning, the cluster software uses quorum votes to decide which segment of the network and its associated services will serve as the brain of the now fragmented cluster. Windows offers a number of quorum models. This solution uses Azure [Cloud Witness](/windows-server/failover-clustering/deploy-cloud-witness) because it's simpler and provides more availability than a compute node witness. The [Azure file share witness](/windows-server/failover-clustering/file-share-witness) is another alternative to provide a cluster quorum vote.

On an Azure deployment, the application servers connect to the highly available Central Services through the virtual host names of the ASCS or ERS services. These host names are assigned to the cluster front-end IP configuration of the load balancer. Azure Load Balancer supports multiple front-end IPs, so both the ASCS and ERS virtual IPs (VIPs) can be bounded to one load balancer.

### Availability sets

Availability sets distribute servers to various physical infrastructures and update groups to improve service availability. To meet service-level agreements ([SLAs](https://azure.microsoft.com/support/legal/sla/virtual-machines)), put virtual machines that perform the same role into an availability set. Doing so helps guard against planned and unplanned downtime imposed by Azure infrastructure maintenance or caused by hardware faults. To get a higher SLA, you need to have two or more virtual machines per availability set.

All virtual machines in a set must perform the same role. Don't mix servers of different roles in the same availability set. For example, don't place an ASCS node in the same availability set with the application servers.

You can deploy Azure availability sets in [Azure Availability Zones](/azure/virtual-machines/workloads/sap/sap-ha-availability-zones) when you use a [proximity placement group](/azure/virtual-machines/linux/co-location).

### Networking

This architecture uses a hub-spoke topology. The hub virtual network acts as a central point of connectivity to an on-premises network. The spokes are virtual networks that peer with the hub and isolate the SAP workloads. Traffic flows between the on-premises datacenter and the hub through a gateway connection.

#### Network interface cards (NICs)

Network interface cards enable all communication among virtual machines on a virtual network. Traditional on-premises SAP deployments implement multiple NICs per machine to segregate administrative traffic from business traffic.

On Azure, the virtual network is a software-defined network that sends all traffic through the same network fabric. So it's not necessary to use multiple NICs for performance reasons. But if your organization needs to segregate traffic, you can deploy multiple NICs per VM and connect each NIC to a different subnet. You can then use network security groups to enforce different access control policies.

Azure NICs support multiple IPs. This support conforms with the SAP recommended practice of using virtual host names for installations. For a complete outline, see [SAP note 962955](https://launchpad.support.sap.com/#/notes/962955). (To access SAP notes, you need an SAP Service Marketplace account.)

#### Subnets and network security groups

This architecture subdivides the virtual network address space into subnets. You can associate each subnet with a network security group that defines the access policies for the subnet. Place application servers on a separate subnet. Doing so allows you to secure them more easily by managing the subnet security policies rather than the individual servers.

When associated with a subnet, a network security group applies to all servers within the subnet and offers fine-grained control over the servers. Set them up by using the [Azure portal](/azure/virtual-network/tutorial-filter-network-traffic), [PowerShell](/azure/virtual-network/tutorial-filter-network-traffic-powershell), or [Azure CLI](/azure/virtual-network/tutorial-filter-network-traffic-cli).

#### ExpressRoute Global Reach

If your network environment includes two or more ExpressRoute connections, [ExpressRoute Global Reach](/azure/expressroute/expressroute-global-reach) can help you reduce network hops and latency. This technology is a BGP route peering set up between two or more ExpressRoute connections to bridge two ExpressRoute routing domains. Global Reach reduces latency when network traffic traverses more than one ExpressRoute connection. It's currently available only for private peering on ExpressRoute circuits.

At this time, there are no network access control lists (ACLs) or other attributes that can be changed in Global Reach. So all routes learned by a given ExpressRoute circuit (from on-premises and Azure) are advertised across the circuit peering to the other ExpressRoute circuit. We recommend that you establish network traffic filtering on-premises to restrict access to resources.

#### ExpressRoute FastPath

Also known as Microsoft Edge Exchange (MSEE) v2, [FastPath](/azure/expressroute/about-fastpath) implements MSEE at the entry point of the Azure network. It reduces network hops for most data packets.

For all new ExpressRoute connections to Azure, FastPath is the default configuration. For existing ExpressRoute circuits, contact Azure support to activate FastPath.

FastPath doesn't support virtual network peering. If other virtual networks are peered with one that's connected to ExpressRoute, the network traffic from your on-premises network to the other spoke virtual networks will continue to be sent to the virtual network gateway. The workaround is to connect all virtual networks to the ExpressRoute circuit directly.

### Load balancers

The [SAP Web Dispatcher](https://help.sap.com/doc/saphelp_nw73ehp1/7.31.19/48/8fe37933114e6fe10000000a421937/frameset.htm) handles load balancing of HTTP(S) traffic to a pool of SAP application servers. This software load balancer provides application layer services (referred to as layer 7 in the ISO networking model) that can perform SSL termination and other offloading functions.

[Azure Load Balancer](https://azure.microsoft.com/blog/azure-load-balancer-new-distribution-mode) is a network transmission layer service (layer 4) that balances traffic by using a 5-tuple hash from the data streams. (The hash is based on source IP, source port, destination IP, destination port, and protocol type.) In SAP deployments on Azure, Load Balancer is used in cluster setups to direct traffic to the primary service instance or to the healthy node if there's a fault.

We recommend that you use [Azure Standard Load Balancer](/azure/load-balancer/load-balancer-standard-overview) for all SAP scenarios. If virtual machines in the back-end pool require public outbound connectivity, or if they're used in an Azure zone deployment, the standard load balancers require [more configurations](/azure/virtual-machines/workloads/sap/high-availability-guide-standard-load-balancer-outbound-connections) after they're secure, by default. They won't allow outbound connectivity unless you explicitly configure it.

For traffic from SAP GUI clients that connect to an SAP server via DIAG protocol or Remote Function Calls (RFC), the Central Services message server balances the load through SAP application server [logon groups](https://wiki.scn.sap.com/wiki/display/SI/ABAP+Logon+Group+based+Load+Balancing). You don't need another load balancer.

### Azure Storage

Some organizations use standard storage for their application servers. Standard managed disks aren't supported. See [SAP note 1928533](http://service.sap.com/sap/support/notes/1928533). (SAP Service Marketplace account required.) We recommend that you use premium [Azure managed disks](/azure/storage/storage-managed-disks-overview) in all cases. Note that a recent update to [SAP note 2015553](https://launchpad.support.sap.com/#/notes/2015553) excludes the use of Standard HDD storage and Standard SSD storage for a few specific use cases.

Application servers don't host business data. So you can also use the smaller P4 and P6 premium disks to help minimize cost. Doing so also allows you to benefit from the [single-instance VM SLA](https://azure.microsoft.com/support/legal/sla/virtual-machines/v1_6) if you have a central SAP stack installation.

For high-availability scenarios, you can use [Azure File Shares](/azure/storage/files/storage-files-introduction) and [Azure shared disks](/azure/virtual-machines/disks-shared). Premium SSD and Ultra SSD [Azure managed disks](/azure/storage/storage-managed-disks-overview) are available for Azure shared disks, and Premium SSD is available for Azure File Shares.

Azure Storage is also used by [Cloud Witness](/windows-server/failover-clustering/deploy-cloud-witness) to maintain quorum with a device in a remote Azure region, away from the primary region where the cluster resides.

For the backup data store, we recommend Azure [cool and archive access tiers](/azure/storage/blobs/access-tiers-overview). These storage tiers provide a cost-effective way to store long-lived data that is infrequently accessed.

[Ultra disks](/azure/virtual-machines/linux/disks-enable-ultra-ssd) greatly reduce disk latency and benefit performance-critical applications like the SAP database servers. [Compare block storage options in Azure.](/azure/virtual-machines/windows/disks-types)

For a high-availability, high-performance shared data store, use [Azure NetApp Files](/azure/azure-netapp-files/azure-netapp-files-introduction). This technology is particularly useful for the database tier when you're using [Oracle](/azure/azure-netapp-files/performance-oracle-single-volumes), and also when you're [hosting application data](/azure/virtual-machines/workloads/sap/high-availability-guide-windows-netapp-files-smb).

## Performance considerations

SAP application servers communicate constantly with the database servers. For performance-critical applications that run on database platforms, enable [Write Accelerator](/azure/virtual-machines/windows/how-to-enable-write-accelerator) for the log volume. Doing so can improve log-write latency. Write Accelerator is available for M-series VMs. To optimize inter-server communications, use [accelerated networking](https://azure.microsoft.com/blog/linux-and-windows-networking-performance-enhancements-accelerated-networking). Accelerated networking is available only for supported VM series, including D/DSv2, D/DSv3, E/ESv3, F/FS, FSv2, and Ms/Mms. For more information, see [Maximize VM performance with accelerated networking](https://azure.microsoft.com/blog/maximize-your-vm-s-performance-with-accelerated-networking-now-generally-available-for-both-windows-and-linux).

To achieve high IOPS and disk bandwidth throughput, the common practices in storage volume [performance optimization](/azure/virtual-machines/linux/premium-storage-performance) apply to Azure storage layout. For example, you can combine multiple disks together to create a striped disk volume to improve I/O performance. Enabling the read cache on storage content that changes infrequently enhances the speed of data retrieval.

[Ultra disks](/azure/virtual-machines/linux/disks-enable-ultra-ssd) are now available for I/O-demanding applications. Where they're available, we recommend them over [Write Accelerator](/azure/virtual-machines/windows/how-to-enable-write-accelerator) premium storage. You can individually increase or decrease performance metrics, like IOPS and MBps, without needing to reboot.

For SAP on Azure, [Azure Virtual Machines planning and implementation for SAP NetWeaver](/azure/virtual-machines/workloads/sap/planning-guide) provides excellent advice on optimizing Azure storage for SAP workloads on SQL Server.

We don't recommend the placement of any network virtual appliance (NVA) between the application and the database layers for any SAP application stack. This practice introduces significant processing time for data packets, which leads to unacceptable application performance.

### Proximity placement groups

Some SAP applications require frequent communication with the database. The physical proximity of the application and the database layers affects network latency, which can adversely affect application performance.

To optimize network latency, you can use [proximity placement groups](/azure/virtual-machines/workloads/sap/sap-proximity-placement-scenarios), which set a logical constraint on the virtual machines deployed in availability sets. Proximity placement groups favor collocation and performance over scalability, availability, or cost. They can greatly improve the user experience for most SAP applications. Scripts are available on [GitHub](https://github.com/Azure/SAP-on-Azure-Scripts-and-Utilities).

### Availability Zones

[Availability Zones](/azure/availability-zones/az-overview) allow you to deploy virtual machines across zones. That is, physically separated locations within a specific Azure region. Their purpose is to enhance service availability, but consider performance when you deploy resources with zones.

Administrators need a clear network latency profile between all zones of a target region before they can determine the resource placement with minimum inter-zone latency. To create this profile, deploy small virtual machines in each zone for testing. Recommended tools for these tests include [PsPing](/sysinternals/downloads/psping) and [Iperf](https://sourceforge.net/projects/iperf). When the tests are done, remove the virtual machines that you used for testing.

## Scalability considerations

For the SAP application layer, Azure offers a wide range of virtual machine sizes for scaling up and scaling out. For an inclusive list, see [SAP note 1928533 - SAP Applications on Azure: Supported Products and Azure VM Types](https://launchpad.support.sap.com/#/notes/1928533). (To access SAP notes, you need an SAP Service Marketplace account.)

You can scale SAP application servers and the Central Services clusters up, down, or out by adding more instances. The AnyDB database can scale up and down but doesn't scale out. The SAP database container for AnyDB doesn't support sharding.

## Availability considerations

Resource redundancy is the general theme in high-availability infrastructure solutions. For enterprises that have a less stringent SLA, single-instance Azure virtual machines with premium disks provide an [uptime SLA](https://azure.microsoft.com/support/legal/sla/virtual-machines/v1_8). When you deploy redundant resources in an availability set or across Availability Zones, the service availability is elevated.

In this distributed installation of the SAP application, the base installation is replicated to achieve high availability. For each layer of the architecture, the high availability design varies.

### Web Dispatcher in the application servers tier

The Web Dispatcher component is used as a load balancer for SAP traffic among the SAP application servers. To achieve [high availability of the SAP Web Dispatcher](https://help.sap.com/doc/saphelp_nw73ehp1/7.31.19/en-US/48/9a9a6b48c673e8e10000000a42189b/frameset.htm), Azure Load Balancer implements either the failover cluster or the parallel Web Dispatcher setup.

For internet-facing communications, we recommend a stand-alone solution in the perimeter network (also known as _DMZ_) to satisfy security concerns.

[Embedded Web Dispatcher](https://help.sap.com/viewer/00b4e4853ef3494da20ebcaceb181d5e/LATEST/en-US/2e708e2d42134b4baabdfeae953b24c5.html) on ASCS is a special option. You should take into account proper sizing because of additional workload on ASCS.

### Central Services in the application servers tier

High availability of the Central Services is implemented with WSFC. When the cluster storage for the failover cluster is deployed on Azure, you can configure it in two ways: as a clustered shared volume or as a file share.

We recommend that you use [Azure Files](/azure/storage/files/storage-files-introduction) as fully managed, cloud-native SMB or NFS shares. An alternative to Azure Files is [Azure NetApp Files](/azure/azure-netapp-files/azure-netapp-files-introduction), which provides high-performance, enterprise-class NFS and SMB shares.

There are two ways to set up clusters with shared disks on Azure. First, we recommend that you use [Azure shared disks](/azure/virtual-machines/disks-shared) to set up a [Windows Server Failover Cluster for SAP Central Services Cluster](/azure/virtual-machines/workloads/sap/sap-high-availability-infrastructure-wsfc-shared-disk).

Alternatively, you can use SIOS DataKeeper to:

- Replicate the content of independent disks attached to the cluster nodes.
- Abstract the drives as a CSV for the cluster manager.

For implementation details, see [Clustering SAP ASCS on Azure](https://techcommunity.microsoft.com/t5/Running-SAP-Applications-on-the/Clustering-SAP-ASCS-Instance-using-Windows-Server-Failover/ba-p/367898).

With the introduction of the Azure Standard Load Balancer, you can now simply enable the [high availability port](/azure/load-balancer/load-balancer-ha-ports-overview). Doing so allows you to avoid configuring load-balancing rules for many SAP ports. Also, when you set up load balancers in general, whether on-premises or on Azure, enable the Direct Server Return feature (also called _Floating IP_ or _DSR_). Doing so allows server responses to bypass the load balancer. This direct connection keeps the load balancer from becoming a bottleneck in the path of data transmission. For the SAP ASCS and database clusters, we recommend that you enable DSR.

### Application services in the application servers tier

High availability for the SAP application servers is achieved by load-balancing traffic within a pool of application servers.

### Database tier

For this reference architecture, we've assumed the source database is running on AnyDB. That is, a DBMS like SQL Server, SAP ASE, IBM Db2, or Oracle. The database tier's native replication feature provides either manual or automatic failover between replicated nodes.

For implementation details about specific database systems, see [Azure Virtual Machines DBMS deployment for SAP NetWeaver](/azure/virtual-machines/workloads/sap/dbms_guide_general).

### Virtual machines deployed across Availability Zones

Availability Zones are a logical construct designed to improve workload availability and protect application services and virtual machines against datacenter outages. Virtual machines in a single zone are treated as if they were in a single update or fault domain. When you select zonal deployment, virtual machines in the same zone are distributed to fault and upgrade domains on a best-effort basis.

In [Azure regions](https://azure.microsoft.com/global-infrastructure/regions) that support this feature, at least three zones are available. But the maximum distance between datacenters in these zones isn't guaranteed. To deploy a multitier SAP system across zones, you need to know the network latency within a zone and across targeted zones. You also need to know how sensitive your deployed applications are to network latency.

Take these [considerations](/azure/virtual-machines/workloads/sap/sap-ha-availability-zones) into account when you decide to deploy resources across Availability Zones:

- Latency between virtual machines in one zone.

- Latency between virtual machines across chosen zones.

- Availability of the same Azure services (virtual machine types) in the chosen zones.

> [!NOTE]
> Availability Zones support high availability, but they aren't effective for DR. The distances between zones are too short. Typical DR regions should be at least 100 miles away from the primary region.

**Active/inactive deployment example**

In this example deployment, the [active/passive](/azure/virtual-machines/workloads/sap/sap-ha-availability-zones#activepassive-deployment) status refers to the application service state within the zones. In the application layer, all four active application servers of the SAP system are in zone 1. Another set of four passive application servers is built in zone 2 but shut down. They'll be activated only when needed.

The two-node clusters for Central Services and the database services are stretched across two zones. If zone 1 fails, Central Services and the database services will run in zone 2. The passive application servers in zone 2 get activated. With all components of this SAP system now collocated in the same zone, network latency is minimized.

**Active/active deployment example**

In an [active/active](/azure/virtual-machines/workloads/sap/sap-ha-availability-zones#activeactive-deployment) deployment, two sets of application servers are built across two zones. Within each zone, two application servers in each set of servers are inactive (shut down). As a result, there are active application servers in both zones during normal operations.

Central Services and the database services run in zone 1. The application servers in zone 2 might have longer network latency when they connect to Central Services and the database services because of the physical distance between zones.

If zone 1 goes offline, Central Services and the database services will fail over to zone 2. You can bring the dormant application servers online to provide full capacity for application processing.

## Disaster recovery considerations

Every tier in the SAP application stack uses a different DR strategy.

### Application servers tier

SAP application servers don't contain business data. On Azure, a simple DR strategy is to create SAP application servers in the secondary region, and then shut them down. If there are configuration changes or kernel updates on the primary application server, you need to apply the same changes to the virtual machines in the secondary region. For example, copy the SAP kernel executable files to the DR virtual machines.

For automatic replication of application servers to a secondary region, we recommend [Azure Site Recovery](/azure/site-recovery/site-recovery-overview). You can also use Azure Site Recovery to set up DR for a [multitier SAP NetWeaver application](/azure/site-recovery/site-recovery-sap) deployment.

### Central Services

This component of the SAP application stack doesn't persist business data. For DR protection, either replicate the AFS SMB file share, which contains the /sapmnt directory and other content, onto another AFS SMB share (also with ZRS or not) in the DR region. Alternatively, you can use Site Recovery to replicate the Central Services cluster by using SIOS DataKeeper disks.

You can build a virtual machine in the DR region to replicate the Central Services role and content. The only content from the primary Central Services node to synchronize is the /sapmnt share. If the configuration changes or kernel updates take place on the primary Central Services servers, you need to repeat the changes on the virtual machine in the DR region. For details about this replication method's build, copy, and test failover process, download [SAP NetWeaver: Building a Hyper-V and Microsoft Azure–based Disaster Recovery Solution](https://download.microsoft.com/download/9/5/6/956FEDC3-702D-4EFB-A7D3-2DB7505566B6/SAP%20NetWeaver%20-%20Building%20an%20Azure%20based%20Disaster%20Recovery%20Solution%20V1_5%20.docx). See "4.3. SAP SPOF layer (ASCS)."

<!--markdownlint-disable MD024 -->

### Database tier

It's best to use a database's integrated replication technology for DR. For example, for SQL Server, we recommend that you use Always On availability groups to establish a replica in a remote region and replicate transactions asynchronously by using manual failover. Asynchronous replication avoids an impact to the performance of interactive workloads at the primary site. When you use a manual failover, you can then evaluate the DR impact and decide if operating from the DR site is justified.

If you're using Azure NetApp Files for your database storage, you might be able to use [cross-region replication](/azure/azure-netapp-files/cross-region-replication-introduction) to replicate data to a secondary region. This feature is currently in preview, so evaluate whether it meets your requirements for production workloads.

### DR for shared services

Many IT services, like administrative jump boxes, cloud-based directory services, backup, and monitoring services, are shared by all your deployed cloud assets. Replicate your shared services into the DR region by using whatever means the services provide.

### Automated DR with Azure Site Recovery

To use Azure Site Recovery to automatically build a fully replicated production site of your original configuration, you need to run customized [deployment scripts](/azure/site-recovery/site-recovery-runbook-automation). For example, Site Recovery first deploys the virtual machines in availability sets. It then runs your custom scripts to attach the existing (prebuilt) load balancer, in which the backend pool is already defined, to the NIC of the failover virtual machines. An example of the custom Site Recovery Automation Runbooks script is available on [GitHub](https://github.com/Azure/azure-quickstart-templates/tree/master/demos/asr-automation-recovery).

> [!NOTE]
> In case of a regional disaster that causes a mass failover event for many Azure customers in one region, the target region's resource [capacity](/azure/site-recovery/azure-to-azure-common-questions#capacity) isn't guaranteed. Like all Azure services, Site Recovery continues to improve its features and capabilities. See the latest [support matrix](/azure/site-recovery/azure-to-azure-support-matrix) for disaster recovery of Azure virtual machines from one Azure region to another.

## Management and operations considerations

### Backup

Databases are critical workloads that require a low Recovery Point Objective (RPO) and long-term retention.

- For SAP on SQL Server, one approach is to use [Azure Backup](/azure/backup/backup-azure-sql-database) to back up SQL Server databases that run on virtual machines. Another option is to use [Azure Files snapshots](https://azure.microsoft.com/mediahandler/files/resourcefiles/sql-server-data-files-in-microsoft-azure/SQL_Server_Data_Files_in_Microsoft_Azure.pdf) to back up SQL Server database files.

- For SAP on Oracle/Windows, see the "Backup/restore" section in [Azure VM DBMS Deployment for SAP](/azure/virtual-machines/workloads/sap/dbms_guide_oracle).

- For other databases, see the backup recommendations for your database provider. If the database supports the Windows Volume Shadow Copy Service (VSS), then application-consistent backups using VSS snapshots

### Identity management

Use a centralized identity management system to control access to resources at all levels:

- Provide access to Azure resources by using [Azure role-based access control (Azure RBAC)](/azure/role-based-access-control/overview).

- Grant access to Azure virtual machines by using Lightweight Directory Access Protocol (LDAP), Azure Active Directory, Kerberos, or another system.

Support access within the applications themselves by using the services that SAP provides. Or use [OAuth 2.0 and Azure Active Directory](/azure/active-directory/develop/active-directory-protocols-oauth-code).

### Monitoring

[Azure Monitor](/azure/azure-monitor/overview) provides sophisticated tools for collecting and analyzing telemetry. These tools help you maximize the performance and availability of your cloud and on-premises resources and applications. (Azure Monitor now includes Log Analytics and Application Insights.) You can use Azure Monitor to monitor infrastructure and application anomalies, alert administrators, and automate reactions to predefined conditions.

To provide SAP-based monitoring of resources and service performance of the SAP infrastructure, use the [Azure SAP Enhanced Monitoring](/azure/virtual-machines/workloads/sap/deployment-guide) extension. This extension feeds Azure monitoring statistics into the SAP application for operating system monitoring and DBA Cockpit functions. SAP Enhanced Monitoring is required for running SAP on Azure. For details, see [SAP note 2191498](https://launchpad.support.sap.com/#/notes/2191498), "SAP on Linux with Azure: Enhanced Monitoring." (To access SAP notes, you need an SAP Service Marketplace account.)

[Azure Monitor for SAP Solutions](/azure/virtual-machines/workloads/sap/azure-monitor-overview) is the future direction for an Azure-native, end-to-end monitoring solution for SAP NetWeaver. This solution is currently in preview and is available only in a limited set of regions. You should carefully evaluate whether it meets your requirements.

Azure Monitor for SAP Solutions provides a comprehensive initial set of metrics and telemetry for monitoring. The metric definitions are stored as SQL queries in JSON. You can change them to meet your requirements. You can get the starting set of metrics on [GitHub](https://github.com/Azure/AzureMonitorForSAPSolutions/blob/master/sapmon/content/SapNetweaver.json).

## Security considerations

SAP has its own user management engine (UME) to control role-based access and authorization within the SAP application and databases. For detailed application security guidance, see the [SAP NetWeaver Security Guide](https://help.sap.com/doc/saphelp_nw73ehp1/7.31.19/4a/af6fd65e233893e10000000a42189c/frameset.htm).

For additional network security, consider using a [perimeter network](../../reference-architectures/dmz/secure-vnet-dmz.yml) that uses a network virtual appliance (NVA) to create a firewall in front of the subnet for Web Dispatcher.

You can deploy an NVA to filter traffic between virtual networks, but don't place it between the SAP application and the database. Also, check the routing rules configured on the subnet and avoid directing traffic to a single-instance NVA. Doing so can lead to maintenance downtime and network or clustered-node failures.

For infrastructure security, data is encrypted in transit and at rest. The "Security recommendations" section in [Azure Virtual Machines planning and implementation for SAP NetWeaver](/azure/virtual-machines/workloads/sap/planning-guide#security-recommendations) addresses network security. This article also specifies the network ports you need to open on the firewalls to allow application communication.

You can use [Azure Disk Encryption](/azure/security/azure-security-disk-encryption-overview) to encrypt Windows virtual machine disks. It uses the BitLocker feature of Windows to provide volume encryption for the operating system and the data disks. The solution also works with Azure Key Vault to help you control and manage the disk-encryption keys and secrets in your key vault subscription. Data on the virtual machine disks are encrypted at rest in your Azure storage.

For data-at-rest encryption, SQL Server Transparent Data Encryption (TDE) encrypts SQL Server, Azure SQL Database, and Azure SQL Data Warehouse data files. For more information, see [SQL Server Azure Virtual Machines DBMS deployment for SAP NetWeaver](/azure/virtual-machines/workloads/sap/dbms_guide_sqlserver).

As always, be sure to manage security updates and patches to safeguard your information assets. Consider using an end-to-end [automation approach](/azure/automation/update-management/manage-updates-for-vm) for this task.

## Cost considerations

Use the [Azure pricing calculator][azure-pricing-calculator] to estimate costs.

For more information, see the cost section in [Microsoft Azure Well-Architected Framework][aaf-cost].

If your workload requires more memory and fewer CPUs, consider using one of the [constrained vCPU virtual machine](/azure/virtual-machines/constrained-vcpu) sizes to reduce software licensing costs that are per-vCPU.

### Virtual machines

This architecture uses virtual machines for the application tier and the database tier. The SAP NetWeaver tier uses Windows virtual machines to run SAP services and applications. The database tier runs AnyDB as the database, like SQL Server, Oracle, or IBM DB2. Virtual machines are also used as jump boxes for management.

There are several payment options for virtual machines in general:

- For workloads that have no predictable time of completion or resource consumption, consider the pay-as-you-go option.

- Consider using [Azure Reservations](/azure/cost-management-billing/reservations/save-compute-costs-reservations) if you can commit to using a virtual machine over a one-year or three-year term. VM reservations can reduce costs as much 72 percent as compared to pay-as-you-go prices.

Use [Azure Spot Virtual Machines][az-spot-vms] to run workloads that can be interrupted and don't require completion within a predetermined time frame or an SLA. Azure deploys spot virtual machines when there's available capacity and evicts them when it needs the capacity back. Costs associated with spot virtual machines are lower. Consider spot VMs for these workloads:

- High-performance computing scenarios, batch processing jobs, or visual rendering applications.
- Test environments, including continuous integration and continuous delivery workloads.
- Large-scale stateless applications.

If you need more control over maintenance events or hardware isolation, for either performance or compliance, consider deploying your virtual machines on [dedicated hosts](/azure/virtual-machines/dedicated-hosts).

### Virtual machines and availability sets

For all pools and clusters (Web Dispatcher, SAP application servers, Central Services, and the database) the virtual machines are grouped into separate availability sets. There's no cost for an availability set. You pay only for each VM instance that you create.

If you're deploying a workload across Availability Zones, availability sets aren't required.

### Azure Load Balancer

In this scenario, Azure Load Balancer is used to distribute traffic to virtual machines in the application-tier subnet.

You're charged only for the number of configured load-balancing and outbound rules. Inbound NAT rules are free. There's no hourly charge for the Standard Load Balancer when no rules are configured.

### ExpressRoute

In this architecture, ExpressRoute is the networking service used to create private connections between an on-premises network and Azure virtual networks.

All inbound data transfer is free. All outbound data transfer is charged based on a pre-determined rate. See [Azure ExpressRoute pricing][expressroute-pricing] for more info.

## Communities

Communities can answer questions and help you set up a successful deployment. Consider these resources:

- [Running SAP Applications on the Microsoft Platform blog](https://techcommunity.microsoft.com/t5/Running-SAP-Applications-on-the/SAP-on-Azure-General-Update-March-2019/ba-p/377456?advanced=false&collapse_discussion=true&q=sap%20azure%20general%20update&search_type=thread)

- [Azure Community Support](https://azure.microsoft.com/support/forums)

- [SAP Community](https://www.sap.com/community.html)

- [Stack Overflow for SAP](http://stackoverflow.com/tags/sap/info)

## Related resources

See these articles for more information and for examples of SAP workloads that use some of the same technologies:

- [Azure Virtual Machines planning and implementation for SAP NetWeaver](/azure/virtual-machines/workloads/sap/planning-guide)

- [Use Azure to host and run SAP workload scenarios](/azure/virtual-machines/workloads/sap/get-started)

- [Running SAP production workloads using an Oracle Database on Azure](../../example-scenario/apps/sap-production.yml)

- [Dev/test environments for SAP workloads on Azure](../../example-scenario/apps/sap-dev-test.yml)

<!-- links -->

[aaf-cost]: /azure/architecture/framework/cost/overview.md
[azure-pricing-calculator]: https://azure.microsoft.com/pricing/calculator
[expressroute-pricing]: https://azure.microsoft.com/pricing/details/expressroute
[visio-download]: https://arch-center.azureedge.net/sap-netweaver.vsdx
[az-spot-vms]: /azure/virtual-machines/windows/spot-vms

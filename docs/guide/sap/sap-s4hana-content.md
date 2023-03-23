<!-- cSpell:ignore lbrader HANA Fiori -->

This guide presents a set of proven practices for running S/4HANA and Suite on HANA in a high availability environment that supports disaster recovery (DR) on Azure. The Fiori information applies only to S/4HANA applications.

## Architecture

:::image type="content" source="media/s4-avset-afs-ppg.png" alt-text="Architecture diagram that shows SAP S/4HANA for Linux virtual machines in an Azure availability set." lightbox="media/s4-avset-afs-ppg.png" border="false":::

*Download a [Visio file][visio-download] of this architecture.*

> [!NOTE]
> Deploying this architecture requires appropriate licensing of SAP products and other non-Microsoft technologies.

This guide describes a common production system. This architecture is deployed with virtual machine (VM) sizes that you can change to accommodate the needs of your organization. To suit your business needs, you can reduce this configuration to a single VM.

In this guide, the network layout is greatly simplified to demonstrate architectural principles. It's not intended to describe a full enterprise network.

The architecture uses the following components. Some shared services are optional.

**Azure Virtual Network.** The [Virtual Network](/azure/virtual-network/virtual-networks-overview) service securely connects Azure resources to each other. In this architecture, a virtual network connects to an on-premises environment through a gateway that's deployed in the hub of a [hub-spoke topology](../../reference-architectures/hybrid-networking/hub-spoke.yml). The spoke is the virtual network that's used for the SAP applications and the database tiers.

**Virtual network peering.** This architecture uses multiple virtual networks that are [peered together](/azure/virtual-network/virtual-network-peering-overview). This topology offers network segmentation and isolation for services that are deployed on Azure. Peering connects networks transparently through the Microsoft backbone network and doesn't incur a performance penalty if implemented within a single region. Separate subnets are used for each tier application (SAP NetWeaver), database, and for shared services, such as the jump box and Windows Server Active Directory.

**VMs.** This architecture uses VMs that run Linux for the application tier and database tier, grouped in the following way:

- **Application tier.** This tier includes the Fiori front-end server pool, the SAP Web Dispatcher pool, the application server pool, and the SAP Central Services cluster. For high availability of Central Services on Azure running in Linux VMs, a highly available network file share service is required, such as [NFS file shares in Azure Files](/azure/virtual-machines/workloads/sap/high-availability-guide-suse-nfs-azure-files), [Azure NetApp Files](/azure/virtual-machines/workloads/sap/high-availability-guide-suse-netapp-files), clustered Network File System (NFS) servers, or [SIOS Protection Suite for Linux](https://us.sios.com/solutions/sap-high-availability). To set up a highly available file share for the Central Services cluster on Red Hat Enterprise Linux (RHEL), you can configure [GlusterFS](/azure/virtual-machines/workloads/sap/high-availability-guide-rhel-glusterfs) on Azure VMs that run RHEL. On SUSE Linux Enterprise Server (SLES) 15 SP1 and later versions or SLES for SAP Applications, you can use [Azure shared disks](/azure/virtual-machines/disks-shared#linux) on a Pacemaker cluster to achieve high availability.

- **SAP HANA.** The database tier uses two or more Linux VMs in a cluster to achieve high availability in a scale-up deployment. HANA system replication (HSR) is used to replicate contents between primary and secondary HANA systems. Linux clustering is used to detect system failures and facilitate automatic failover. A storage-based or cloud-based fencing mechanism must be used to ensure that the failed system is isolated or shut down to avoid the cluster split-brain condition. In HANA scale-out deployments, you can achieve database high availability by using one of the following options:

  - Configure HANA standby nodes by using Azure NetApp Files without the Linux clustering component.
  - Scale out without standby nodes by using Azure premium storage. Use Linux clustering for failover.

- **Jump box/bastion host.** A jump box, which is also called a bastion host, is a secure VM on the network that you use to connect to other VMs. It's typically deployed as part of shared services, such as domain controllers and backup services. The jump box is deployed on a VM to support SAP HANA Studio, SAPGUI, file transfer, and other functions that are commonly used for installation and administrative purposes. For remote desktop protocol (RDP) or secure shell (SSH) services, try [Azure Bastion](/azure/bastion/bastion-overview). If only RDP and SSH are used for administration, Azure Bastion is a great alternative. If you use other management tools, like SQL Server Management Studio or SAP Front End, use a traditional, self-deployed jump box.

**Private DNS service.** [Azure Private DNS](/azure/dns/private-dns-overview) provides a reliable and secure DNS service for your virtual network. Azure Private DNS manages and resolves domain names in the virtual network without the need to configure a custom DNS solution.

**Load balancers.** To distribute traffic to VMs in the SAP application tier subnet for high availability, we recommend that you use [Azure Standard Load Balancer](/azure/load-balancer/load-balancer-standard-availability-zones). It's important to note that Standard Load Balancer is secure by default, and no VMs that are behind Standard Load Balancer have outbound internet connectivity. To enable outbound internet in the VMs, you must update your [Standard Load Balancer configuration](/azure/virtual-machines/workloads/sap/high-availability-guide-standard-load-balancer-outbound-connections). For SAP web-based application high availability, use the built-in [SAP Web Dispatcher](https://help.sap.com/doc/saphelp_em900/9.0/en-US/48/8fe37933114e6fe10000000a421937/content.htm?no_cache=true), or another commercially available load balancer. Base your selection on:

- Your traffic type, such as HTTP or SAP GUI.
- The network services that you need, such as Secure Sockets Layer (SSL) termination.

Standard Load Balancer supports multiple front-end virtual IPs. This support is ideal for cluster implementations that include these components:

- Advanced Business Application Programming (ABAP) SAP Central Service (ASCS)
- Enqeue Replication Server (ERS)

These two components can share a load balancer to simplify the solution.

Standard Load Balancer also supports multi–security identifier (multi-SID) SAP clusters. In other words, multiple SAP systems on [SLES](/azure/virtual-machines/workloads/sap/high-availability-guide-suse-multi-sid) or [RHEL](/azure/virtual-machines/workloads/sap/high-availability-guide-rhel-multi-sid) can share a common high availability infrastructure to reduce costs. We recommend that you evaluate the cost savings and avoid placing too many systems in one cluster. Azure supports no more than five SIDs per cluster.

**Application gateway.** Azure Application Gateway is a web traffic load balancer that you can use to manage the traffic to your web applications. Traditional load balancers operate at the transport layer (OSI layer 4 - TCP and UDP). They route traffic based on the source IP address and port to a destination IP address and port. Application Gateway can make routing decisions based on additional attributes of an HTTP request, such as the URI path or host headers. This type of routing is known as application layer (OSI layer 7) load balancing. S/4HANA offers web application services through Fiori. You can load balance this Fiori front end, which consists of web apps, by using Application Gateway.

**Availability sets.** VMs for all pools and clusters (Web Dispatcher, SAP application servers, Central Services, and HANA) are grouped into separate [availability sets](/azure/virtual-machines/windows/tutorial-availability-sets). At least two VMs are provisioned per role. Availability sets increase the availability of applications and VMs. By managing host system faults and maintenance events, availability sets distribute role instances onto multiple hosts. An alternative is to use [availability zones](/azure/virtual-machines/workloads/sap/sap-ha-availability-zones) to improve workload availability, as described later in this article.

**Gateway.** A gateway connects distinct networks and extends your on-premises network to an Azure virtual network. [Azure ExpressRoute](../../reference-architectures/hybrid-networking/expressroute.yml) is the recommended Azure service for creating private connections that don't go over the public internet, but you can also use a
[site-to-site](/azure/expressroute/expressroute-howto-coexist-resource-manager) connection. To reduce latency, [ExpressRoute Global Reach](/azure/expressroute/expressroute-global-reach) and [ExpressRoute FastPath](/azure/expressroute/about-fastpath) are connectivity options that are discussed later in this article.

**Zone-redundant gateway.** You can deploy ExpressRoute or virtual private network (VPN) gateways across zones to guard against zone failures. This architecture uses [zone-redundant](/azure/vpn-gateway/about-zone-redundant-vnet-gateways) virtual network gateways for resiliency rather than a zonal deployment that's based on the same availability zone.

**Proximity placement group.** This logical group places a constraint on VMs that are deployed in an availability set or a virtual machine scale set. A [proximity placement group](/azure/virtual-machines/workloads/sap/sap-proximity-placement-scenarios) favors co-location, which places VMs in the same datacenter to minimize application latency.

> [!NOTE]
> The article about proximity placement groups, [Azure proximity placement groups for optimal network latency with SAP applications](/azure/virtual-machines/workloads/sap/sap-proximity-placement-scenarios), contains a recently updated configuration strategy. It's important to read that article, especially if you've deployed SAP systems in proximity placement groups in the past.

**Network security groups.** To restrict incoming, outgoing, and intra-subnet traffic in a virtual network, you can create [network security groups](/azure/virtual-network/security-overview).

**Application security groups.** To define fine-grained network security policies that are based on workloads and centered on applications, use [application security groups](/azure/virtual-network/security-overview#application-security-groups) instead of explicit IP addresses. You can group VMs by name and secure applications by filtering traffic from trusted segments of your network.

**Azure Storage.** Storage provides data persistence for a VM in the form of a virtual hard disk. We recommend [Azure managed disks](/azure/virtual-machines/windows/managed-disks-overview).

## Recommendations

This architecture describes a small, production-level deployment. Deployments vary based on business requirements, so consider these recommendations as a starting point.

### VMs

In application server pools and clusters, adjust the number of VMs based on your requirements. For detailed information about running SAP NetWeaver on VMs, see [Azure Virtual Machines planning and implementation guide](/azure/virtual-machines/workloads/sap/planning-guide). The guide also applies to SAP S/4HANA deployments.

For details about SAP support for Azure VM types and for throughput metrics (SAPS), see [SAP Note 1928533](https://launchpad.support.sap.com/#/notes/1928533). To access SAP notes, you need an SAP Service Marketplace account. For a list of certified Azure VMs for the HANA database, see [SAP Certified and Supported SAP HANA Hardware Directory](https://www.sap.com/dmc/exp/2014-09-02-hana-hardware/enEN/iaas.html#categories=Microsoft%20Azure).

### SAP Web Dispatcher

The Web Dispatcher component is used for load balancing SAP traffic among the SAP application servers. To achieve [high availability of SAP Web Dispatcher](https://help.sap.com/doc/saphelp_nw73ehp1/7.31.19/48/9a9a6b48c673e8e10000000a42189b/frameset.htm), Azure Load Balancer implements either a failover cluster or the parallel Web Dispatcher setup. For internet-facing communications, a stand-alone solution in the perimeter network is the recommended architecture to satisfy security concerns. [Embedded Web Dispatcher on ASCS](https://help.sap.com/viewer/00b4e4853ef3494da20ebcaceb181d5e/LATEST/en-US/2e708e2d42134b4baabdfeae953b24c5.html) is a special option. If you use this option, consider proper sizing because of the extra workload on ASCS.

### Fiori front-end server (FES)

This architecture addresses many requirements and assumes that the embedded Fiori FES model is used. All the technology components are installed on the S/4 system itself, meaning that each S/4 system has its own Fiori launchpad. The high availability setup for this deployment model is that of the S/4 system—no extra clustering or VMs are required. For that reason, the architecture diagram doesn't show the FES component.

For a description of the primary deployment options—either embedded or hub, depending on the scenarios—see [SAP Fiori deployment options and system landscape recommendations](https://www.sap.com/documents/2018/02/f0148939-f27c-0010-82c7-eda71af511fa.html). For simplicity and performance, the software releases between the Fiori technology components and the S/4 applications are tightly coupled. This setup makes a hub deployment that fits only a few, narrow use cases.

If you use the FES hub deployment, the FES is an add-on component to the classic SAP NetWeaver ABAP stack. Set up high availability the same way you protect a three-tier ABAP application stack that has clustered or multi-host capability: use a standby server database layer, a clustered ASCS layer with high availability NFS for shared storage, and at least two application servers. Traffic is load balanced via a pair of Web Dispatcher instances that can be either clustered or parallel. For internet-facing Fiori apps, we recommend an [FES hub deployment](https://blogs.sap.com/2017/12/15/considerations-and-recommendations-for-internet-facing-fiori-apps) in the perimeter network. Use [Azure Web Application Firewall on Application Gateway](/azure/application-gateway) as a critical component to deflect threats. Use [Azure AD with SAML](/azure/active-directory/saas-apps/sap-netweaver-tutorial) for user authentication and SSO for [SAP Fiori](/azure/active-directory/saas-apps/sap-fiori-tutorial).

:::image type="content" source="media/fiori.png" alt-text="Architecture diagram that shows the data flow between the internet and two virtual networks, one with SAP Fiori and one with SAP S/4HANA." lightbox="media/fiori.png" border="false":::

For some internet-facing inbound/outbound design examples, see [Inbound and outbound internet connections for SAP on Azure](./sap-internet-inbound-outbound.yml).

### Application servers pool

To manage logon groups for ABAP application servers, it's common to use the SMLG transaction to load balance logon users, to use SM61 for batch server groups, to use RZ12 for remote function call (RFC) groups, and so on. These transactions use the load-balancing capability that's in the Central Services message server to distribute incoming sessions or workloads among the pool of SAP application servers that handle SAP GUIs and RFC traffic.

### SAP Central Services cluster

You can deploy Central Services to a single VM when the Azure single-instance VM availability service-level agreement (SLA) meets your requirement. However, the VM becomes a potential single point of failure (SPOF) for the SAP environment. For a highly available Central Services deployment, use either [NFS over Azure Files](/azure/virtual-machines/workloads/sap/high-availability-guide-suse-nfs-azure-files) or the [Azure NetApp Files service and a Central Services cluster](/azure/virtual-machines/workloads/sap/high-availability-guide-suse-netapp-files).

Another option is to use [Azure shared disks](/azure/virtual-machines/disks-shared) to achieve high availability. On SLES 15 SP1 and later or SLES for SAP Applications, you can set up a Pacemaker cluster by using [Azure shared disks for Linux](/azure/virtual-machines/disks-shared#linux).

Alternately, you can use an NFS file share for the [Linux cluster shared storage](/azure/virtual-machines/workloads/sap/high-availability-guide-suse-netapp-files).

On an Azure deployment, the application servers connect to the highly available Central Services through the virtual host names of the Central Services or ERS services. These host names are assigned to the cluster front-end IP configuration of the load balancer. Load Balancer supports multiple frontend IPs, so both the Central Services and ERS virtual IPs (VIPs) can be configured to one load balancer.

Linux cluster support for [ASCS multi-SID installation](/azure/virtual-machines/workloads/sap/high-availability-guide-suse-multi-sid) on Azure is now generally available. Sharing an availability cluster among multiple SAP systems simplifies the SAP landscape.

### Availability sets

Availability sets distribute servers to different physical infrastructures and update groups to improve service availability. Put VMs that perform the same role into the same availability set. Such a setup helps guard against downtime that's caused by Azure infrastructure maintenance. It also helps to meet [SLAs](https://azure.microsoft.com/support/legal/sla/virtual-machines). To meet a higher SLA, you need to have two or more VMs per availability set.

All VMs in a set must perform the same role. Don't mix servers of different roles in the same availability set. For example, don't place an ASCS node in the same availability set as application servers.

You can deploy Azure availability sets within [Azure availability zones](/azure/virtual-machines/workloads/sap/sap-ha-availability-zones) when you use a [proximity placement group](/azure/virtual-machines/linux/co-location).

### Networking

This architecture uses a hub-spoke topology, where the hub virtual network acts as a central point of connectivity to an on-premises network. The spokes are virtual networks that peer with the hub. You can use the spokes to isolate workloads. Traffic flows between the on-premises datacenter and the hub through a gateway connection.

### Network interface cards (NICs)

Traditional on-premises SAP deployments implement multiple NICs per machine to segregate administrative traffic from business traffic. On Azure, the virtual network is a software-defined network that sends all traffic through the same network fabric. Therefore, the use of multiple NICs is unnecessary for performance considerations. However, if your organization needs to segregate traffic, you can deploy multiple NICs per VM, connect each NIC to a different subnet, and then use network security groups to enforce different access control policies.

Azure NICs support multiple IPs. This support aligns with the practice that SAP recommends of using virtual host names for installations, as outlined in [SAP note
962955](https://launchpad.support.sap.com/#/notes/962955). To access SAP notes, you need an SAP Service Marketplace account.

### Subnets and network security groups

This architecture divides the virtual network address space into subnets. You can associate each subnet with a network security group that defines the access policies for the subnet. Place application servers on a separate subnet. By doing so, you can secure them more easily by managing the subnet security policies rather than the individual servers.

When you associate a network security group with a subnet, the network security group applies to all the servers within the subnet and offers fine-grained control over the servers. Set up network security groups by using the [Azure portal](/azure/virtual-network/tutorial-filter-network-traffic), [PowerShell](/azure/virtual-network/tutorial-filter-network-traffic-powershell), or the [Azure CLI](/azure/virtual-network/tutorial-filter-network-traffic-cli).

### ExpressRoute Global Reach

If your network environment includes two or more ExpressRoute circuits, [ExpressRoute Global Reach](/azure/expressroute/expressroute-global-reach) can help you reduce network hops and lower latency. This technology is a Border Gateway Protocol (BGP) route peering that's set up between two or more ExpressRoute circuits to bridge two ExpressRoute routing domains. Global Reach lowers latency when network traffic traverses more than one ExpressRoute circuit. It's currently available only for private peering on ExpressRoute circuits.

Currently there are no network access control lists or other attributes that can be changed in Global Reach. So all routes learned by a given ExpressRoute circuit (from on-premises and Azure) are advertised across the circuit peering to the other ExpressRoute circuit. We recommend that you establish network traffic filtering on-premises to restrict access to resources.

### ExpressRoute FastPath

[FastPath](/azure/expressroute/about-fastpath) implements Microsoft Edge exchanges at the entry point of the Azure network. FastPath reduces network hops for most data packets. As a result, FastPath lowers network latency, improves application performance, and is the default configuration for new ExpressRoute connections to Azure.

For existing ExpressRoute circuits, contact Azure support to activate FastPath.

FastPath doesn't support virtual network peering. If other virtual networks are peered with one that's connected to ExpressRoute, the network traffic from your on-premises network to the other spoke virtual networks gets sent to the virtual network gateway. The workaround is to connect all virtual networks to the ExpressRoute circuit directly.

### Load balancers

[SAP Web Dispatcher](https://help.sap.com/viewer/683d6a1797a34730a6e005d1e8de6f22/202110.001/en-US/488fe37933114e6fe10000000a421937.html?q=SAP%20Web%20Dispatcher) handles load balancing of HTTP(S) traffic to a pool of SAP application servers. This software load balancer offers application layer services (referred to as layer 7 in the ISO networking model) that are capable of SSL termination and other offloading functions.

[Load Balancer](https://azure.microsoft.com/blog/azure-load-balancer-new-distribution-mode) is a network transmission layer service (layer 4) that balances traffic by using a five-tuple hash from data streams. The hash is based on source IP, source port, destination IP, destination port, and protocol type. Load Balancer is used in cluster setups to direct traffic to the primary service instance or the healthy node if there's a fault. We recommend that you use [Azure Standard Load Balancer](/azure/load-balancer/load-balancer-standard-overview) for all SAP scenarios. It's important to note that Standard Load Balancer is secure by default, and no VMs behind Standard Load Balancer have outbound internet connectivity. To enable outbound internet in the VMs, you must adjust your [Standard Load Balancer](/azure/virtual-machines/workloads/sap/high-availability-guide-standard-load-balancer-outbound-connections) configuration.

For traffic from SAP GUI clients that connect to an SAP server via the DIAG protocol or RFC, the Central Services message server balances the load through SAP application server [logon groups](https://wiki.scn.sap.com/wiki/display/SI/ABAP+Logon+Group+based+Load+Balancing). No extra load balancer is needed.

### Storage

Some customers use standard storage for their application servers. Because standard managed disks aren't supported, as stated in SAP note 1928533, we recommend using premium [Azure managed disks](/azure/storage/storage-managed-disks-overview) or [Azure NetApp Files](/azure/azure-netapp-files/azure-netapp-files-introduction) in all cases. A recent update to [SAP note 2015553](https://launchpad.support.sap.com/#/notes/2015553) excludes the use of standard HDD storage and standard SSD storage for a few specific use cases.

Because application servers don't host any business data, you can also use the smaller P4 and P6 premium disks to help manage costs. To understand how the storage type affects the VM availability SLA, see [SLA for Virtual Machines](https://azure.microsoft.com/support/legal/sla/virtual-machines/v1_9). For high-availability scenarios, [Azure shared disk](/azure/virtual-machines/disks-shared) features are available on Azure Premium SSD and Azure Ultra Disk Storage. For more information, see [Azure managed disks](/azure/storage/storage-managed-disks-overview).

You can use Azure shared disks with Windows Server, SLES 15 SP 1 and later, or SLES for SAP. When you use an Azure shared disk in Linux clusters, the Azure shared disk serves as a STONITH block device (SBD). It offers a quorum vote in a cluster network partitioning situation. This shared disk doesn't have a file system and doesn't support simultaneous writes from multiple cluster member VMs.

Azure NetApp Files has built-in file sharing functionalities for NFS and SMB.

For NFS share scenarios, [Azure NetApp Files](/azure/virtual-machines/workloads/sap/hana-vm-operations-netapp) provides availability for NFS shares that can be used for `/hana/shared`, `/hana/data`, and `/hana/log` volumes. For the availability guarantee, see [SLA for Azure NetApp Files](https://azure.microsoft.com/support/legal/sla/netapp/v1_1). If you use Azure NetApp Files–based NFS shares for the `/hana/data` and `/hana/log` volumes, you need to use the NFS v4.1 protocol. For the `/hana/shared` volume, the NFS v3 protocol is supported.

For the backup data store, we recommend that you use Azure [cool and archive access tiers](/azure/storage/blobs/access-tiers-overview). These storage tiers are cost-effective ways to store long-lived data that's infrequently accessed. You can also consider using [Azure NetApp Files standard tier](/azure/azure-netapp-files/azure-netapp-files-service-levels#supported-service-levels) as a backup target or [Azure NetApp Files backup option](/azure/azure-netapp-files/backup-introduction). For a managed disk, the recommended backup data tier is the Azure cool or archive access tier.

[Ultra Disk Storage](/azure/virtual-machines/linux/disks-enable-ultra-ssd) and Azure NetApp Files [ultra performance tier](/azure/azure-netapp-files/azure-netapp-files-service-levels) greatly reduce disk latency and benefit performance-critical applications and the SAP database servers.

## Performance considerations

SAP application servers communicate constantly with the database servers. For performance-critical applications that run on any database platform, including SAP HANA, enable [Write Accelerator](/azure/virtual-machines/windows/how-to-enable-write-accelerator) for the log volume to improve log write latency. Write Accelerator is available for M-series VMs.

To optimize inter-server communications, use [Accelerated Networking](https://azure.microsoft.com/blog/linux-and-windows-networking-performance-enhancements-accelerated-networking). This option is available only for supported VMs, including D/DSv2, D/DSv3, E/ESv3, F/FS, FSv2, and Ms/Mms.

For details about SAP HANA performance requirements, see [SAP note 1943937 - Hardware Configuration Check Tool](https://launchpad.support.sap.com/#/notes/1943937). To access SAP notes, you need an SAP Service Marketplace account.

To achieve high IOPS and disk bandwidth throughput, the common practices in storage volume [performance optimization](/azure/virtual-machines/linux/premium-storage-performance) apply to your Storage layout. For example, if you combine multiple disks to create a striped disk volume, you can improve IO performance. By enabling the read cache on storage content that changes infrequently, you can enhance the speed of data retrieval. For recommendations about storage configurations for various VM sizes when you run SAP HANA, see [SAP HANA Azure virtual machine storage configurations](/azure/virtual-machines/workloads/sap/hana-vm-operations-storage).

[Ultra Disk Storage](/azure/virtual-machines/linux/disks-enable-ultra-ssd) is a new generation of storage that meets intensive IOPS and the transfer bandwidth demands of applications such as SAP HANA. You can dynamically change the performance of ultra disks and independently configure metrics like IOPS and MB/s without rebooting your VM. When Ultra Disk Storage is available, we recommend Ultra Disk Storage instead of Write Accelerator.

Some SAP applications require frequent communication with the database. Network latency between the application and database layers, due to distance, can adversely impact application performance. Azure [proximity placement groups](/azure/virtual-machines/workloads/sap/sap-proximity-placement-scenarios) set a placement constraint for VMs that are deployed in availability sets. Within the logical construct of a group, co-location and performance are favored over scalability, availability, and cost. Proximity placement groups can greatly improve the user experience for most SAP applications. For scripts and utilities that are available on GitHub for proximity placement groups, see [Azure Proximity Placement Groups](https://github.com/msftphleiten/proximity-placement-groups).

We recommend that you don't place a network virtual appliance (NVA) between the application and the database layers of any SAP application stack. The NVA requires a significant amount of time to process data packets. As a result, it unacceptably slows application performance.

We also recommend that you consider performance when you deploy resources with
[availability zones](/azure/virtual-machines/workloads/sap/sap-ha-availability-zones), which can enhance service availability, as described later in this article. Consider creating a clear network latency profile between all zones of a target region. This approach helps you decide on the resource placement for minimum latency between zones. To create this profile, run a test by deploying small VMs in each zone. Recommended tools for the test include
[PsPing](/sysinternals/downloads/psping) and
[Iperf](https://sourceforge.net/projects/iperf). After testing, remove these VMs. For a public domain network latency test tool that you can use instead, see [Availability Zone Latency Test](https://github.com/Azure/SAP-on-Azure-Scripts-and-Utilities/tree/master/AvZone-Latency-Test).

Azure NetApp Files has unique performance features that make real-time tuning possible that meets the needs of the most demanding SAP environments. For performance considerations to keep in mind when you use Azure NetApp Files, see [Sizing for HANA database on Azure NetApp Files](/azure/virtual-machines/workloads/sap/sap-hana-scale-out-standby-netapp-files-suse#sizing-for-hana-database-on-azure-netapp-files).

## Scalability considerations

At the SAP application layer, Azure offers a wide range of VM sizes for scaling up and scaling out. For an inclusive list, see "SAP Applications on Azure: Supported Products and Azure VM types" in [SAP Note 1928533](https://launchpad.support.sap.com/#/notes/1928533). To access SAP notes, you need an SAP Service Marketplace account. More VM types are continually being certified, so you can scale up or down in the same cloud deployment.

At the database layer, this architecture runs SAP HANA S/4 applications on Azure VMs that can scale up to 12 terabytes (TB) in one instance. If your workload exceeds the maximum VM size, you can use [Azure Large Instances](/azure/virtual-machines/workloads/sap/hana-overview-architecture) for SAP HANA, an option that far exceeds the 12-TB RAM capacity. Revision 4 instances of these physical servers are in a Microsoft Azure datacenter. They provide up to 24 TB of memory capacity for a single instance. A multi-node configuration is also possible with a total memory capacity of up to 24 TB for online transaction processing (OLTP) applications and 60 TB for online analytical processing (OLAP) applications.

## Availability considerations

Resource redundancy is the general theme in highly available infrastructure solutions. For single-instance VM availability SLAs for various storage types, see [SLA for Virtual Machines](https://azure.microsoft.com/support/legal/sla/virtual-machines/v1_9). When you deploy redundant resources in an availability set or across availability zones, the service availability is elevated.

In this distributed installation of the SAP application, the base installation is replicated to achieve high availability. For each layer of the architecture, the high availability design varies.

### Web Dispatcher in the application servers tier

You can achieve high availability by using redundant Web Dispatcher instances. For more information, see [SAP Web Dispatcher](https://help.sap.com/viewer/683d6a1797a34730a6e005d1e8de6f22/202110.001/en-US/488fe37933114e6fe10000000a421937.html?q=SAP%20Web%20Dispatcher) in the SAP documentation. The availability level depends on the size of the application that's behind Web Dispatcher. In small deployments with few scalability concerns, you can co-locate Web Dispatcher with the ASCS VMs. This way, you save on independent OS maintenance and gain high availability at the same time.

### Central Services in the application servers tier

For high availability of Central Services on Azure Linux VMs, use the appropriate high availability extension for the selected Linux distribution. It's customary to place the shared file systems on highly available NFS storage by using SUSE DRBD or Red Hat GlusterFS. To provide a highly available NFS and eliminate the need for an NFS cluster, you can use other cost-effective or robust solutions like [NFS over Azure Files](/azure/virtual-machines/workloads/sap/high-availability-guide-suse-nfs-azure-files) or [Azure NetApp Files](/azure/virtual-machines/workloads/sap/high-availability-guide-suse-netapp-files) instead. As a side note, Azure NetApp Files shares can host the SAP HANA data and log files. This setup enables the [HANA scale-out](/azure/virtual-machines/workloads/sap/sap-hana-scale-out-standby-netapp-files-suse) deployment model with standby nodes, while NFS over Azure Files is good for highly available non-database file sharing.

NFS over Azure Files now supports the highly available file shares for both [SLES](/azure/virtual-machines/workloads/sap/high-availability-guide-suse-nfs-azure-files) and [RHEL](/azure/virtual-machines/workloads/sap/high-availability-guide-rhel-nfs-azure-files). This solution works well for highly available file shares like those of `/sapmnt`, `/saptrans` in SAP installations.  

Azure NetApp Files supports high availability of [ASCS on SLES](/azure/virtual-machines/workloads/sap/high-availability-guide-suse-netapp-files). For detailed information about ASCS on RHEL high availability, see [SIOS Protection Suite for Linux](https://us.sios.com/blog/how-to-install-a-sios-protection-suite-for-linux-license-key/).

The improved Azure Fence Agent is available for both
[SUSE](/azure/virtual-machines/workloads/sap/high-availability-guide-suse-pacemaker) and [Red Hat](/azure/virtual-machines/workloads/sap/high-availability-guide-rhel-pacemaker) and provides significantly faster service failover than the previous version of the agent.

Another option is to use [Azure shared disks](/azure/virtual-machines/disks-shared) to achieve high availability. On SLES 15 SP 1 and later or SLES for SAP, you can set up a Pacemaker cluster by using [Azure shared disks](/azure/virtual-machines/disks-shared#linux) to achieve high availability.

On Azure Standard Load Balancer, you can enable the [high availability port](/azure/load-balancer/load-balancer-ha-ports-overview) and avoid the need to configure load balancing rules for many SAP ports. In general, if you enable the direct server return (DSR) feature when you set up a load balancer, server responses to client inquiries can bypass the load balancer. This feature is also known as Floating IP. The load balancer can be on-premises or on Azure. This direct connection keeps the load balancer from becoming the bottleneck in the path of data transmission. For the ASCS and HANA DB clusters, we recommend that you enable DSR. If VMs in the back-end pool require public outbound connectivity, more [configuration](/azure/virtual-machines/workloads/sap/high-availability-guide-standard-load-balancer-outbound-connections) is required.

For traffic from SAP GUI clients that connect to an SAP server via DIAG protocol or RFC, the Central Services message server balances the load by using SAP application server [logon groups](https://wiki.scn.sap.com/wiki/display/SI/ABAP+Logon+Group+based+Load+Balancing). No extra load balancer is needed.

### Application servers in the application servers tier

You can achieve high availability by load balancing traffic within a pool of application servers.

### Database tier

The architecture in this guide depicts a highly available SAP HANA database system that consists of two Azure VMs. The native system replication feature of the database tier provides either manual or automatic failover between replicated nodes:

- For manual failover, deploy more than one HANA instance and use HSR.
- For automatic failover, use both HSR and Linux high availability extension (HAE) for your Linux distribution. Linux HAE provides the cluster services to the HANA resources, detecting failure events and orchestrating the failover of errant services to the healthy node.
- As with the application servers layer, the commonly deployed HANA high availability solution for SLES is Pacemaker. For RHEL, it's SIOS LifeKeeper.

### Deploy VMs across availability zones

[Availability zones](/azure/virtual-machines/workloads/sap/sap-ha-availability-zones) can enhance service availability. Zones refer to physically separated locations within a specific Azure region. They improve workload availability and protect application services and VMs against datacenter outages. VMs in a single zone are treated as if they were in a single update or fault domain. When zonal deployment is selected, VMs in the same zone are distributed to fault and upgrade domains on a best-effort basis.

In [Azure regions](https://azure.microsoft.com/global-infrastructure/regions) that support this feature, at least three zones are available. However, the maximum distance between datacenters in these zones isn't guaranteed. To deploy a multi-tier SAP system across zones, you must know the network latency within a zone and across targeted zones, and how sensitive your deployed applications are to network latency.

Take these [considerations](/azure/virtual-machines/workloads/sap/sap-ha-availability-zones) into account when you decide to deploy resources across availability zones:

- Latency between VMs in one zone
- Latency between VMs across chosen zones
- Availability of the same Azure services (VM types) in the chosen zones

> [!NOTE]
> We don't recommend availability zones for disaster recovery. A disaster recovery site should be at least 100 miles from the primary site, in case of a natural disaster. There is no certainty of the distance between the datacenters.

**Active/passive deployment example**

In this example deployment, the
[active/passive](/azure/virtual-machines/workloads/sap/sap-ha-availability-zones#activepassive-deployment) status refers to the application service state within the zones. In the application layer, all four active application servers of the SAP system are in zone 1. Another set of four passive application servers is built in zone 2 but is shut down. They're activated only when they're needed.

The two-node clusters for Central Services and the database are stretched across two zones. If zone 1 fails, Central Services and database services run in zone 2. The passive application servers in zone 2 get activated. With all components of this SAP system co-located in the same zone, network latency is minimized.

**Active/active deployment example**

In an [active/active](/azure/virtual-machines/workloads/sap/sap-ha-availability-zones#activeactive-deployment) deployment, two sets of application servers are built across two zones. In each zone, two application servers in each set are inactive, or shut down. As a result, there are active application servers in both zones in normal operations.

The ASCS and database services run in zone 1. The application servers in zone 2 might have longer network latency when they connect to the ASCS and database services due to the physical distance between zones.

If zone 1 goes offline, the ASCS and database services fail over to zone 2. The dormant application servers can be brought online to provide full capacity for application processing.

## DR considerations

Every tier in the SAP application stack uses a different approach to provide DR protection.

### Application servers tier

SAP application servers don't contain business data. On Azure, a simple DR strategy is to create SAP application servers in the secondary region and then shut them down. When there are configuration changes or kernel updates on the primary application server, the same changes must be applied to the VMs in the secondary region. For example, you need to copy the SAP kernel executables to the DR VMs.

You can also use Azure Site Recovery to set up DR for a [multi-tier SAP NetWeaver application](/azure/site-recovery/site-recovery-sap) deployment.

### Central Services

Like the application servers, this component of the SAP application stack also doesn't persist business data. You can build a VM in the DR region to run the Central Services role.

The ASCS global host files, namely the `/sapmnt` share, are commonly served by either NFS over Azure Files or [Azure NetApp Files](/azure/azure-netapp-files/azure-netapp-files-introduction). To protect this content when you use NFS over Azure Files, use a custom replication script, such as rsync. This script runs on a scheduled basis by copying content to another file share in the DR region. When you use Azure NetApp Files, use its native cross-region replication feature to replicate content for the `/sapmnt` share of the DR SAP system.

Site Recovery supports the replication of STONITH devices that are created with iSCSI targets.

To replicate the two operating system drives of the Central Services servers to the DR region, you can use Site Recovery.

For step-by-step guidance, see [Building a Disaster Recovery Solution for SAP using Azure Site Recovery](https://gallery.technet.microsoft.com/Building-a-Disaster-fc7406b3).

### Database tier

Use HSR for HANA-supported replication. In addition to a local, two-node high availability setup, HSR supports multi-tier replication where a third node in a separate Azure region acts as a foreign entity, not part of the cluster. That third node registers with the secondary replica of the clustered HSR pair as its replication target. This setup forms a replication daisy chain.

The failover to the DR node is a manual process. With HANA 2.0 SPS 03 and later, it's possible to configure [multi-target system replication](https://help.sap.com/viewer/6b94445c94ae495c83a19646e7c3fd56/2.0.03/en-US/ba457510958241889a459e606bbcf3d3.html), which supports additional replicas by replicating the primary node in the DR region asynchronously. In addition, if you use Azure NetApp Files for either the Central Services or the HANA database layer, use rsync or a content replication tool of choice.

### DR for shared services

Many IT services are shared by all your deployed cloud assets, such as administrative jump boxes, cloud-based directory services, backup services, and monitoring services. Replicate your shared services into the DR region by using whatever means the services provide.

### Automated DR with Site Recovery

To use Site Recovery to automatically build a fully replicated production site of your original configuration, you must run customized [deployment scripts](/azure/site-recovery/site-recovery-runbook-automation). For example, Site Recovery first deploys the VMs in availability sets. Then it runs your custom scripts to attach the existing (pre-built) load balancer, which already has the back-end pool defined, to the NIC of the failover VMs. For an example on GitHub of a custom Site Recovery automation runbooks script, see [Azure Site Recovery Runbooks](https://github.com/Azure/azure-quickstart-templates/tree/master/demos/asr-automation-recovery).

> [!NOTE]
> If there's a regional disaster that causes a mass failover event for many Azure customers in one region, the target region's [resource capacity](/azure/site-recovery/azure-to-azure-common-questions#capacity) isn't guaranteed. Like all Azure services, Site Recovery continues to add features and capabilities. For the latest information about Azure-to-Azure replication, see the [support matrix](/azure/site-recovery/azure-to-azure-support-matrix).

## Cost considerations

Use the [Azure pricing calculator][azure-pricing-calculator] to estimate costs.

For more information, see the cost section in [Microsoft Azure Well-Architected Framework][aaf-cost].

### VMs

This architecture uses VMs that run Linux for the application tier and database tier. The SAP NetWeaver tier uses Windows VMs to run SAP services and applications. The database tier runs AnyDB as the database, such as Microsoft SQL Server, Oracle, or IBM DB2. VMs are also used as jump boxes for management.

There are several payment options for VMs in general:

- For workloads with no predictable time of completion or resource consumption, consider the pay-as-you-go option.

- Consider using [Azure Reservations](/azure/cost-management-billing/reservations/save-compute-costs-reservations) if you can commit to using a VM over a one-year or three-year term. VM reservations can significantly reduce costs. You might pay as little as 72 percent of the cost of a pay-as-you-go service.

- Use [Azure spot VMs][az-spot-vms] to run workloads that can be interrupted and don't require completion within a predetermined time-frame or SLA. Azure deploys spot VMs when there's available capacity and evicts them when it needs the capacity back. Costs that are associated with spot VMs are lower than for other VMs. Consider spot VMs for these workloads:

  - High-performance computing scenarios, batch processing jobs, or visual rendering applications
  - Test environments, including continuous integration and continuous delivery workloads
  - Large-scale stateless applications

For more information, see [Linux Virtual Machines Pricing][linux-vms-pricing].

### VMs and availability sets

For all pools and clusters (Web Dispatcher, SAP application servers, Central Services, and HANA) the VMs are grouped into separate availability sets. There's no cost for an availability set. You only pay for each VM instance that you create.

### Load Balancer

In this scenario, Azure load balancers are used to distribute traffic to VMs in the application tier subnet.

You're charged only for the number of configured load-balancing and outbound rules. Inbound network address translation (NAT) rules are free. There's no hourly charge for Standard Load Balancer when no rules are configured.

### ExpressRoute

In this architecture, ExpressRoute is the networking service that's used for creating private connections between an on-premises network and Azure virtual networks.

All inbound data transfer is free. All outbound data transfer is charged based on a pre-determined rate. For more information, see [Azure ExpressRoute pricing][expressroute-pricing].

## Management and operations considerations

To help keep your system running in production, consider the following points.

### Backup

You can back up SAP HANA data in many ways. After you migrate to Azure, continue to use any existing backup solutions that you already have. Azure provides two native approaches to backup. You can back up [SAP HANA on VMs or use Azure Backup at the file level](/azure/virtual-machines/workloads/sap/sap-hana-backup-guide). Azure Backup is [BackInt certified](https://www.sap.com/dmc/exp/2013_09_adpd/enEN/#/solutions?id=s:e062231e-9fb7-4ea8-b7d2-e6fe448c592d) by SAP. For more information, see [Azure Backup FAQ](/azure/backup/backup-azure-backup-faq).

> [!NOTE]
> Currently only HANA single-container deployments support Azure storage snapshots.

### Identity management

Use a centralized identity management system to control access to resources at all levels:

- Provide access to Azure resources through [Azure role-based access control (Azure RBAC)](/azure/role-based-access-control/overview).

- Grant access to Azure VMs through Lightweight Directory Access Protocol (LDAP), Azure Active Directory (Azure AD), Kerberos, or another system.

- Support access within the apps themselves through the services that SAP provides, or use [OAuth 2.0 and Azure AD](/azure/active-directory/develop/active-directory-protocols-oauth-code).

### Monitoring

To maximize the availability and performance of applications and services, use [Azure Monitor](/azure/azure-monitor/overview), a comprehensive solution for collecting, analyzing, and acting on telemetry from your cloud and on-premises environments. Monitor shows how applications are performing and proactively identifies issues that affect them and the resources that they depend on.

To provide SAP-based monitoring of resources and service performance of the SAP infrastructure, use the [Azure SAP enhanced monitoring](/azure/virtual-machines/workloads/sap/deployment-guide#d98edcd3-f2a1-49f7-b26a-07448ceb60ca) extension. This extension feeds Azure monitoring statistics into the SAP application for operating system monitoring and DBA Cockpit functions. SAP enhanced monitoring is a mandatory prerequisite to run SAP on Azure. For details, see "SAP on Linux with Azure: Enhanced Monitoring" in [SAP Note 2191498](https://launchpad.support.sap.com/#/notes/2191498). To access SAP notes, you need an SAP Service Marketplace account.

## Security considerations

SAP has its own Users Management Engine (UME) to control role-based access and authorization within the SAP application and databases. For details, see [SAP HANA Security: An Overview](https://www.tutorialspoint.com/sap_hana/sap_hana_security_overview.htm).

To improve network security, consider using a [perimeter network](../../reference-architectures/dmz/secure-vnet-dmz.yml) that uses an NVA to create a firewall in front of the subnet for Web Dispatcher and the Fiori front-end server pools. The cost of data transfer is a reason to place active front-end servers that run Fiori apps in the same virtual network as the S/4 systems. The alternative is to place them in the perimeter network and connect them to S/4 through a virtual network peering.

For infrastructure security, data is encrypted in transit and at rest. The "Security considerations" section of [SAP NetWeaver on Azure Virtual Machines–Planning and Implementation Guide](/azure/virtual-machines/workloads/sap/planning-guide) contains information on network security that applies to S/4HANA. That guide also specifies the network ports to open on the firewalls to allow application communication.

To encrypt Linux VM disks, you have various choices, as described in [Disk encryption overview](/azure/virtual-machines/disk-encryption-overview). For SAP HANA data-at-rest encryption, we recommend that you use the SAP HANA native encryption technology. For support of Azure disk encryption on specific Linux distributions, versions, and images, see [Azure disk encryption for Linux VMs](/azure/virtual-machines/linux/disk-encryption-overview).

For SAP HANA data-at-rest encryption, we recommend that you use the SAP HANA native encryption technology.

> [!NOTE]
> Don't use the HANA data-at-rest encryption and Azure disk encryption on the same storage volume. For HANA, use only HANA data encryption. Also, the use of customer managed keys might affect I/O throughput.

## Communities

Communities can answer questions and help you set up a successful deployment. Consider these resources:

- [Running SAP Applications on the Microsoft Platform Blog](/archive/blogs/saponsqlserver/sap-on-azure-general-update-for-customers-partners-april-2017)
- [Azure Community Support](https://azure.microsoft.com/support/forums)
- [SAP Community](https://www.sap.com/community.html)
- [Stack Overflow SAP](http://stackoverflow.com/tags/sap/info)

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributor.*

Principal author:

- [Ben Trinh](https://www.linkedin.com/in/bentrinh) | Principal Architect

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

For more information and for examples of SAP workloads that use some of the same technologies as this architecture, see these articles:

- [Deploy SAP S/4HANA or BW/4HANA on Azure](/azure/virtual-machines/workloads/sap/cal-s4h)
- [Azure Virtual Machines planning and implementation for SAP NetWeaver](/azure/virtual-machines/workloads/sap/planning-guide)
- [Use Azure to host and run SAP workload scenarios](/azure/virtual-machines/workloads/sap/get-started)

## Related resources

- [Run SAP production workloads using an Oracle Database on Azure](../../example-scenario/apps/sap-production.yml)
- [Development and test environments for SAP workloads on Azure](../../example-scenario/apps/sap-dev-test.yml)

<!-- links -->

[aaf-cost]: /azure/architecture/framework/cost/overview
[azure-pricing-calculator]: https://azure.microsoft.com/pricing/calculator
[linux-vms-pricing]: https://azure.microsoft.com/pricing/details/virtual-machines/linux
[expressroute-pricing]: https://azure.microsoft.com/pricing/details/expressroute
[visio-download]: https://arch-center.azureedge.net/s4-avset-afs-ppg.vsdx
[az-spot-vms]: /azure/virtual-machines/windows/spot-vms

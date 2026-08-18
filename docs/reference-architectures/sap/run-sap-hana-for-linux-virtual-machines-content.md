This reference architecture shows a set of proven practices for running SAP HANA in a highly available, scale-up environment that supports disaster recovery on Azure. This implementation focuses on the database layer only.

## Architecture

This reference architecture describes a common production system. You can choose the virtual machine (VM) sizes to accommodate your organization's needs. You can also reduce this configuration to one VM, depending on business requirements.

The following diagram shows a reference architecture for SAP HANA on Azure:

:::image type="complex" source="./images/sap-hana-architecture.svg" border="false" lightbox="./images/sap-hana-architecture.svg" alt-text="Diagram that shows a regional SAP HANA deployment architecture on Azure.":::
    The diagram shows the primary region deployment for SAP HANA on Azure. There's an on-premises network on the left and an Azure region on the right. In the primary region, the architecture is split into two virtual networks: a hub virtual network and a spoke virtual network. The hub virtual network contains two subnets: a gateway subnet and a shared services subnet. The gateway subnet contains a zone-redundant gateway, labeled step 1. An on-premises gateway connects to this gateway via ExpressRoute. The shared services subnet contains Azure Bastion. A bidirectional arrow labeled virtual network peering connects the hub virtual network to the spoke virtual network. Inside the spoke virtual network is the database layer subnet. On the left side of this subnet, labeled step 2, is a load balancer that receives traffic from the hub through virtual network peering. To the right of the load balancer are two HANA VMs. These VMs are labeled step 3. An arrow between these two VMs is labeled HANA system replication. To the right of the HANA VMs, labeled step 4, are three SBD VMs. These VMs are optional.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/sap-hana-architecture.vsdx) that contains the diagrams in this article.*

> [!NOTE]
> To deploy this reference architecture, you need the appropriate licensing of SAP products and other non-Microsoft technologies.

### Workflow

This reference architecture describes a typical SAP HANA database running in Azure, in a highly available deployment to maximize system availability. You can customize the architecture and its components based on business requirements, such as recovery time objective (RTO), recovery point objective (RPO), uptime expectations, and system role. You can also use only one VM. The network layout is simplified to demonstrate the architectural principles of this type of SAP environment and isn't intended to describe a full enterprise network.

The following workflow corresponds to the previous diagram:

1. Clients connect from on-premises or peered Azure networks through Azure ExpressRoute into the SAP HANA spoke virtual network.
1. An internal Azure load balancer provides the virtual IP endpoint for the database and directs client traffic to the active SAP HANA node.
1. SAP HANA system replication keeps the secondary node synchronized with the primary node. If you use an active/read-enabled configuration, a separate load balancer front end can direct read traffic to the secondary node.
1. Pacemaker monitors node health and uses the selected fencing mechanism to isolate failed nodes. During a failover, the secondary node is promoted and the load balancer redirects client connections to the new primary node.

#### Networking

**Virtual networks.** The [Azure Virtual Network](/azure/virtual-network/virtual-networks-overview) service connects Azure resources to each other with enhanced security. In this architecture, the virtual network connects to an on-premises environment via an ExpressRoute gateway deployed in the hub of a [hub-spoke topology](../../networking/architecture/hub-spoke.yml). The SAP HANA database is contained in its own spoke virtual network. The spoke virtual network contains one subnet for the database VMs.

If applications connecting to SAP HANA are running on VMs, place the application VMs in the same virtual network but within a dedicated application subnet. Alternatively, if the SAP HANA connection isn't the primary database, you can place the application VMs in other virtual networks. Placing the VMs in subnets organized by workload makes it easier to enable network security groups to set security rules applicable to SAP HANA VMs only.

**Zone-redundant gateway.** A gateway connects distinct networks, extending your on-premises network to the Azure virtual network. We recommend that you use ExpressRoute to create private connections that don't go over the public internet, but you can also use a site-to-site connection. Use zone-redundant ExpressRoute or VPN gateways to guard against zone failures. See [Types of availability zone support](/azure/reliability/availability-zones-overview?tabs=azure-cli#types-of-availability-zone-support) for information about the differences between a zonal deployment and a zone-redundant deployment.

**Network security groups.**  To restrict incoming and outgoing network traffic of the virtual network, create [network security groups](/azure/virtual-network/tutorial-filter-network-traffic), which you assign to specific subnets. Database and application subnets are secured with workload-specific network security groups.

**Application security groups.** To define fine-grained network security policies inside your network security groups based on workloads that are centered on applications, use [application security groups](/azure/virtual-network/application-security-groups) instead of explicit IP addresses. Application security groups let you group network interfaces of VMs by name and help you secure applications by filtering traffic from trusted segments of your network.

**Network interface cards (NICs).** Network interface cards enable all communication among VMs on a virtual network. Traditional on-premises SAP deployments implement multiple NICs per machine to segregate administrative traffic from business traffic.

On Azure, you don't need to use multiple NICs to increase performance. Multiple NICs share the same network throughput limit of a VM. But if your organization needs to segregate traffic, you can deploy multiple NICs per VM and connect each NIC to a different subnet. You can then use network security groups to enforce different access control policies on each subnet.

Azure NICs support multiple IPs. This support conforms with the SAP recommended practice of using virtual host names for installations. For more information, see [SAP note 962955](https://launchpad.support.sap.com/#/notes/962955). (To access SAP notes, you need an SAP Service Marketplace account.)

> [!NOTE]
> As specified in [SAP Note 2731110](https://launchpad.support.sap.com/#/notes/2731110), don't place a network virtual appliance between the application and the database layers for any SAP application stack. Doing so introduces significant data packet processing time and unacceptably slows application performance.

#### Virtual machines (VMs)

This architecture uses VMs. Azure offers single-node scale up to 32 terabytes (TB) of memory on VMs. The [SAP Certified and Supported SAP HANA Hardware Directory](https://www.sap.com/dmc/exp/2014-09-02-hana-hardware/enEN/#/solutions?filters=ve:24&sort=Latest%20Certification&sortDesc=true&id=s:2494) lists the VMs that are certified for the SAP HANA database. For more information about SAP support for VM types and throughput metrics (SAPS), see [SAP Note 1928533 - SAP Applications on Microsoft Azure: Supported Products and Azure VM types](https://launchpad.support.sap.com/#/notes/1928533). (To access this and other SAP notes, you need an SAP Service Marketplace account.)

Microsoft and SAP jointly certify a range of VM sizes for SAP HANA workloads. For example, smaller deployments can run on an [Edsv4](/azure/virtual-machines/sizes/memory-optimized/edsv4-series) or [Edsv5](/azure/virtual-machines/sizes/memory-optimized/edsv5-series) VM with 160 GiB or more of RAM. To support the largest SAP HANA memory sizes on VMs, as much as 30 TiB, you can use [Mv3-series](/azure/virtual-machines/sizes/memory-optimized/mdsv3-vhm-series) VMs.

**Generation 2 VMs.** When you deploy VMs, you can use either generation 1 or generation 2 VMs. [Generation 2 VMs](/azure/virtual-machines/generation-2) support key features that aren't available for generation 1 VMs. For SAP HANA, this consideration is especially important because some VM families, like [Mv2](/azure/virtual-machines/mv2-series), [Mdsv2](/azure/virtual-machines/sizes/memory-optimized/mv2-series), [Msv3, and Mdsv3](/azure/virtual-machines/sizes/memory-optimized/msv3-hm-series), are supported only as generation 2 VMs. Similarly, SAP on Azure certification might require newer VMs to be generation 2, even if Azure allows both generation 1 and generation 2. For more information, see [SAP Note 1928533 - SAP Applications on Microsoft Azure: Supported Products and Azure VM types](https://launchpad.support.sap.com/#/notes/1928533).

Because all other VMs supporting SAP HANA allow the choice of either generation 2 only or generation 1 and 2 selectively, we recommend that you deploy all SAP VMs as generation 2 only. This recommendation also applies to VMs with low memory requirements. Even the smallest SAP HANA VM can run as a generation 2 VM and can, when deallocated, be resized to the largest VM available in your region.

**Proximity placement groups.** To optimize network latency, you can use [proximity placement groups](/azure/sap/workloads/proximity-placement-scenarios), which prioritize colocation. VMs are located in the same datacenter to minimize latency between SAP HANA and connecting application VMs. For the SAP HANA architecture itself, proximity placement groups aren't required, but using them can help you optimize your performance. Because of potential restrictions with proximity placement groups, you should add the database availability set to the SAP system's proximity placement group only when doing so is required for latency between the SAP application and database traffic. For more information on the usage scenarios of proximity placement groups, see [Configuration options to minimize network latency with SAP applications](/azure/sap/workloads/proximity-placement-scenarios). Because proximity placement groups restrict workloads to a single datacenter, a proximity placement group can't span multiple availability zones. High-volume deployments that reference proximity placement groups can be subject to resource allocation limitations.

### Components

- [Azure Disk Storage](/azure/well-architected/service-guides/azure-disk-storage) is a high-performance, durable block storage solution for Azure VMs. In this architecture, it provides persistent storage for SAP HANA data and log volumes and supports configurations that meet strict latency and throughput requirements.

- [Azure Load Balancer](/azure/well-architected/service-guides/azure-load-balancer) is a layer-4 load balancer that distributes network traffic across VMs. In this architecture, an internal load balancer acts as the virtual IP endpoint for SAP HANA, directing traffic to the active database node and optionally supporting read-enabled secondary nodes.

- [Azure NetApp Files](/azure/well-architected/service-guides/azure-netapp-files) is a high-performance file storage service built for enterprise workloads. In this architecture, it stores SAP HANA data and log files, supports snapshot-based backups, and enables fast recovery and disaster replication across regions.

- [Azure virtual machines](/azure/well-architected/service-guides/virtual-machines) are scalable compute resources for running workloads in Azure. In this architecture, they host the SAP HANA database in a certified, high-memory configuration, supporting scale-up deployments with system replication for high availability.

- [Azure Virtual Network](/azure/well-architected/service-guides/virtual-network) is the foundational networking service in Azure. In this architecture, it connects SAP HANA VMs within a spoke network and links to on-premises systems via a hub network by using ExpressRoute, which enables secure and segmented communication across tiers.

- [ExpressRoute](/azure/well-architected/service-guides/azure-expressroute) is a private connection service between on-premises infrastructure and Azure. In this architecture, it connects the SAP HANA environment to on-premises systems by using zone-redundant gateways. It ensures secure and reliable communication that bypasses the public internet.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability helps ensure that your application can meet the commitments that you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

#### Backup

There are many ways to back up SAP HANA data. After migrating to Azure, you can continue to use any existing partner backup solutions you already have. Azure provides two native approaches: [SAP HANA file-level backup](/azure/backup/sap-hana-database-about) and Azure Backup for SAP HANA over the Backint interface.

For SAP HANA file-level backup, you can use your tool of choice, such as HDBSQL or SAP HANA Studio, and store the backup files on a local disk volume. A common mount point for this backup volume is */hana/backup*. Your backup policies define the data retention period on the volume. As soon as the backup is completed, use a scheduled task to copy the backup files to Azure Blob Storage for safekeeping. Keep the local backup files for expedient recovery.

Azure Backup offers a simple, enterprise-grade solution for workloads running on VMs. [Azure Backup for SAP HANA](/azure/backup/sap-hana-database-about) provides full integration with the SAP HANA backup catalog and guarantees database-consistent, full, or point-in-time recoveries. Azure Backup is [Backint-certified](https://launchpad.support.sap.com/#/notes/2031547) by SAP. For more information, see the [Azure Backup FAQ](/azure/backup/backup-azure-backup-faq) and [support matrix](/azure/backup/sap-hana-backup-support-matrix).

**Azure NetApp Files** provides support for snapshot-based backups. The Azure Application Consistent Snapshot tool ([AzAcSnap](/azure/azure-netapp-files/azacsnap-introduction)) provides integration with SAP HANA for application-consistent snapshots. You can use the resulting snapshots to restore to a new volume for system restore or to copy the SAP HANA database. Snapshots can be used for disaster recovery, where they serve as a restore point, with SAP HANA logs saved on a different NFS volume.

#### Disaster recovery

The following architecture shows a production HANA environment on Azure that provides disaster recovery. The architecture incorporates availability zones.

:::image type="complex" source="./images/sap-hana-scale-up-availability-zone-dr.svg" border="false" lightbox="./images/sap-hana-scale-up-availability-zone-dr.svg" alt-text="Diagram that shows an architecture with disaster recovery.":::
    The diagram is divided vertically into two halves, with region 1 (the primary region) at the top and region 2 (the DR region) at the bottom. On the left, outside both regions, is an on-premises network that contains a gateway. Two ExpressRoute connections extend from the on-premises gateway, one leading to the primary region and one leading to the DR region. The paths are labeled Primary network path and Failover network path. The region 1 architecture uses a hub-and-spoke model. The hub virtual network contains a gateway subnet that contains a zone-redundant gateway, and a shared services subnet that contains Azure Bastion, a firewall, and Active Directory / DNS. A bidirectional arrow labeled Virtual network peering connects the hub to the spoke virtual network. In the spoke virtual network is the database layer subnet, which is divided into three horizontal bands that represent three availability zones. Zone 1 contains HANA VM1 and an SDB VM, zone 2 contains HANA VM2 and an SDB VM, and zone 3 contains an SBD VM. The SDB VMs are optional. A load balancer is located to the left of the HANA VMs and receives incoming traffic through the virtual network peering. A line that connects HANA VM1 and HANA VM2 is labeled HANA system replication. The architecture of region 2, the DR region, mirrors that of the primary region. The DR hub virtual network is the same as the hub virtual network in the primary region, except the Azure Bastion icon appears dimmed. A virtual network peering arrow connects the DR hub to the DR spoke virtual network, which contains a single HANA VM. A dashed line leads from primary HANA VM1 in region 1 to the DR HANA VM in region 2. This line is labeled HANA system replication (async).
:::image-end:::

For DR strategies and implementation details, see [Disaster recovery overview and infrastructure guidelines for SAP workload](/azure/sap/workloads/disaster-recovery-overview-guide) and [Disaster recovery guidelines for SAP application](/azure/sap/workloads/disaster-recovery-sap-guide?tabs=linux).

> [!NOTE]
> If a regional disaster causes a large failover event for many Azure customers in one region, the target region's [resource capacity](/azure/site-recovery/azure-to-azure-common-questions#capacity) isn't guaranteed. Like all Azure services, Azure Site Recovery continues to add features and capabilities. For the latest information about Azure-to-Azure replication, see the [support matrix](/azure/site-recovery/azure-to-azure-support-matrix).

In addition to a local two-node high availability implementation, SAP HANA System Replication supports [multitier](https://help.sap.com/docs/SAP_HANA_PLATFORM/6b94445c94ae495c83a19646e7c3fd56/ca6f4c62c45b4c85a109c7faf62881fc.html?version=2.0.05) and [multitarget](https://help.sap.com/docs/SAP_HANA_PLATFORM/6b94445c94ae495c83a19646e7c3fd56/ba457510958241889a459e606bbcf3d3.html?version=2.0.05) replication. SAP HANA System Replication therefore supports inter-zone and inter-region replication. Multitarget replication is available for SAP HANA 2.0 SPS 03 and later.

Be sure to verify your target region's [resource capacity](/azure/site-recovery/azure-to-azure-common-questions#capacity).

**Azure NetApp Files.** You can optionally use [Azure NetApp Files](/azure/sap/workloads/hana-vm-operations-netapp) as a scalable, high-performance storage solution for SAP HANA data and log files. Azure NetApp Files supports snapshots for fast backup, recovery, and local replication. You can use  Azure NetApp Files cross-region replication to replicate the snapshot data between two regions. For more information, see [Understand Azure NetApp Files replication](/azure/azure-netapp-files/replication) and the [SAP HANA Disaster Recovery with Azure NetApp Files](https://docs.netapp.com/us-en/netapp-solutions-sap/pdfs/sidebar/SAP_HANA_Disaster_Recovery_with_Azure_NetApp_Files.pdf) white paper.

#### High availability

The preceding architecture depicts a highly available deployment, with SAP HANA contained on two or more VMs. The following components are used.

**Load balancers.** [Azure Load Balancer](/azure/load-balancer/load-balancer-overview) distributes traffic to SAP HANA VMs. Load Balancer supports zone-redundant distribution for zonal deployments of SAP. In this architecture, an internal load balancer serves as the virtual IP address for SAP HANA. Network traffic is sent to the active VM that contains the primary database instance. SAP HANA active/read-enabled architecture is optionally available ([SLES](/azure/sap/workloads/sap-hana-high-availability)/[RHEL](/azure/sap/workloads/sap-hana-high-availability-rhel#configure-hana-activeread-enabled-system-replication-in-pacemaker-cluster)). In this architecture, a second virtual IP address on the load balancer directs network traffic to the secondary SAP HANA instance on another VM for read-intense workloads.

Load Balancer provides a layer of security by default. VMs that are behind Load Balancer don't have outbound internet connectivity. To enable outbound internet in these VMs, you need to update your [Load Balancer](/azure/sap/workloads/high-availability-guide-standard-load-balancer-outbound-connections) configuration. You can also use [Azure NAT Gateway](/azure/nat-gateway/nat-overview) to get outbound connectivity.

For SAP HANA database clusters, you need to enable Direct Server Return (DSR), also known as *floating IP*. This feature allows the server to respond with the IP address of the load balancer front end.

**Deployment options.** On Azure, SAP workload deployment can be either regional or zonal, depending on the availability and resiliency requirements of the SAP applications. Azure provides [different deployment options](/azure/sap/workloads/sap-high-availability-architecture-scenarios#comparison-of-different-deployment-types-for-sap-workload), like Azure Virtual Machine Scale Sets with Flexible orchestration (FD=1), availability zones, and availability sets, to increase the availability of resources. For new SAP deployments across availability zones, use Virtual Machine Scale Sets with Flexible orchestration and FD=1. To get a comprehensive understanding of the available deployment options and their applicability across different Azure regions (including across zones, within a single zone, or in a region without zones), see [High-availability architecture and scenarios for SAP NetWeaver](/azure/sap/workloads/sap-high-availability-architecture-scenarios) and [Virtual Machine Scale Sets for SAP workloads](/azure/sap/workloads/virtual-machine-scale-set-sap-deployment-guide).

**SAP HANA.** For high availability, SAP HANA runs on two or more Linux VMs. SAP HANA System Replication is used to replicate data between the primary and secondary (replica) SAP HANA systems. SAP HANA System Replication is also used for cross-region or cross-zone disaster recovery. Depending on latency in the communication between your VMs, you might be able to use synchronous replication within a region. SAP HANA System Replication between regions for disaster recovery usually runs asynchronously.

For the Linux Pacemaker cluster, you need to decide which cluster fencing mechanism to use. Cluster fencing is the process of isolating a failed VM from the cluster and restarting it. Supported fencing options vary by distribution version and scenario. Review the supported configurations in [High availability of SAP NetWeaver on Azure VMs on Red Hat Enterprise Linux](/azure/sap/workloads/high-availability-guide-rhel-pacemaker) and [High availability of SAP NetWeaver on Azure VMs on SUSE Linux Enterprise Server](/azure/sap/workloads/high-availability-guide-suse-pacemaker) to determine when to use an Azure fence agent or STONITH block device (SBD), including SBD deployments that use Azure shared disks. Compare the failover times for each supported solution and choose the approach that best meets your RTO.

**Azure fence agent.** This fencing method relies on the Azure Resource Manager API. Pacemaker queries the API about the status of both SAP HANA VMs in the cluster. If one VM fails, for example because the operating system is unresponsive or the VM crashes, the cluster manager uses the API to restart the VM and, if needed, fails over the SAP HANA database to the other active node. To authorize against the API, use managed identities for the cluster VMs to query and restart VMs. No other infrastructure is needed. The SBD VMs in the architecture diagrams aren't deployed if an Azure fence agent is used.

**SBD.** SBD uses one or more disks that are accessed as a block device (raw, without a filesystem) by the cluster manager. These disks act as a vote. Each of the two cluster nodes running SAP HANA accesses the SBD disks and periodically reads and writes small status records. So each cluster node knows the status of the other without depending only on networking between the VMs.

Preferably, you should deploy three small VMs in an availability zone setup. Each VM exports small parts of a disk as a block device, which is accessed by the two SAP HANA cluster nodes. Three SBD VMs ensure that sufficient voting members are available in case of planned or unplanned downtime for either SBD VM.

Instead of using SBD VMs, you can use [Azure shared disk](/azure/virtual-machines/disks-shared). If you use this option, SAP HANA cluster nodes [access the single shared disk](/azure/sap/workloads/high-availability-guide-suse-pacemaker#use-an-sbd-device). The shared disk can be locally redundant ([LRS](/azure/storage/common/storage-redundancy#locally-redundant-storage)), or zone rudundant ([ZRS](/azure/storage/common/storage-redundancy#zone-redundant-storage)) if ZRS is available in your Azure region.

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

Many security measures are used to protect the confidentiality, integrity, and availability of an SAP landscape. To secure user access, SAP provides application-level identity, role, and authorization controls. For infrastructure and platform guidance that applies to SAP on Azure, see [Secure Azure infrastructure for SAP applications](/azure/sap/workloads/sap-security-infrastructure).

For data at rest, use the current SAP on Azure encryption guidance:

* Use SAP HANA native encryption to secure HANA data, log, and backup content.

* Azure managed disks and storage are encrypted at rest by default with server-side encryption. You can use either platform-managed keys or customer-managed keys, depending on your security requirements.

* For VM-level protection, evaluate [encryption at host](/azure/virtual-machines/disk-encryption#encryption-at-host---end-to-end-encryption-for-your-vm-data) for supported VM sizes and operating system combinations. Review the current SAP guidance for any VM family-specific considerations before enabling it.

* Azure Disk Encryption isn't supported for SAP systems and is [scheduled for retirement](/azure/virtual-machines/linux/disk-encryption-overview). Don't plan new SAP HANA deployments around Azure Disk Encryption.

> [!NOTE]
> Don't combine SAP HANA native encryption with guest-based disk encryption. For SAP HANA on Azure, use HANA native encryption together with Azure storage encryption. If you use customer-managed keys, validate the performance effect for your storage and VM configuration.

For network security, use network security groups and Azure Firewall or a network virtual appliance, as follows:

* Use [network security groups](/azure/virtual-network/network-security-groups-overview) to protect and control traffic between subnets and application/database layers. Only apply network security groups to subnets. Applying network security groups to both NICs and subnets often leads to problems during troubleshooting. You should use this combination rarely, if ever.

* Use [Azure Firewall](/azure/firewall/overview) or an Azure network virtual appliance to inspect and control the routing of traffic from the hub virtual network to the spoke virtual network that contains your SAP applications, and also to control your outbound internet connectivity.

For user authorization, implement Azure role-based access control (Azure RBAC) and resource locks as follows:

* Follow the principle of least privilege, using [Azure RBAC](/azure/role-based-access-control/overview) for assigning administrative privileges at IaaS-level resources that host your SAP solution on Azure. The fundamental purpose of Azure RBAC is the segregation and control of duties for your users or group. Azure RBAC is designed to grant only the amount of access to resources that's needed to enable users to do their jobs.

* Use [resource locks](/azure/azure-resource-manager/management/lock-resources) to help prevent accidental or malicious changes. Resource locks help prevent administrators from deleting or modifying critical Azure resources where your SAP solution is located.

For more security guidance, see [Security for your SAP landscape](/azure/sap/workloads/planning-guide#security-for-your-sap-landscape) and [Secure Azure infrastructure for SAP applications](/azure/sap/workloads/sap-security-infrastructure).

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

The main infrastructure cost drivers in this architecture are:

- SAP HANA-certified VM SKUs and the number of database nodes that you deploy for high availability and disaster recovery.

- Storage performance tiers and capacity for data, log, and backup volumes, including Azure NetApp Files capacity and replication where used.

Use this [Azure Pricing Calculator estimate](https://azure.com/e/bf3998d7be834670bc2632dbf7efb87b) to estimate the cost of a smaller architecture. Modify the selections to match your design. When you create a calculator estimate, include your selected VM SKUs, node counts, storage tiers, and network components.

Typical sizing starts with one of these patterns and then scales by memory, IOPS, and throughput requirements:

- Small: Two-node high availability in one region with SAP HANA-certified E-series VMs and managed disks.

- Medium: Two-node high availability in one region with larger memory-optimized SKUs and higher-performance log storage.

- Large: Regional high availability plus cross-region disaster recovery, often with M-series VMs and replicated storage.

To reduce costs, right-size VM memory for the actual HANA dataset and growth profile, apply cost-conscious storage guidance for eligible non-production systems, and evaluate reservations or savings plans for steady-state compute after validating operational flexibility and licensing requirements.

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

#### Monitoring

To monitor your workloads on Azure, you can use [Azure Monitor](/azure/azure-monitor/fundamentals/overview) to comprehensively collect, analyze, and act on telemetry from your cloud and on-premises environments.

For SAP applications that run on SAP HANA and other major database solutions, see [Azure Monitor for SAP solutions](/azure/sap/monitor/about-azure-monitor-sap-solutions) to learn how Azure Monitor for SAP can help you manage the availability and performance of SAP services.

### Performance Efficiency

Performance Efficiency refers to your workload's ability to scale to meet user demands efficiently. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

#### Scalability

This architecture runs SAP HANA on VMs that can scale up to 32 TiB in one instance.

If your workload exceeds the maximum VM size, use multinode HANA scale-out configurations. For online transaction processing (OLTP) applications, total scale-out memory capacity can be as high as 4 x 23 TiB. For online analytical processing (OLAP) applications, the scale-out memory capacity can be as high as 16 x 7.6 TiB. For example, you can deploy SAP HANA in a scale-out configuration with standby on VMs running either [Red Hat Enterprise Linux](/azure/sap/workloads/sap-hana-scale-out-standby-netapp-files-rhel) or [SUSE Linux Enterprise Server](/azure/sap/workloads/sap-hana-scale-out-standby-netapp-files-suse) and use [Azure NetApp Files](/azure/azure-netapp-files/azure-netapp-files-introduction/) for the shared storage volumes. To identify the certified VM SKUs that support scale-out configurations, see the [Certified and Supported SAP HANA Hardware Directory](https://www.sap.com/dmc/exp/2014-09-02-hana-hardware/enEN/#/solutions?filters=ve:24;v:deCertified;v:deTdi&sort=Latest%20Certification&sortDesc=true&search=&id=s:2966). Review the details of the certificate for each VM SKU to ensure support of your configuration.

#### Storage

This architecture uses [Azure managed disks](/azure/virtual-machines/managed-disks-overview) for storage on the VMs or Azure NetApp Files. Guidelines for storage deployment with managed disks are described in detail in the [SAP HANA Azure virtual machine storage configurations document](/azure/sap/workloads/hana-vm-operations-storage). As an alternative to managed disks, you can use [Azure NetApp Files NFS](/azure/sap/workloads/hana-vm-operations-netapp) volumes as a storage solution for SAP HANA.

For high input/output operations per second (IOPS) and disk storage throughput, the common practices in storage volume [performance optimization](/azure/virtual-machines/premium-storage-performance) also apply to Azure storage layout. For example, combining multiple disks with LVM to create a striped disk volume improves IO performance. Azure disk caching also plays a significant role in achieving required IO performance.

For SAP HANA log disks that run on Azure Premium SSD v1, use one of the following technologies in locations that hold */hana/log* for production:

- [Write Accelerator](/azure/virtual-machines/how-to-enable-write-accelerator) (on M-series VMs)

- [Ultra Disks](/azure/virtual-machines/disks-enable-ultra-ssd) (on either M-series or E-series VMs)

- [Azure NetApp Files](/azure/azure-netapp-files/) (on either M-series or E-series VMs)

These technologies are needed to consistently meet the required storage latency of less than 1 ms.

[Azure Premium SSD v2](https://azure.microsoft.com/updates/general-availability-azure-premium-ssd-v2-disk-storage/) is designed for performance-critical workloads like SAP. Write Accelerator isn't required when /*hana/log* is running on Premium SSD v2. For information about this storage solution's benefits and limitations, see [Deploy a Premium SSD v2](/azure/virtual-machines/disks-deploy-premium-v2).

For more information about SAP HANA performance requirements, see [SAP Note 1943937 - Hardware Configuration Check Tool](https://launchpad.support.sap.com/#/notes/1943937).

- **Cost-conscious storage design for non-production systems.** For SAP HANA environments that don't require maximum storage performance in all situations, you can use a storage architecture that's optimized for cost. This choice of storage optimization can apply to little-used production systems or some non-production SAP HANA environments. The cost-optimized storage option uses a combination of Standard SSDs instead of the Premium SSDs or Ultra Disks that are used for production environments. It also combines */hana/data* and */hana/log* file systems onto a single set of disks. [Guidelines and best practices](/azure/sap/workloads/hana-vm-operations-storage) are available for most VM sizes. If you use Azure NetApp Files for SAP HANA, you can use size-reduced volumes to achieve the same goal.

- **Resizing storage when scaling-up.** When you resize a VM because of changed business demands or a growing database size, the storage configuration can change. Azure supports online disk expansion without any interruption to service. With a striped disk setup, as is used for SAP HANA, you should perform a resize operation equally to all disks in the volume group. The addition of more disks to a volume group can unbalance the striped data. If you're adding more disks to a storage configuration, it's better to create a new storage volume on new disks. Next, copy the contents during downtime and modify mount points. Finally, discard the old volume group and underlying disks.

- **Azure NetApp Files application volume group.** For deployments in which SAP HANA files are contained on Azure NetApp Files NFS volumes, application volume groups enable you to deploy all volumes according to best practices. This process also ensures optimal performance for your SAP HANA database. [Details are available](/azure/azure-netapp-files/application-volume-group-introduction) about how to proceed with this process. It requires manual intervention. Allow some time for the configuration.

## Communities

Communities can answer questions and help you set up a successful deployment. Consider the following communities:

* [Azure Community Support](https://azure.microsoft.com/support/community/)

* [SAP Community](https://community.sap.com/)

* [SAP HANA on Stack Overflow](https://stackoverflow.com/tags/hana/info)

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [Robert Biro](https://www.linkedin.com/in/robert-biro-38991927/) | Senior Architect

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

Learn more about the component technologies:

- [What is Azure ExpressRoute?](/azure/expressroute/expressroute-introduction)
- [SAP workload configurations with Azure availability zones](/azure/sap/workloads/high-availability-zones)
- [High-availability architecture and scenarios for SAP NetWeaver](/azure/sap/workloads/sap-high-availability-architecture-scenarios)
- [Virtual Machine Scale Sets for SAP workloads](/azure/sap/workloads/virtual-machine-scale-set-sap-deployment-guide)
- [What is Azure Load Balancer?](/azure/load-balancer/load-balancer-overview)
- [What is Azure NetApp Files?](/azure/azure-netapp-files/azure-netapp-files-introduction)
- [Introduction to Azure managed disks](/azure/virtual-machines/managed-disks-overview)
- [Virtual machines in Azure](/azure/virtual-machines/overview)
- [Installation of SAP HANA on Azure virtual machines](/azure/sap/workloads/hana-get-started)
- [SAP HANA Azure virtual machine storage configurations](/azure/sap/workloads/hana-vm-operations-storage)
- [What is Azure Virtual Network?](/azure/virtual-network/virtual-networks-overview)
- [Network security groups](/azure/virtual-network/network-security-groups-overview)
- [Security for your SAP landscape](/azure/sap/workloads/planning-guide#security-for-your-sap-landscape)
- [Secure Azure infrastructure for SAP applications](/azure/sap/workloads/sap-security-infrastructure)
- [SAP HANA Disaster Recovery with Azure NetApp Files](https://docs.netapp.com/us-en/netapp-solutions-sap/pdfs/sidebar/SAP_HANA_Disaster_Recovery_with_Azure_NetApp_Files.pdf)

## Related resources

Explore related architectures:

- [Run a Linux VM on Azure](../n-tier/linux-vm.yml)
- [Run SAP BW/4HANA with Linux virtual machines on Azure](./run-sap-bw4hana-with-linux-virtual-machines.yml)
- [SAP S/4HANA in Linux on Azure](/azure/architecture/guide/sap/sap-s4hana)
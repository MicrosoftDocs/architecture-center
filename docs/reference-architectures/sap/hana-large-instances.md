---
title: Run SAP HANA on Azure Large Instances
description:  Proven practices for running SAP HANA in a high availability environment on Azure Large Instances.
author: lbrader
ms.date: 05/16/2018
---

# Run SAP HANA on Azure Large Instances

This reference architecture shows a set of proven practices for running SAP HANA on Azure (Large Instances) with high availability and disaster recovery (DR). Called HANA Large Instances, this offering is deployed on physical servers in Azure regions. 

![0][0]

> [!NOTE]
> Deploying this reference architecture requires appropriate licensing of SAP products and other non-Microsoft technologies.

## Architecture

This architecture consists of the following infrastructure components.

- **Virtual network**. The [Azure Virtual Network][vnet] service securely connects Azure resources to each other and is subdivided into separate [subnets][subnet] for each layer. SAP application layers are deployed on Azure virual machines (VMs) to connect to the HANA database layer residing on large instances.

- **Virtual machines**. Virtual machines are used in the SAP application layer and shared services layer. The latter includes a jumpbox used by administrators to set up HANA Large Instances and to provide access to other virtual machines. 

- **HANA Large Instance**. A [physical server][physical] certified to meet SAP HANA Tailored Datacenter Integration (TDI) standards runs SAP HANA. This architecture uses two HANA Large Instances: a primary and a secondary compute unit. High availability at the data layer is provided through HANA System Replication (HSR).

- **High Availability Pair**. A group of HANA Large Instances blades are managed together to provide application redundancy and reliability. 

- **MSEE (Microsoft Enterprise Edge)**. MSEE is a connection point from a connectivity provider or your network edge through an ExpressRoute circuit. 

- **Network interface card (NIC)**. To enable communication with the Azure virtual network, the HANA Large Instance server provides four virtual NICs by default. This architecture requires one NIC for client communication with the Azure virtual machines, a second NIC for the node-to-node connectivity needed by HSR, a third NIC for HANA Large Instance storage, and a fourth for iSCSI used in high availability clustering.
    
- **Network File System (NFS) storage**. The [NFS][nfs] server supports the network file share that provides secure data persistence for HANA Large Instance.

- **ExpressRoute.** [ExpressRoute][expressroute] is the recommended Azure networking service for creating private connections between an on-premises network and Azure virtual networks that do not go over the  public Internet. Azure VMs connect to HANA Large Instances using another ExpressRoute connection. The ExpressRoute connection between the Azure virtual network and the HANA Large Instances is set up as part of the Microsoft offering.

- **Gateway**. The ExpressRoute Gateway is used to connect the Azure virtual network used for the SAP application layer to the HANA Large Instance network. Use the [High Performance or Ultra Performance][sku] SKU.

- **Disaster recovery (DR)**. Upon request, storage replication is supported and will be configured from the primary to the [DR site][DR-site] located in another region.  
 
## Recommendations
Requirements can vary, so use these recommendations as a starting point.

### HANA Large Instances compute
[Large Instances][physical] are physical servers based on the Intel EX E7 CPU architecture and configured in a large instance stamp—that is, a specific set of servers or blades. A compute unit equals one server or blade, and a stamp is made up of multiple servers or blades. Within a large instance stamp, servers are not shared and are dedicated to running one customer’s deployment of SAP HANA.

A variety of SKUs are available for HANA Large Instances, supporting up to 20 TB single instance (60 TB scale-out) of memory for S/4HANA or other SAP HANA workloads. [Two classes][classes] of servers are offered:

- Type I class: S72, S72m, S144, S144m, S192, and S192m

- Type II class: S384, S384m, S384xm, S576m, S768m, and S960m

For example, the S72 SKU comes with 768 GB RAM, 3 terabytes (TB) of storage, and 2 Intel Xeon processors (E7-8890 v3) with 36 cores. Choose a SKU that fulfills the sizing requirements you determined in your architecture and design sessions. Always ensure that your sizing applies to the correct SKU. Capabilities and deployment requirements [vary by type][type], and availability varies by [region][region]. You can also step up from one SKU to a larger SKU.

Microsoft helps establish the large instance setup, but it is your responsibility to verify the operating system’s configuration settings. Make sure to review the most current SAP Notes for your exact Linux release.

### Storage
Storage layout is implemented according to the recommendation of the TDI for SAP HANA. HANA Large Instances come with a specific storage configuration for the standard TDI specifications. However, you can purchase additional storage in 1 TB increments. 

To support the requirements of mission-critical environments including fast recovery, NFS is used and not direct attached storage. The NFS storage server for HANA Large Instances is hosted in a multi-tenant environment, where tenants are segregated and secured using compute, network, and storage isolation.

To support high availability at the primary site, use different storage layouts. For example, in a multi-host scale-out, the storage is shared. Another high availability option is application-based replication such as HSR. For DR, however, a snapshot-based storage replication is used.

### Networking
This architecture uses both virtual and physical networks. The virtual network is part of Azure IaaS and connects to a discrete HANA Large Instances physical network through [ExpressRoute][expressroute]] circuits. A cross-premises gateway connects your workloads in the Azure virtual network to your on-premises sites.

HANA Large Instances networks are isolated from each other for security. Instances residing in different regions do not communicate with each other, except for the dedicated storage replication. However, to use HSR, inter-region communications are required. [IP routing tables][ip] or proxies can be used to enable cross-regions HSR.

All Azure virtual networks that connect to HANA Large Instances in one region can be [cross-connected][cross-connected] via ExpressRoute to HANA Large Instances in a secondary region.

ExpressRoute for HANA Large Instances is included by default during provisioning. For setup, a specific network layout is needed, including required CIDR address ranges and domain routing. For details, see [SAP HANA (large instances) infrastructure and connectivity on Azure][HLI-infrastructure].

## Scalability considerations
To scale up or down, you can choose from many sizes of servers that are available for HANA Large Instances. They are categorized as [Type I and Type II][classes] and tailored for different workloads. Choose a size that can grow with your workload for the next three years. One-year commitments are also available.

A multi-host scale-out deployment is generally used for BW/4HANA deployments as a kind of database partitioning strategy. To scale out, plan the placement of HANA tables prior to installation. From an infrastructure standpoint, multiple hosts are connected to a shared storage volume, enabling quick takeover by standby hosts in case one of the compute worker nodes in the HANA system fails.

S/4HANA and SAP Business Suite on HANA on a single blade can be scaled up to 20 TB with a single HANA Large Instances instance.

For greenfield scenarios, the [SAP Quick Sizer][quick-sizer] is available to calculate memory requirements of the implementation of SAP software on top of HANA. Memory requirements for HANA increase as data volume grows. Use your system’s current memory consumption as the basis for predicting future consumption, and then map your demand into one of the HANA Large Instances sizes.

If you already have SAP deployments, SAP provides reports you can use to check the data used by existing systems and calculate memory requirements for a HANA instance. For example, see the following SAP Notes: 

- SAP Note [1793345][sap-1793345] - Sizing for SAP Suite on HANA
- SAP Note [1872170][sap-1872170] - Suite on HANA and S/4 HANA sizing report
- SAP Note [2121330][sap-2121330] - FAQ: SAP BW on HANA Sizing Report
- SAP Note [1736976][sap-1736976] - Sizing Report for BW on HANA
- SAP Note [2296290][sap-2296290] - New Sizing Report for BW on HANA

## Availability considerations
Work with SAP, your system integrator, or Microsoft to properly architect and implement a [high availability and disaster-recovery][hli-hadr] strategy. This architecture follows the Azure [service-level agreement][sla] (SLA) for HANA on Azure (Large Instances). To assess your availability requirements, consider any single points of failure, the desired level of uptime for services, and these common metrics:

- Recovery Time Objective (RTO) means the duration of time in which the HANA Large Instances server is unavailable.

- Recovery Point Objective (RPO) means the maximum tolerable period in which customer data might be lost due to a disaster.

For high availability, deploy more than one instance in a HA Pair and use HSR in a synchronous mode to minimize data loss and downtime. In addition to a local, two-node high availability setup, HSR supports multi-tier replication, where a third node in a separate Azure region registers to the secondary replica of the clustered HSR pair as its replication target. This forms a replication daisy chain. The failover to the DR node is a manual process.

When you set up HANA Large Instances HSR with automatic failover, you can request the Microsoft Service Management team to set up a [STONITH device][stonith] for your existing servers. 

## Disaster recovery considerations
This architecture supports [disaster recovery][hli-dr] between HANA Large Instances in different Azure regions. There are two ways to support DR with HANA Large Instances:

- Storage replication. The primary storage contents are constantly replicated to the remote DR storage systems that are available on the designated DR HANA Large Instances server. In storage replication, the HANA database is not loaded into memory. This DR option is simpler from an administration perspective. To determine if this is a suitable strategy, consider the database load time against the availability SLA. Storage replication also enables you to perform point-in-time recovery. If multi-purpose (cost-optimized) DR is set up, you must purchase additional storage of the same size at the DR location. Microsoft provides self-services [storage snapshot and failover scripts][scripts] for HANA failover as part of the HANA Large Instances offering.

- Multi-tier HSR with a third replica in the DR region (where the HANA database is loaded onto memory). This option supports a faster recovery time but does not support a point-in-time recovery. HSR requires a dedicated system. HANA system replication for the DR site is handled through proxies such as nginx or IP tables. 

## Backup considerations
Based on your business requirements, choose from several options available for [backup and recovery][hli-backup].

| Backup option                   | Pros                                                                                                   | Cons                                                       |
|---------------------------------|--------------------------------------------------------------------------------------------------------|------------------------------------------------------------|
| HANA backup        | Native to SAP. Built-in consistency check.                                                             | Long backup and recovery times. Storage space consumption. |
| HANA snapshot      | Native to SAP. Rapid backup and restore.                                                               |                                       |
| Storage snapshot   | Included with HANA Large Instances. Optimized DR for HANA Large Instances. Boot volume backup support. | Maximum 254 snapshots per volume.                          |
| Log backup         | Required for point in time recovery.                                                                   |                                                            |
| Other backup tools | Redundant backup location.                                                                             | Additional licensing costs.                                |

In addition, SapHanaTutorial.com provides a helpful article, [Comparison between HANA backup options][sap-hana-tutorial].

## Manageability considerations
Monitor HANA Large Instances resources such as CPU, memory, network bandwidth, and storage space using SAP HANA Studio, SAP HANA Cockpit, SAP Solution Manager, and other native Linux tools. HANA Large Instances does not come with built-in monitoring tools. Microsoft offers resources to help you [troubleshoot and monitor][hli-troubleshoot] according to your organization’s requirements, and the Microsoft support team can assist you in troubleshooting technical issues. 

If you need more computing capability, you must get a larger SKU. 

## Security considerations
- By default, HANA Large Instances use storage encryption based on TDE (transparent data encryption) for the data at rest.

- Data in transit between HANA Large Instances and the virtual machines is not encrypted. To encrypt the data transfer, enable the application-specific encryption. See SAP Note [2159014][sap-2159014] - FAQ: SAP HANA Security.

- Isolation provides security between the tenants in the multi-tenant HANA Large Instance environment. Tenants are isolated using their own VLAN.

- [Azure network security best practices][network-best-practices] provide helpful guidance.

- As with any deployment, [operating system hardening][os-hardening] is recommended.

- For physical security, access to Azure datacenters is limited to authorized personnel only. No customers can access the physical servers.

For more information, see [SAP HANA Security—An Overview][sap-security].(A SAP Service Marketplace account is required for access.)

## Communities
Communities can answer questions and help you set up a successful deployment. Consider the following:

* [Running SAP Applications on the Microsoft Platform Blog][running-sap-blog]
* [Azure Forum][azure-forum]
* [SAP Community][sap-community]
* [Stack Overflow SAP][stack-overflow]

[azure-cli]: /cli/azure/install-azure-cli
[azure-forum]: https://azure.microsoft.com/support/forums/
[azure-large-instances]: /azure/virtual-machines/workloads/sap/hana-overview-architecture
[azure-lb]: /azure/load-balancer/load-balancer-overview
[azure-storage]: /azure/storage/storage-standard-storage
[azure-trust-center]: https://azure.microsoft.com/support/trust-center/
[backup-faq]: /azure/backup/backup-azure-backup-faq
[classes]: /azure/virtual-machines/workloads/sap/hana-overview-architecture
[clustering]: https://blogs.msdn.microsoft.com/saponsqlserver/2015/05/20/clustering-sap-ascs-instance-using-windows-server-failover-cluster-on-microsoft-azure-with-sios-datakeeper-and-azure-internal-load-balancer/
[cool-blob-storage]: /azure/storage/storage-blob-storage-tiers
[cross-connected]: /azure/virtual-machines/workloads/sap/hana-overview-high-availability-disaster-recovery#network-considerations-for-disaster-recovery-with-hana-large-instances
[disk-encryption]: /azure/security/azure-security-disk-encryption
[dr-site]: /azure/virtual-machines/workloads/sap/hana-overview-high-availability-disaster-recovery
[expressroute]: /azure/architecture/reference-architectures/hybrid-networking/expressroute
[filter-network]: https://azure.microsoft.com/blog/multiple-vm-nics-and-network-virtual-appliances-in-azure/
[github]: https://github.com/mspnp/reference-architectures/tree/master/sap/sap-hana
[hana-backup]: /azure/virtual-machines/workloads/sap/sap-hana-backup-guide
[hana-guide]: https://help.sap.com/viewer/2c1988d620e04368aa4103bf26f17727/2.0.01/en-US/7eb0167eb35e4e2885415205b8383584.html
[hli-dr]: /azure/virtual-machines/workloads/sap/hana-overview-high-availability-disaster-recovery#network-considerations-for-disaster-recovery-with-hana-large-instances
[hli-backup]: /azure/virtual-machines/workloads/sap/hana-overview-high-availability-disaster-recovery#backup-and-restore
[hli-hadr]: /azure/virtual-machines/workloads/sap/hana-overview-high-availability-disaster-recovery?toc=%2fazure%2fvirtual-machines%2flinux%2ftoc.json
[hli-infrastructure]: /azure/virtual-machines/workloads/sap/hana-overview-infrastructure-connectivity
[hli-overview]: /azure/virtual-machines/workloads/sap/hana-overview-architecture
[hli-troubleshoot]: /azure/virtual-machines/workloads/sap/troubleshooting-monitoring
[ilb]: /azure/load-balancer/load-balancer-internal-overview
[ip]: https://blogs.msdn.microsoft.com/saponsqlserver/2018/02/10/setting-up-hana-system-replication-on-azure-hana-large-instances/
[logon-groups]: https://wiki.scn.sap.com/wiki/display/SI/ABAP+Logon+Group+based+Load+Balancing
[managed-disks]: /azure/storage/storage-managed-disks-overview
[monitoring]: /azure/architecture/best-practices/monitoring
[multiple-vm-nics]: https://azure.microsoft.com/blog/multiple-vm-nics-and-network-virtual-appliances-in-azure/
[netweaver-on-azure]: /azure/virtual-machines/workloads/sap/planning-guide
[network-best-practices]: /azure/security/azure-security-network-security-best-practices
[network-considerations]: /azure/virtual-machines/workloads/sap/hana-overview-high-availability-disaster-recovery#network-considerations-for-disaster-recovery-with-hana-large-instances
[nsg]: /azure/virtual-network/virtual-networks-n
[os-hardening]: /azure/security/azure-security-iaas
[physical]: /azure/virtual-machines/workloads/sap/hana-overview-architecture
[planning]: /azure/vpn-gateway/vpn-gateway-plan-design
[protecting-sap]: https://blogs.msdn.microsoft.com/saponsqlserver/2016/05/06/protecting-sap-systems-running-on-vmware-with-azure-site-recovery/
[ref-arch]: /azure/architecture/reference-architectures/
[running-SAP]: https://blogs.msdn.microsoft.com/saponsqlserver/2016/06/07/sap-on-sql-general-update-for-customers-partners-june-2016/
[region]: https://azure.microsoft.com/en-in/global-infrastructure/services/
[running-sap-blog]: https://blogs.msdn.microsoft.com/saponsqlserver/2017/05/04/sap-on-azure-general-update-for-customers-partners-april-2017/
[quick-sizer]: http://service.sap.com/quicksizing
[sap-1943937]: https://launchpad.support.sap.com/#/notes/1943937
[sap-1928533]: https://launchpad.support.sap.com/#/notes/1928533
[sap-1793345]: https://launchpad.support.sap.com/#/notes/1793345
[sap-1872170]: https://launchpad.support.sap.com/#/notes/1872170
[sap-2121330]: https://launchpad.support.sap.com/#/notes/2121330
[sap-2159014]: https://launchpad.support.sap.com/#/notes/2159014
[sap-1736976]: https://launchpad.support.sap.com/#/notes/1736976
[sap-2296290]: https://launchpad.support.sap.com/#/notes/2296290
[sap-community]: https://www.sap.com/community.html
[sap-dispatcher]: https://help.sap.com/doc/saphelp_nw73ehp1/7.31.19/en-US/48/8fe37933114e6fe10000000a421937/frameset.htm
[sap-dispatcher-ha]: https://help.sap.com/doc/saphelp_nw73ehp1/7.31.19/en-US/48/9a9a6b48c673e8e10000000a42189b/frameset.htm
[sap-dispatcher-install]: https://wiki.scn.sap.com/wiki/display/SI/Web+Dispatcher+Installation
[sap-guide]: https://service.sap.com/instguides
[sap-ha]: https://support.sap.com/content/dam/SAAP/SAP_Activate/AGS_70.pdf
[sap-hana-on-azure]: https://azure.microsoft.com/solutions/sap/
[sap-hana-tutorial]: http://saphanatutorial.com/comparison-between-hana-backup-options/
[sap-netweaver-dr]: http://download.microsoft.com/download/9/5/6/956FEDC3-702D-4EFB-A7D3-2DB7505566B6/SAP%20NetWeaver%20-%20Building%20an%20Azure%20based%20Disaster%20Recovery%20Solution%20V1_5%20.docx
[sap-security]: https://archive.sap.com/documents/docs/DOC-62943
[scripts]: /azure/virtual-machines/workloads/sap/hana-overview-high-availability-disaster-recovery
[sku]: /azure/expressroute/expressroute-about-virtual-network-gateways
[sla]: https://azure.microsoft.com/support/legal/sla/virtual-machines
[stack-overflow]: http://stackoverflow.com/tags/sap/info
[stonith]: /azure/virtual-machines/workloads/sap/ha-setup-with-stonith
[swd]: https://help.sap.com/doc/saphelp_nw70ehp2/7.02.16/en-us/48/8fe37933114e6fe10000000a421937/frameset.htm
[template-bb]: https://github.com/mspnp/template-building-blocks/wiki
[type]: /azure/virtual-machines/workloads/sap/hana-installation
[vnet]: /azure/virtual-network/virtual-networks-overview
[white-papers]: https://azure.microsoft.com/blog/azure-compliance-white-paper-o-rama/
[0]: ./images/sap-hana-large-instances.png "SAP HANA architecture using Azure Large Instances"

<!-- cSpell:ignore lbrader HANA MSEE Xeon CIDR STONITH VLAN -->

This reference architecture shows a set of proven practices for running SAP HANA on Azure (Large Instances) with high availability (HA) and disaster recovery (DR). Called HANA Large Instances (HLI), this offering is deployed on physical servers in Azure regions. This solution depicts a simple scale-up scenario to demonstrate core concepts in the deployment and operation of an SAP HANA system on Azure. For options, see other [installation scenarios for HANA Large Instances][scenarios].

> [!NOTE]
> Deploying this reference architecture requires appropriate licensing of SAP products and other non-Microsoft technologies.

## Architecture

:::image type="complex" source="./images/sap-hana-large-instances.svg" alt-text="SAP HANA architecture using Azure Large Instances." lightbox="./images/sap-hana-large-instances.svg":::
The diagram shows two Azure regions. The primary region contains an application tier with SAP applications, an SAP HANA server pool, and an ExpressRoute gateway. The ExpressRoute gateway connects to the secondary region, which contains a replicated HANA server pool.
:::image-end:::

*Download a [Visio file][visio-download] of this architecture.*

### Workflow

This architecture consists of the following infrastructure components.

- **Virtual network**. The [Azure Virtual Network][vnet] (VNet) service securely connects Azure resources to each other and is subdivided into separate [subnets][subnet] for each layer. SAP application layers are deployed on Azure Virtual Machines (VMs) to connect to the HANA database layer residing on large instances.

- **HLI Revision 4.5 network**. As of July 2021, the updated revision of the HLI Rev 4 is available. This updated implementation [rev4.5] includes many improvements in the infrastructure, such as  100Gb/s networking for the NFS storage and better network redundancy of the DB server. In this design, the HLI servers are deployed in Azure datacenters in close physical proximity to the Azure VMs where the SAP application servers are running. When used in conjunction with an [ExpressRoute FastPath][fastpath] configuration, Rev 4.5 elevates application performance. These networking features also support the Rev 3 and Rev 4 deployments.

- **Virtual machines (VMs)**. VMs are used in the SAP application layer and shared services layer. The latter includes a jump box used by administrators to set up HANA Large Instances and to provide access to other VMs. To colocate the SAP application servers in the same datacenter with the HANA Large Instance units, use [proximity placement groups][ppg].

- **HANA Large Instance**. This [physical server][physical] is certified to meet SAP HANA Tailored Datacenter Integration (TDI) standards for running SAP HANA. This architecture uses two HANA Large Instances: a primary and a secondary compute unit. High availability at the data layer is provided through HANA System Replication (HSR).

- **High Availability Pair**. A group of HANA Large Instances blades are managed together to provide database redundancy and reliability.

- **Microsoft Enterprise Edge (MSEE)**. MSEE is a connection point from a connectivity provider or your network edge through an ExpressRoute circuit.

- **Network interface cards (NICs)**. To enable communication, the HANA Large Instance server provides four virtual NICs by default. This architecture requires one NIC for client communication, a second NIC for the node-to-node connectivity needed by HSR, a third NIC for HANA Large Instance storage, and a fourth for iSCSI used in high availability clustering.

- **Network File System (NFS) storage**. The [NFS][nfs] server supports the network file share that provides secure data persistence for HANA Large Instance.

- **ExpressRoute**. [ExpressRoute][expressroute] is the recommended Azure networking service for creating private connections between an on-premises network and Azure VNets that do not go over the public internet. Azure VMs connect to HANA Large Instances using another ExpressRoute connection. The ExpressRoute connection between the Azure VNet and the HANA Large Instances is set up as part of the Microsoft offering.

- **Gateway**. The ExpressRoute Gateway is used to connect the Azure VNet used for the SAP application layer to the HANA Large Instance network. Use the [High Performance or Ultra Performance][sku] SKU.

- **Disaster recovery (DR)**. Options for DR include HANA System Replication (HSR), HANA file backup and restore, or storage replication. Upon request, the Microsoft Service Management team can configure the storage servers and volumes. You are responsible for scheduling the storage snapshot, testing the system, and getting familiar with the recovery process. Other considerations apply to the application tier for [SAP NetWeaver][netweaver] and [SAP S/4HANA][s4hana] on Azure.

## Recommendations

Requirements can vary, so use these recommendations as a starting point.

### HANA Large Instances compute

[HANA Large Instances][physical] are physical servers based on the Intel Broadwell and Cascade Lake CPU architecture and configured in a large instance stamp&mdash;that is, a specific set of servers or blades. A compute unit equals one server or blade, and a stamp is made up of multiple servers or blades. Within a large instance stamp, servers are not shared and are dedicated to running one customer's deployment of SAP HANA.

A variety of [SKUs are available for HANA Large Instances][skus], supporting up to 24 TB single instance (120 TB scale-out) of memory for BW/4HANA or other SAP HANA workloads.

Choose a SKU that fulfills the sizing requirements you determined in your architecture and design sessions. Always ensure that your sizing applies to the correct SKU. Capabilities and deployment requirements [vary by type][type], and availability varies by region. You can also step up from one SKU to a larger SKU.

Microsoft helps establish the large instance setup, but it is your responsibility to verify the operating system's configuration settings. Make sure to review the most current SAP Notes for your exact Linux release.

### Storage

Storage layout is implemented according to the recommendation of the TDI for SAP HANA. HANA Large Instances come with a specific storage configuration for the standard TDI specifications. However, you can purchase additional storage in 1 TB increments.

To support the requirements of mission-critical environments including fast recovery, NFS is used and not direct attached storage. The NFS storage server for HANA Large Instances is hosted in a multi-tenant environment, where tenants are segregated and secured using compute, network, and storage isolation.

To support high availability at the primary site, use different storage layouts. For example, in a multi-host scale-out, the storage is shared. Another high availability option is application-based replication, such as HSR. For DR, however, a snapshot-based storage replication is used.

### Networking

This architecture uses both virtual and physical networks. The virtual network is part of Azure infrastructure as a service (IaaS) and connects to a discrete HANA Large Instances physical network through [ExpressRoute][expressroute] circuits. A cross-premises gateway connects your workloads in the Azure VNet to your on-premises sites.

All HANA Large Instance deployments since July 2019 use Rev 4 stamps, which are deployed in close proximity to the Azure VM hosts used for the SAP application servers. As a result, Rev 4 deployment minimizes network latency between the application and database layers.

HANA Large Instances networks are isolated from each other for security. Instances residing in different regions do not communicate with each other, except for the dedicated storage replication. However, to use HSR, inter-region communications are required. [Azure Global Reach][globalreach], [IP routing tables][ip], or proxies can be used to enable cross-regions HSR.

All Azure VNets that connect to HANA Large Instances in one region can be [cross-connected][cross-connected] via ExpressRoute to HANA Large Instances in a secondary region.

The ExpressRoute circuit for HANA Large Instances is included by default during provisioning. For setup, a specific network layout is needed, including required Classless Inter-Domain Routing (CIDR) address ranges and domain routing. For details, see [SAP HANA (large instances) infrastructure and connectivity on Azure][HLI-infrastructure].

To lower network latency and improve performance, consider enabling FastPath (also referred to as MSEE v2). This network configuration allows traffic from on-premises to the Azure VNet, and from the VNet to HANA Large Instances, to bypass the Azure gateway.

## Considerations

### Scalability

To scale up or down, you can choose from many sizes of servers that are available for HANA Large Instances. They are categorized as [Type I and Type II][classes] and tailored for different workloads. Choose a size that can grow with your workload for the next three years. One-year commitments are also available.

A multi-host, scale-out deployment is generally used for BW/4HANA deployments as a kind of database partitioning strategy. As of this writing, BW/4HANA on HANA Large Instances can scale out to 120 TB. To scale out, plan the placement of HANA tables prior to installation. From an infrastructure standpoint, multiple hosts are connected to a shared storage volume, enabling quick takeover by standby hosts in case one of the compute worker nodes in the HANA system fails.

S/4HANA and SAP Business Suite on HANA on a single blade can scale up to 24 TB with a single-instance node. HANA Large Instances and the Azure storage infrastructure also support S/4HANA and BW/4HANA scale-out deployments. For specific SKUs that are certified for scale-out, please consult the [SAP certified hardware directory][directory].

Memory requirements for HANA increase as data volume grows. Use your system's current memory consumption as the basis for predicting future consumption, and then map your demand into one of the HANA Large Instances sizes.

If you already have SAP deployments, SAP provides reports you can use to check the data used by existing systems and calculate memory requirements for a HANA instance. For example, see the following SAP Notes (access requires an SAP Service Marketplace account):

- SAP Note [1793345][sap-1793345] - Sizing for SAP Suite on HANA
- SAP Note [1872170][sap-1872170] - Suite on HANA and S/4 HANA sizing report
- SAP Note [2121330][sap-2121330] - FAQ: SAP BW on HANA Sizing Report
- SAP Note [1736976][sap-1736976] - Sizing Report for BW on HANA
- SAP Note [2296290][sap-2296290] - New Sizing Report for BW on HANA

### Availability

Resource redundancy is the general theme in highly available infrastructure solutions. Work with SAP, your system integrator, or Microsoft to properly architect and implement a [high availability and disaster-recovery][hli-hadr] strategy. This architecture follows the Azure [service level agreement][sla] (SLA) for HANA on Azure (Large Instances). To assess your availability requirements, consider any single points of failure, the desired level of uptime for services, and these common metrics:

- Recovery Time Objective (RTO) means the duration of time in which the HANA Large Instances server is unavailable.

- Recovery Point Objective (RPO) means the maximum tolerable period in which customer data might be lost due to a failure.

For high availability, deploy more than one instance in a HA pair and use HSR in a synchronous mode to minimize data loss and downtime. In addition to a local, two-node high availability setup, HSR supports multi-tier replication, where a third node in a separate Azure region registers to the secondary replica of the clustered HSR pair as its replication target. This forms a replication daisy chain.

The failover to the DR node is a manual process without Linux clustering. For automatic fault detection and failover, you can configure Pacemaker to further lower downtime caused by software or hardware failure. Beginning with HANA 2.0 SPS 04, HSR also supports multi-target replication. Instead of a daisy chain, this form of replication has one primary and multiple secondary subscribers.

When you set up HANA Large Instances HSR with automatic failover, you can request the Microsoft Service Management team to set up a [STONITH device][stonith] for your HANA Large Instances servers.

### Disaster recovery

This architecture supports [disaster recovery][hli-dr] between HANA Large Instances in different Azure regions. There are two ways to support DR with HANA Large Instances:

- Storage replication. The primary storage contents are constantly replicated to the remote DR storage systems that are available on the designated DR HANA Large Instances server. In storage replication, the HANA database is not loaded into memory. This DR option is simpler from an administration perspective. To determine if this is a suitable strategy, consider the database load time against the availability SLA. Storage replication also enables you to perform point-in-time recovery. If multi-purpose (cost-optimized) DR is set up, you must purchase additional storage of the same size at the DR location. Microsoft provides self-services [storage snapshot and failover scripts][scripts] for HANA failover as part of the HANA Large Instances offering.

- Multi-tier or multi-target HSR with a third replica in the DR region (where the HANA database is loaded onto memory). This option supports a faster recovery time but does not support a point-in-time recovery. HSR requires a secondary system. HANA system replication traffic destined for the DR site can be routed through proxies such as nginx or IP tables. Alternatively, Global Reach can be used to link the ExpressRoute circuits together, enabling permitted users to connect to HANA Large Instances unit directly.

### Cost optimization

Use the [Azure pricing calculator][azure-pricing-calculator] to estimate costs.

For more information, see the cost section in [Microsoft Azure Well-Architected Framework][aaf-cost].

SKUs can affect the billing model. Here are some cost considerations.

#### Virtual machines

In this reference architecture, virtual machines are used for hosting SAP applications, SAP services, and shared services such as management jump boxes. There are certain certified SKUs of HANA Large Instances. The configurations depend on the workload, CPU resources, desired memory, and budget.

[HANA Large Instances SKUs][HLI-SKUs] are available as reserved VM instances. [Azure Reservations](/azure/cost-management-billing/reservations/save-compute-costs-reservations) can lower your cost if you can commit to one-year or three-year term. VM reservations can reduce costs up to 72 percent when compared to pay-as-you-go prices. You get a purpose-built SAP HANA infrastructure with compute, storage, and network. HANA Large Instances is coupled with NFS storage and networking and provides built-in support for backups through storage snapshots, high availability and disaster recovery and scale-out configurations. If your workload doesn't have a predictable time of completion or resource consumption, consider the pay-as-you-go option.

Use [Azure savings plan overview](https://azure.microsoft.com/pricing/offers/savings-plan-compute/#benefits-and-features) and combine with Azure Reservations. Azure savings plan is a flexible cost-saving plan that generates significant savings off pay-as-you-go prices. You agree to a one-year or three-year contract and receive discounts on eligible compute services. Savings apply to these compute services regardless of the region, instance size, or operating system. For more information, see [Azure savings plan documentation](/azure/cost-management-billing/savings-plan/savings-plan-compute-overview).

Use [Azure Spot VMs][az-spot-vms] to run workloads that can be interrupted and do not require completion within a predetermined time frame or an SLA.

For more information, see the "SAP HANA on Azure Large Instances" section in [HLI for SAP HANA Virtual Machines Pricing][HLI-vms-pricing].

#### Azure ExpressRoute

For this architecture, Azure ExpressRoute is used as the networking service for creating private connections between an on-premises network and Azure virtual networks. Azure VMs connect to HANA Large Instances using another ExpressRoute connection and an ExpressRoute Gateway.  [High Performance or Ultra Performance][sku] is the recommended SKU.

All inbound data transfer is free. All outbound data transfer is charged based on a pre-determined rate. For more information, see [Azure ExpressRoute pricing][expressroute-pricing].

> [!NOTE]
> You can optimize this reference architecture for cost by running irunning one or multiple HANA containers in one HANA Large Instances blade. This setup is suitable for nonproduction HANA workloads.

### Backup

Based on your business requirements, choose from several options available.

| Backup option                   | Pros                                                                                                   | Cons                                                       |
|---------------------------------|--------------------------------------------------------------------------------------------------------|------------------------------------------------------------|
| HANA backup        | Native to SAP. Built-in consistency check.                                                             | Long backup and recovery times. Storage space consumption. |
| HANA snapshot      | Native to SAP. Rapid backup and restore.                                                               |                                       |
| [Storage snapshot][snapshot]   | Included with HANA Large Instances. Optimized DR for HANA Large Instances. Boot volume backup support. | Maximum 254 snapshots per volume.                          |
| Log backup         | Combined with full HANA data backup, offers point in time recovery.                                                                   |                                                            |
| Other backup tools | Redundant backup location.                                                                             | Additional licensing costs.                                |

For details about a do-it-yourself approach to backup and more options provided with HANA Large Instances, see the [Backup and restore][backup-restore] article.

### Manageability

[Monitor HANA Large Instances resources][monitor]&mdash;such as CPU, memory, network bandwidth, and storage space&mdash;using SAP HANA Studio, SAP HANA Cockpit, SAP Solution Manager, and other native Linux tools. HANA Large Instances [Type I SKUs][typei-sku] don't come with built-in monitoring tools. Type II SKUs offers prebuilt diagnostic tools for system activity logging and troubleshooting.

Microsoft offers basic tools and resources to help you [monitor HANA Large Instances][monitor] on Azure. The Microsoft support team can also assist you in troubleshooting technical issues.

### Security

- Since the end of 2018, [HANA Large Instances storage][storage] is encrypted by default.

- Data in transit between HANA Large Instances and theVMs is not encrypted. To encrypt the data transfer, enable the application-specific encryption. See SAP Note [2159014][sap-2159014] - FAQ: SAP HANA Security.

- Isolation provides security between the tenants in the multi-tenant HANA Large Instance environment. Tenants are isolated using their own VLAN.

- [Azure network security best practices][network-best-practices] provide helpful guidance.

- As with any deployment, [operating system hardening][os-hardening] is recommended, including hardening the SUSE Linux image for SAP on Azure.

- For physical security, access to Azure datacenters is limited to authorized personnel only. No customers can access the physical servers.

For more information, see [SAP HANA Security&mdash;An Overview][sap-security]. (An SAP Service Marketplace account is required for access.)

## Communities

Communities can answer questions and help you set up a successful deployment. Consider the following:

- [Running SAP Applications on the Microsoft Platform Blog][running-sap-blog]
- [Stack Overflow SAP][stack-overflow]

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.* 

Principal author: 

 - [Ben Trinh](https://www.linkedin.com/in/bentrinh/) | Principal Architect
 
*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Related resources

You may wish to review the following [Azure example scenarios](/azure/architecture/example-scenario) that demonstrate specific solutions using some of the same technologies:

- [Running SAP production workloads using an Oracle Database on Azure](../../example-scenario/apps/sap-production.yml)
- [Dev/test environments for SAP workloads on Azure](../../example-scenario/apps/sap-dev-test.yml)

<!-- links -->

[aaf-cost]: /azure/architecture/framework/cost/overview
[az-spot-vms]: /azure/virtual-machines/windows/spot-vms
[azure-forum]: https://azure.microsoft.com/support/forums
[classes]: /azure/virtual-machines/workloads/sap/hana-overview-architecture
[azure-pricing-calculator]: https://azure.microsoft.com/pricing/calculator
[cross-connected]: /azure/virtual-machines/workloads/sap/hana-overview-high-availability-disaster-recovery#network-considerations-for-disaster-recovery-with-hana-large-instances
[dr-site]: /azure/virtual-machines/workloads/sap/hana-overview-high-availability-disaster-recovery
[expressroute]: ../../reference-architectures/hybrid-networking/expressroute.yml
[expressroute-pricing]: https://azure.microsoft.com/pricing/details/expressroute
[hli-dr]: /azure/virtual-machines/workloads/sap/hana-overview-high-availability-disaster-recovery#network-considerations-for-disaster-recovery-with-hana-large-instances
[hli-backup]: /azure/virtual-machines/workloads/sap/hana-backup-restore
[hli-hadr]: /azure/virtual-machines/workloads/sap/hana-overview-high-availability-disaster-recovery
[hli-infrastructure]: /azure/virtual-machines/workloads/sap/hana-overview-infrastructure-connectivity
[HLI-SKUs]: /azure/virtual-machines/workloads/sap/hana-available-skus
[hli-troubleshoot]: /azure/virtual-machines/workloads/sap/troubleshooting-monitoring
[HLI-vms-pricing]: https://azure.microsoft.com/pricing/details/virtual-machines/linux
[ip]: /archive/blogs/saponsqlserver/setting-up-hana-system-replication-on-azure-hana-large-instances
[monitor]: /azure/virtual-machines/workloads/sap/troubleshooting-monitoring
[netweaver]: /azure/architecture/guide/sap/sap-netweaver
[network-best-practices]: /azure/security/azure-security-network-security-best-practices
[nfs]: /azure/virtual-machines/workloads/sap/high-availability-guide-suse-nfs
[os-hardening]: /azure/security/azure-security-iaas
[physical]: /azure/virtual-machines/workloads/sap/hana-overview-architecture
[planning]: /azure/vpn-gateway/vpn-gateway-plan-design
[protecting-sap]: /archive/blogs/saponsqlserver/protecting-sap-systems-running-on-vmware-with-azure-site-recovery
[ppg]: /azure/virtual-machines/linux/co-location
[ref-arch]: /azure/architecture/reference-architectures/
[running-SAP]: https://blogs.msdn.microsoft.com/saponsqlserver/2016/06/07/sap-on-sql-general-update-for-customers-partners-june-2016/
[region]: https://azure.microsoft.com/global-infrastructure/services/
[running-sap-blog]: /archive/blogs/saponsqlserver/sap-on-azure-general-update-for-customers-partners-april-2017
[quick-sizer]: https://service.sap.com/quicksizing
[rev4]: /azure/virtual-machines/workloads/sap/hana-overview-architecture
[sap-1793345]: https://launchpad.support.sap.com/#/notes/1793345
[sap-1872170]: https://launchpad.support.sap.com/#/notes/1872170
[sap-2121330]: https://launchpad.support.sap.com/#/notes/2121330
[sap-2159014]: https://launchpad.support.sap.com/#/notes/2159014
[sap-1736976]: https://launchpad.support.sap.com/#/notes/1736976
[sap-2296290]: https://launchpad.support.sap.com/#/notes/2296290
[sap-community]: https://www.sap.com/community.html
[sap-security]: https://www.tutorialspoint.com/sap_hana/sap_hana_security_overview.htm
[scenarios]: /azure/virtual-machines/workloads/sap/hana-supported-scenario
[scripts]: /azure/virtual-machines/workloads/sap/hana-overview-high-availability-disaster-recovery
[s4hana]: /azure/architecture/guide/sap/sap-s4hana
[sku]: /azure/expressroute/expressroute-about-virtual-network-gateways
[skus]: /azure/virtual-machines/workloads/sap/hana-available-skus
[sla]: https://azure.microsoft.com/support/legal/sla/virtual-machines
[snapshot]: https://github.com/Azure/hana-large-instances-self-service-scripts
[stack-overflow]: https://stackoverflow.com/tags/sap/info
[stonith]: /azure/virtual-machines/workloads/sap/ha-setup-with-stonith
[storage]: /azure/virtual-machines/workloads/sap/hana-storage-architecture
[subnet]: /azure/virtual-network/virtual-network-manage-subnet
[type]: /azure/virtual-machines/workloads/sap/hana-installation
[typei-sku]: /azure/virtual-machines/workloads/sap/hana-know-terms
[vnet]: /azure/virtual-network/virtual-networks-overview
[visio-download]: https://arch-center.azureedge.net/sap-reference-architectures.vsdx

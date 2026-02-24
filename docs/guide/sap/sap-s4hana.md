---
title: SAP S/4HANA in Linux on Azure
description: Learn more about proven practices for running SAP S/4HANA effectively in a Linux environment on Azure with high availability.
author: bqtrinh
ms.author: bentrin
ms.date: 02/24/2026
ms.topic: concept-article
ms.subservice: architecture-guide
---

<!-- cSpell:ignore HANA Fiori -->

# SAP S/4HANA in Linux on Azure

This guide presents a set of proven practices for running S/4HANA and Suite on HANA in a high availability (HA) environment that supports disaster recovery (DR) on Azure. The Fiori information applies only to S/4HANA applications.

## Key terminology

- **HA**: High Availability
- **DR**: Disaster Recovery
- **HANA**: High-performance ANalytic Appliance
- **HSR**: HANA System Replication
- **ASCS**: ABAP SAP Central Services
- **NFS**: Network File System
- **SLES**: SUSE Linux Enterprise Server
- **RHEL**: Red Hat Enterprise Linux
- **FES**: Fiori Front-End Server
- **NSG**: Network Security Group
- **NVA**: Network Virtual Appliance
- **ADE**: Azure Disk Encryption

## Architecture

:::image type="complex" border="false" source="media/s-4hana.svg" alt-text="Architecture diagram that shows SAP S/4HANA for Linux virtual machines in an Azure availability set." lightbox="media/s-4hana.svg":::
   The image contains two large rectangles labeled Region 1 (primary region) and Region 2 (secondary region). Inside Region 1 are two sections. The first section is labeled Hub virtual network. This section has a rectangle labeled Gateway subnet and a rectangle labeled Shared services subnet. An external on-premises network connects to the gateway subnet via a solid arrow labeled ExpressRoute. The Gateway subnet rectangle contains an icon that represents a zone-redundant gateway. The Shared services subnet rectangle contains an icon that represents Azure Bastion. The second section in Region 1 is labeled Spoke virtual network. It has two sections. The first section is labeled Application layer subnet. This section has four rectangles labeled SAP Web Dispatcher pool, SAP Central Services cluster, SAP app servers pool, and NFS/Azure Files shares ZRS. The first three components are grouped together and connect to a virtual machine in region 2. NFS/Azure Files shares ZRS connects to a cloud folder icon in region 2. The second section is labeled Database layer subnet. It has text that reads HANA replication and an icon that represents Load Balancer. A dotted arrow points from here to a rectangle in Region 2 labeled Database replica.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/s-4hana.vsdx) of this architecture.*

> [!NOTE]
> To deploy this architecture, ensure that you have the necessary licensing for SAP products and any other non-Microsoft technologies.

This guide describes a typical production system. This architecture uses various virtual machine (VM) sizes. To accommodate the needs of your organization, you can adjust the sizes or reduce this configuration to a single VM.

In this guide, the network layout is simplified to demonstrate architectural principles. It doesn't represent a complete enterprise network.

The architecture uses the following components. Some shared services are optional.

**Azure Virtual Network.** The [Virtual Network](/azure/virtual-network/virtual-networks-overview) service connects Azure resources to each other with enhanced security. In this architecture, a virtual network connects to an on-premises environment through a gateway that's deployed in the hub of a [hub-spoke topology](/azure/architecture/networking/architecture/hub-spoke). The spoke is the virtual network that's used for the SAP applications and the database tiers.

**Virtual network peering.** This architecture uses [multiple virtual networks that are peered together](/azure/virtual-network/virtual-network-peering-overview). This topology provides network segmentation and isolation for services that are deployed on Azure. Peering connects networks transparently through the Microsoft backbone network and doesn't incur a performance penalty if it's implemented within a single region. Separate subnets are used for each tier, including the application tier (SAP NetWeaver) and the database tier, and for shared components such as the jump box and Windows Server Active Directory.

**VMs.** This architecture organizes VMs that run Linux into groups for the application tier and the database tier in the following ways:

- **Application tier.** This architectural layer includes the Fiori front-end server pool, the SAP Web Dispatcher pool, the application server pool, and the SAP Central Services cluster. For HA of Central Services on Azure that run in Linux VMs, a highly available network file share service is required, such as [Network File System (NFS) file shares in Azure Files](/azure/virtual-machines/workloads/sap/high-availability-guide-suse-nfs-azure-files), [Azure NetApp Files](/azure/virtual-machines/workloads/sap/high-availability-guide-suse-netapp-files), clustered NFS servers, or [SIOS Protection Suite for Linux](https://us.sios.com/solutions/sap-high-availability). To set up a highly available file share for the Central Services cluster on Red Hat Enterprise Linux (RHEL), you can configure [GlusterFS](/azure/virtual-machines/workloads/sap/high-availability-guide-rhel-glusterfs) on Azure VMs that run RHEL. On SUSE Linux Enterprise Server (SLES) 15 SP1 and later versions or SLES for SAP Applications, you can use [Azure shared disks](/azure/virtual-machines/disks-shared#linux) on a Pacemaker cluster as a fencing device to achieve HA.

- **SAP HANA.** The database tier uses two or more Linux VMs in a cluster to achieve HA in a scale-up deployment. HANA system replication (HSR) is used to replicate contents between primary and secondary HANA systems. Linux clustering is used to detect system failures and facilitate automatic failover. You must use a storage-based or cloud-based fencing mechanism to help ensure that the failed system is isolated or shut down to avoid a partitioned cluster. In HANA scale-out deployments, you can achieve database HA by using one of the following options:

  - Configure HANA standby nodes by using Azure NetApp Files without the Linux clustering component.

  - Scale out without standby nodes by using Azure premium storage. Use Linux clustering for failover.

- **Azure Bastion.** This service lets you connect to a VM by using your browser and the Azure portal or by using the native Secure Shell (SSH) or Remote Desktop Protocol (RDP) client that's installed on your local computer. If only RDP and SSH are used for administration, consider using [Azure Bastion](/azure/bastion/bastion-overview). If you use other management tools, like SQL Server Management Studio or an SAP front end, use a traditional self-deployed jump box.

**Private DNS service.** [Azure Private DNS](/azure/dns/private-dns-overview) provides a reliable and secure DNS service for your virtual network. Azure Private DNS manages and resolves domain names in the virtual network without the need to configure a custom DNS solution.

**Load balancers.** To distribute traffic to VMs in the SAP application tier subnet to increase availability, use [Azure Standard Load Balancer](/azure/load-balancer/load-balancer-standard-availability-zones). Standard Load Balancer provides a layer of security by default. VMs that are behind Standard Load Balancer don't have outbound internet connectivity. To enable outbound internet on the VMs, you need to update your [Standard Load Balancer configuration](/azure/virtual-machines/workloads/sap/high-availability-guide-standard-load-balancer-outbound-connections). You can also use [Azure NAT Gateway](/azure/nat-gateway/nat-overview) to get outbound connectivity. For SAP web-based application HA, use the built-in [SAP Web Dispatcher](https://help.sap.com/doc/saphelp_nw74/7.4.16/48/9a9a6b48c673e8e10000000a42189b/content.htm?no_cache=true) or another commercially available load balancer. Base your selection on:

- Your traffic type, such as HTTP or SAP graphical user interface (GUI) traffic.
- The network features that you need, such as Secure Sockets Layer (SSL) termination.

Standard Load Balancer supports multiple front-end virtual IP addresses. This support is ideal for cluster implementations that include the following components:

- Advanced Business Application Programming (ABAP) SAP Central Services (ASCS)
- Enqueue replication server

These two components can share a load balancer to simplify the solution.

Standard Load Balancer also supports multiple-system identifier (multi-SID) SAP clusters. This feature allows multiple SAP systems on [SLES](/azure/virtual-machines/workloads/sap/high-availability-guide-suse-multi-sid) or [RHEL](/azure/virtual-machines/workloads/sap/high-availability-guide-rhel-multi-sid) to share a common HA infrastructure to help reduce costs. We recommend that you evaluate the cost savings and avoid placing too many systems in one cluster. Azure supports up to five SIDs per cluster.

**Application gateway.** Azure Application Gateway is a web traffic load balancer that you can use to manage the traffic to your web applications. Traditional load balancers operate at the transport layer, known as Open Systems Interconnection (OSI) layer 4, by using Transmission Control Protocol and User Datagram Protocol. They route traffic based on the source IP address and port to a destination IP address and port. Application Gateway can make routing decisions based on extra attributes of an HTTP request, such as the uniform resource identifier path or host headers. This type of routing is known as application layer, or OSI layer 7, load balancing. S/4HANA provides web application services through Fiori. You can load balance this Fiori front end, which consists of web apps, by using Application Gateway. If you use public IP addresses, you must use the Standard IP address SKU  because the Basic IP address SKU has been retired as of late 2025.

**Gateway.** A gateway connects distinct networks and extends your on-premises network to an Azure virtual network. [Azure ExpressRoute](../../reference-architectures/hybrid-networking/expressroute-vpn-failover.yml) is the recommended Azure service for creating private connections that don't go over the public internet. You can also use a [site-to-site](/azure/expressroute/expressroute-howto-coexist-resource-manager) connection. To help reduce latency, use [ExpressRoute Global Reach](/azure/expressroute/expressroute-global-reach) or [ExpressRoute FastPath](/azure/expressroute/about-fastpath).

**Zone-redundant gateway.** You can deploy ExpressRoute or virtual private network (VPN) gateways across zones to guard against zone failures. This architecture uses [zone-redundant](/azure/vpn-gateway/about-zone-redundant-vnet-gateways) virtual network gateways for resiliency instead of a zonal deployment that's based on the same availability zone.

**Proximity placement group.** This logical group places a constraint on VMs that are deployed in an availability set or a virtual machine scale set. A [proximity placement group](/azure/virtual-machines/workloads/sap/sap-proximity-placement-scenarios) helps enforce colocation by ensuring that VMs are deployed in the same datacenter. This configuration reduces physical distance between resources to minimize application latency.

> [!NOTE]
> For an updated configuration strategy, see [Configuration options to minimize network latency with SAP applications](/azure/sap/workloads/proximity-placement-scenarios). This article describes the potential trade-offs in deployment flexibility when you optimize an SAP system for network latency.

**Network security groups (NSGs).** To restrict incoming, outgoing, and intra-subnet traffic in a virtual network, you can create [NSGs](/azure/virtual-network/security-overview).

**Application security groups.** To define fine-grained network security policies that are based on workloads and centered on applications, use [application security groups](/azure/virtual-network/security-overview#application-security-groups) instead of explicit IP addresses. You can group VMs by name and secure applications by filtering traffic from trusted segments of your network.

**Azure Storage.** Storage provides data persistence for a VM in the form of a virtual hard disk. We recommend that you use [Azure managed disks](/azure/virtual-machines/windows/managed-disks-overview).

## Recommendations

This architecture describes a small, production-level deployment. Deployments vary based on business requirements, so consider these recommendations as a starting point.

### VMs

In application server pools and clusters, adjust the number of VMs based on your requirements. For more information about how to run SAP NetWeaver on VMs, see [Azure Virtual Machines planning and implementation guide](/azure/virtual-machines/workloads/sap/planning-guide). The guide also applies to SAP S/4HANA deployments.

For more information about SAP support for Azure VM types and for throughput metrics, see [SAP note 1928533](https://launchpad.support.sap.com/#/notes/1928533). To access SAP notes, you need an SAP Service Marketplace account. For a list of certified Azure VMs for the HANA database, see [SAP certified and supported SAP HANA hardware directory](https://www.sap.com/dmc/exp/2014-09-02-hana-hardware/enEN/index.html).

### SAP Web Dispatcher

The Web Dispatcher component is used for load balancing SAP traffic among the SAP application servers. To achieve [HA of SAP Web Dispatcher](https://help.sap.com/doc/saphelp_nw74/7.4.16/48/9a9a6b48c673e8e10000000a42189b/content.htm?no_cache=true), Azure Load Balancer implements either a failover cluster or the parallel Web Dispatcher setup. For internet-facing communications, a stand-alone solution in the perimeter network is the recommended architecture to address security requirements. [Embedded Web Dispatcher on ASCS](https://help.sap.com/docs/SLTOOLSET/23fb4d5eb15b421fa17e60f444b4b0da/2e708e2d42134b4baabdfeae953b24c5.html?version=CURRENT_VERSION) is an advanced configuration. If you use this configuration, consider proper sizing because of the extra workload on ASCS.

### Fiori front-end server (FES)

This architecture meets multiple requirements and assumes that you use the embedded Fiori FES model. All the technology components are installed directly on the S/4 system, so each S/4 system has its own Fiori launchpad. The S/4 system manages the HA configuration for this deployment model. This approach removes the need for extra clustering or VMs. For this reason, the architecture diagram doesn't include the FES component.

For more information about deployment options, see [SAP Fiori deployment options and system landscape recommendations](https://www.sap.com/documents/2018/02/f0148939-f27c-0010-82c7-eda71af511fa.html). For simplicity and performance, the software releases between the Fiori technology components and the S/4 applications are tightly coupled. This setup makes a hub deployment suitable for only a few, specific use cases.

If you use the FES hub deployment, the FES is an add-on component to the classic SAP NetWeaver ABAP stack. Set up HA the same way that you protect a three-tier ABAP application stack that has clustered or multiple-host capability. Use a standby server database layer, a clustered ASCS layer with HA NFS for shared storage, and at least two application servers. Traffic is load balanced via a pair of Web Dispatcher instances that can be either clustered or parallel. For internet-facing Fiori apps, we recommend an [FES hub deployment](https://blogs.sap.com/2017/12/15/considerations-and-recommendations-for-internet-facing-fiori-apps) in the perimeter network. Use Azure Web Application Firewall on [Application Gateway](/azure/application-gateway) as a critical component to deflect threats. Use [Microsoft Entra ID with Security Assertion Markup Language](/entra/identity/saas-apps/sap-netweaver-tutorial) for user authentication and [single sign-on for SAP Fiori](/entra/identity/saas-apps/sap-fiori-tutorial).

:::image type="complex" border="false" source="media/fiori.svg" alt-text="Architecture diagram that shows the data flow between the internet and two virtual networks, one with SAP Fiori and one with SAP S/4HANA." lightbox="media/fiori.svg":::
   The image shows two main sections enclosed in dotted rectangles that indicate that they're both virtual networks. There's an icon that represents the internet. This icon connects via a two-sided arrow to an icon that represents web navigation in the first section. This section has three rectangles. The first rectangle has icons that represent Azure Web Application Firewall and Azure Application Gateway. The second rectangle has icons that represent SAP Web Dispatcher instances. The third section has an icon that represents SAP Fiori. It also has text that reads Hub Fiori or central Fiori. Arrows point from the first box to the second box and then from the second box to the third box. A dotted arrow labeled Virtual network peering connects the two virtual networks. The second main section has an icon that represents SAP S/4HANA and contains text that reads Dedicated back end or embedded Fiori.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/fiori.vsdx) of this architecture.*

For more information, see [Inbound and outbound internet connections for SAP on Azure](./sap-internet-inbound-outbound.yml).

### Application servers pool

To manage logon groups for ABAP application servers, use the following SAP transaction codes:

| Transaction Code | Purpose | Function |
|------------------|---------|----------|
| **SMLG** | Logon load balancing | Distribute user logons across application servers |
| **SM61** | Batch server groups | Manage batch job processing distribution |
| **RZ12** | RFC groups | Manage Remote Function Call load balancing |

These transactions rely on the load-balancing capability in the Central Services message server to distribute incoming sessions and workloads across the pool of SAP application servers that manage SAP GUI and RFC traffic.

### SAP Central Services cluster

The SAP Central Services contain a single instance of the message server and the enqueue replication service. Unlike the work processes of application servers, these components are single points of failure in the SAP application stack. You can deploy Central Services to a single VM when the Azure single-instance VM availability service-level agreement (SLA) meets your requirement. If your SLA requires higher availability, you need to deploy these services on an HA cluster. For more information, see [Central Services in the application servers tier](#central-services-in-the-application-servers-tier).

### Networking

This architecture uses a hub-spoke topology where the hub virtual network serves as a central point of connectivity to an on-premises network. The spokes are virtual networks that peer with the hub. You can use the spokes to isolate workloads. Traffic flows between the on-premises datacenter and the hub through a gateway connection.

### Network interface cards

Traditional on-premises SAP deployments implement multiple network interface cards (NICs) per machine to segregate administrative traffic from business traffic. On Azure, the virtual network is a software-defined network that routes all traffic through a single network fabric. As a result, you don't need multiple NICs for performance reasons. If your organization needs to segregate traffic, you can deploy multiple NICs for each VM, connect each NIC to a different subnet, then use NSGs to help enforce different access control policies.

Azure NICs support multiple IP addresses. This support aligns with the practice that SAP recommends of using virtual host names for installations in [SAP note
962955](https://launchpad.support.sap.com/#/notes/962955).

### Subnets and NSGs

This architecture divides the virtual network address space into subnets. You can associate each subnet with an NSG that defines the access policies for the subnet. Place application servers on a separate subnet. This approach makes it easier to secure application servers by managing the subnet security policies instead of the individual servers.

When you associate an NSG with a subnet, the NSG applies to all the servers within the subnet and provides fine-grained control over the servers. Set up NSGs by using the [Azure portal](/azure/virtual-network/tutorial-filter-network-traffic?tabs=portal#tabpanel_1_portal), [Azure PowerShell](/azure/virtual-network/tutorial-filter-network-traffic?tabs=powershell#tabpanel_1_powershell), or the [Azure CLI](/azure/virtual-network/tutorial-filter-network-traffic?tabs=cli#tabpanel_1_cli).

### ExpressRoute Global Reach

If your network environment includes two or more ExpressRoute circuits, [ExpressRoute Global Reach](/azure/expressroute/expressroute-global-reach) can help you reduce network hops and reduce latency. This technology is a Border Gateway Protocol route peering that's set up between two or more ExpressRoute circuits to bridge two ExpressRoute routing domains. Global Reach reduces latency when network traffic traverses more than one ExpressRoute circuit. It's available only for private peering on ExpressRoute circuits.

Global Reach doesn't support changes to network access control lists or other attributes. All routes learned by an ExpressRoute circuit, whether from on-premises or Azure, are advertised across circuit peering to other ExpressRoute circuits. We recommend that you set up network traffic filtering on-premises to restrict access to resources.

### FastPath

[FastPath](/azure/expressroute/about-fastpath) implements Microsoft Edge exchanges at the entry point of the Azure network. FastPath reduces network hops for most data packets. As a result, FastPath reduces network latency, improves application performance, and is the default configuration for new ExpressRoute connections to Azure.

For existing ExpressRoute circuits, contact Azure support to activate FastPath.

FastPath doesn't support virtual network peering. If a virtual network connected to ExpressRoute is peered with other virtual networks, traffic from your on-premises network to the other spoke virtual networks is routed through the virtual network gateway. To address this problem, connect all virtual networks directly to the ExpressRoute circuit.

### Load balancers

[SAP Web Dispatcher](https://help.sap.com/viewer/683d6a1797a34730a6e005d1e8de6f22/202110.001/488fe37933114e6fe10000000a421937.html?q=SAP%20Web%20Dispatcher) handles load balancing of HTTP and HTTPS traffic to a pool of SAP application servers. This software load balancer provides application layer services, known as layer 7 in the ISO networking model, that are capable of SSL termination and other offloading functions.

[Load Balancer](https://azure.microsoft.com/blog/azure-load-balancer-new-distribution-mode) is a network transmission layer service (layer 4) that balances traffic by using a five-tuple hash from data streams. The hash is based on a source IP address, source port, destination IP address, destination port, and protocol type. Load Balancer is used in cluster setups to direct traffic to the primary service instance or the healthy node if there's a fault. We recommend that you use [Standard Load Balancer](/azure/load-balancer/load-balancer-standard-overview) for all SAP scenarios. Standard Load Balancer is secure by default, and no VMs behind Standard Load Balancer have outbound internet connectivity. To enable outbound internet in the VMs, you must adjust your [Standard Load Balancer](/azure/virtual-machines/workloads/sap/high-availability-guide-standard-load-balancer-outbound-connections) configuration.

For traffic from SAP GUI clients that connect to an SAP server via the Dynamic Information and Action Gateway (DIAG) protocol or RFC, the Central Services message server balances the load through SAP application server [logon groups](https://wiki.scn.sap.com/wiki/display/SI/ABAP+Logon+Group+based+Load+Balancing). No extra load balancer is needed.

### Storage

#### Storage recommendations by use case

| Use Case | Recommended Storage | Notes | SAP Note Reference |
|----------|--------------------|---------|-----------------|
| **Database tier** | Premium SSD v1, Premium SSD v2, or Ultra Disk | Required for production SAP HANA | [SAP note 2015553](https://launchpad.support.sap.com/#/notes/2015553) |
| **Application servers** | Premium SSD (P4, P6 for cost optimization) | Smaller disks acceptable; no business data hosted | [SAP note 2015553](https://launchpad.support.sap.com/#/notes/2015553) |
| **Shared file systems** | Azure NetApp Files or NFS on Azure Files | For `/hana/shared`, `/sapmnt`, `/saptrans` | - |
| **HA scenarios** | Azure Shared Disk (Premium SSD or Ultra Disk) | For cluster configurations | - |
| **Backup storage** | Cool or Archive tier | Cost-effective long-term retention | - |

**Not supported for SAP:**
- Azure Standard HDD storage
- Azure Standard SSD storage (except specific use cases per SAP note 2015553)

For VM availability SLA details, see [SLAs for online services](https://www.microsoft.com/licensing/docs/view/Service-Level-Agreements-SLA-for-Online-Services?lang=1).

You can use Azure shared disks with Windows Server, SLES 15 SP1 and later, or SLES for SAP. When you use an Azure shared disk in Linux clusters, the Azure shared disk serves as a fencing block device to isolate a failed node. It provides a quorum vote in a cluster network partitioning scenario. This shared disk doesn't have a file system and doesn't support simultaneous writes from multiple cluster member VMs.

Azure NetApp Files has built-in file sharing functionalities for NFS and SMB.

For NFS share scenarios, [Azure NetApp Files](/azure/virtual-machines/workloads/sap/hana-vm-operations-netapp) provides HA for NFS shares that can be used for `/hana/shared`, `/hana/data`, and `/hana/log` volumes. For the availability guarantee, see [SLAs for online services](https://www.microsoft.com/licensing/docs/view/Service-Level-Agreements-SLA-for-Online-Services?lang=1). If you use Azure NetApp Files-based NFS shares for the `/hana/data` and `/hana/log` volumes, you need to use the NFS v4.1 protocol. For the `/hana/shared` volume, the NFS v3 protocol is supported.

For the backup data store, we recommend that you use Azure [cool and archive access tiers](/azure/storage/blobs/access-tiers-overview). These storage tiers are cost-effective ways to store long-lived data that's infrequently accessed. Also, consider using the [Azure NetApp Files Standard tier](/azure/azure-netapp-files/azure-netapp-files-service-levels#supported-service-levels) as a backup target or the [Azure NetApp Files backup option](/azure/azure-netapp-files/backup-introduction). For a managed disk, the recommended backup data tier is the Azure cool or archive access tier.

[Ultra Disk Storage](/azure/virtual-machines/linux/disks-enable-ultra-ssd) and Azure NetApp Files [Ultra tier](/azure/azure-netapp-files/azure-netapp-files-service-levels) significantly reduce disk latency and enhance the performance of critical applications and SAP database servers.

[Premium SSD v2](https://azure.microsoft.com/updates/general-availability-azure-premium-ssd-v2-disk-storage/) is designed for performance-critical workloads like SAP. For more information about this storage solution's benefits and limitations, see [Deploy a Premium SSD v2](/azure/virtual-machines/disks-deploy-premium-v2).

## Performance considerations

SAP application servers communicate constantly with the database servers. For performance-critical applications that run on any database platform, including SAP HANA, enable [Write Accelerator](/azure/virtual-machines/windows/how-to-enable-write-accelerator) for the log volume if you use Premium SSD v1. This approach can improve log-write latency. Premium SSD v2 doesn't use Write Accelerator. Write Accelerator is available for M-series VMs.  

To optimize inter-server communications, use [Accelerated Networking](/azure/virtual-network/accelerated-networking-overview). Most general-purpose and compute-optimized VM instance sizes that have two or more vCPUs support Accelerated Networking. On instances that support hyper-threading, VM instances with four or more vCPUs support Accelerated Networking.

You should optimize the [Linux TCP/IP stack and buffers in the network interface](/azure/virtual-network/virtual-network-tcpip-performance-tuning) to achieve consistent performance. Follow Microsoft recommended settings. For example, you'll adjust items such as:

- Kernel parameters to optimize read and write memory buffers
- Bottleneck bandwidth and round-trip propagation time (BBR) congestion control
- Adjust TCP parameters to bring better consistency and throughput
- NIC ring buffers for TX/RX

For more information about SAP HANA performance requirements, see [SAP note 1943937](https://launchpad.support.sap.com/#/notes/1943937).

To achieve high input/output operations per second (IOPS) and disk bandwidth throughput, follow the common practices for storage volume [performance optimization](/azure/virtual-machines/linux/premium-storage-performance). For example, combining multiple disks to create a striped disk volume can improve your input/output (I/O) performance. Enabling the read cache on storage content that changes infrequently can also speed up your data retrieval. For more information, see [SAP HANA Azure virtual machine storage configurations](/azure/virtual-machines/workloads/sap/hana-vm-operations-storage).

Premium SSD v2 is designed for performance-critical workloads like SAP. Premium SSD v2 is SAP certified and lets you independently size capacity/IOPS/throughput. For more information about its benefits, limitations, and optimal use scenarios, see [Azure managed disk types](/azure/virtual-machines/disks-types#premium-ssd-v2).

[Ultra Disk Storage](/azure/virtual-machines/linux/disks-enable-ultra-ssd) is a new generation of storage that meets intensive IOPS and the transfer bandwidth demands of applications such as SAP HANA. You can dynamically change the performance of ultra disks and independently configure metrics like IOPS and MBps without rebooting your VM. We recommend that you use Ultra Disk Storage instead of Write Accelerator when possible.

Some SAP applications require frequent communication with the database. Because of distance, network latency between the application and database layers can negatively affect application performance. Azure [proximity placement groups](/azure/virtual-machines/workloads/sap/sap-proximity-placement-scenarios) set a placement constraint for VMs that are deployed in availability sets. Within the logical construct of a group, colocation and performance are favored over scalability, availability, and cost. Proximity placement groups can greatly improve the user experience for most SAP applications.

The placement of a network virtual appliance (NVA) between the application and the database layers of any SAP application stack isn't supported. The NVA requires a significant amount of time to process data packets. As a result, it unacceptably slows application performance.

We also recommend that you consider performance when you deploy resources with [availability zones](/azure/virtual-machines/workloads/sap/sap-ha-availability-zones), which can enhance service availability. Consider creating a clear network latency profile between all the zones of a target region. This approach helps you decide on the resource placement for minimum latency between zones. To create this profile, run a test by deploying small VMs in each zone. Recommended tools for the test include
[PsPing](/sysinternals/downloads/psping) and [Iperf](https://sourceforge.net/projects/iperf). After testing, remove these VMs. For a public domain network latency test tool that you can use instead, see [Availability zone latency test](https://github.com/Azure/SAP-on-Azure-Scripts-and-Utilities/tree/master/AvZone-Latency-Test).

Azure NetApp Files has unique performance features that enable real-time tuning to meet the needs of the most demanding SAP environments. For performance considerations when you use Azure NetApp Files, see [Sizing for HANA database on Azure NetApp Files](/azure/virtual-machines/workloads/sap/sap-hana-scale-out-standby-netapp-files-suse#sizing-for-hana-database-on-azure-netapp-files).

## Scalability considerations

### Application layer scaling

At the SAP application layer, Azure provides a wide range of VM sizes for scaling up (vertical) and scaling out (horizontal). For an inclusive list, see **SAP applications on Azure: Supported products and Azure VM types** in [SAP note 1928533](https://launchpad.support.sap.com/#/notes/1928533). More VM types are continually certified, so you can scale up or scale down in the same cloud deployment.

### Database layer scaling

| Configuration | Maximum Size | Use Case | Notes |
|---------------|--------------|----------|-------|
| **Single-node (scale-up)** | 32 TB | Standard OLTP workloads | Simplest configuration |
| **Multi-node (scale-out)** | 96 TB (4 × 32 TB) | Large OLTP workloads | Requires careful planning |
| **Scale-out with standby** | Variable | HA + scalability | Uses Azure NetApp Files |

For more information, see [Certified and supported SAP HANA hardware directory](https://www.sap.com/dmc/exp/2014-09-02-hana-hardware/enEN/#/solutions?filters=iaas;ve:24;range%23c:memorySize%23v:ms17%23v:88c8c3d5-03a8-4fa3-bf07-2ab33f35f444&sort=Latest%20Certification&sortDesc=true).

## Availability considerations

Resource redundancy is the general theme in highly available infrastructure solutions. For single-instance VM availability SLAs for various storage types, see [SLAs for online services](https://www.microsoft.com/licensing/docs/view/Service-Level-Agreements-SLA-for-Online-Services?lang=1). To increase service availability on Azure, deploy VM resources by using Azure Virtual Machine Scale Sets, which provides flexible orchestration, availability zones, and availability sets.

The Azure regional availability sets deployment model is a supported option. However, we recommend that you adopt the virtual machine scale sets with availability zones model for new SAP deployments to enhance availability and increase deployment flexibility.

In this distributed installation of the SAP application, the base installation is replicated to achieve HA. For each layer of the architecture, the HA design varies.

### Deployment approaches

On Azure, SAP workload deployment can be either regional or zonal, depending on the availability and resiliency requirements of the SAP applications.

#### Deployment options comparison

| Deployment Type | Availability SLA | Resilience | Recommended For | Status |
|-----------------|------------------|------------|-----------------|--------|
| **Virtual Machine Scale Sets (Flexible, Zonal)** | Highest | Multi-zone protection | All new deployments | **Recommended** |
| **Virtual Machine Scale Sets (Flexible, Regional)** | High | Single-zone protection | Regions without zones | Supported |
| **Availability Zones** | High | Multi-zone protection | Existing deployments | Supported |
| **Availability Sets** | Medium | Single-zone protection | Legacy deployments | Supported (not recommended for new) |

**Microsoft recommendation:** Use Azure flexible scale set zonal deployment for all new SAP deployments to ensure optimal cloud elasticity and resiliency.

For more information about deployment across zones, within a single zone, and in regions without zones, see [HA architecture and scenarios for SAP NetWeaver](/azure/sap/workloads/sap-high-availability-architecture-scenarios).

### Web Dispatcher in the application servers tier

You can achieve HA by using redundant Web Dispatcher instances. For more information, see [SAP Web Dispatcher](https://help.sap.com/viewer/683d6a1797a34730a6e005d1e8de6f22/202110.001/488fe37933114e6fe10000000a421937.html?q=SAP%20Web%20Dispatcher). The availability level depends on the size of the application that's behind Web Dispatcher. In small deployments that have few scalability concerns, you can colocate Web Dispatcher with the ASCS VMs. This approach helps you save on independent operating system maintenance and gain HA at the same time.

### Central Services in the application servers tier

For HA of Central Services on Azure Linux VMs, use the appropriate HA extension for the selected Linux distribution. It's customary to place the shared file systems on highly available NFS storage by using the SUSE Distributed Replicated Block Device or Red Hat GlusterFS. To provide a highly available NFS and eliminate the need for an NFS cluster, you can use other cost-effective or robust solutions like [NFS over Azure Files](/azure/virtual-machines/workloads/sap/high-availability-guide-suse-nfs-azure-files) or [Azure NetApp Files](/azure/virtual-machines/workloads/sap/high-availability-guide-suse-netapp-files). Azure NetApp Files shares can host the SAP HANA data and log files. This setup enables the [HANA scale-out](/azure/virtual-machines/workloads/sap/sap-hana-scale-out-standby-netapp-files-suse) deployment model with standby nodes, while NFS over Azure Files is good for highly available non-database file sharing.

NFS over Azure Files now supports the highly available file shares for both [SLES](/azure/virtual-machines/workloads/sap/high-availability-guide-suse-nfs-azure-files) and [RHEL](/azure/virtual-machines/workloads/sap/high-availability-guide-rhel-nfs-azure-files). This solution works well for highly available file shares like `/sapmnt` and `/saptrans` in SAP installations.

Azure NetApp Files supports HA of [ASCS on SLES](/azure/virtual-machines/workloads/sap/high-availability-guide-suse-netapp-files). For more information about ASCS on RHEL HA, see [SIOS Protection Suite for Linux](https://us.sios.com/blog/how-to-install-a-sios-protection-suite-for-linux-license-key/).

The improved Azure fence agent is available for both [SUSE](/azure/virtual-machines/workloads/sap/high-availability-guide-suse-pacemaker) and [Red Hat](/azure/virtual-machines/workloads/sap/high-availability-guide-rhel-pacemaker) and provides much faster service failover than the previous version of the agent.

Another fencing option is to use [Azure shared disks](/azure/virtual-machines/disks-shared) for the fencing device. On SLES 15 SP1 or SLES for SAP 15 SP1 and later, you can set up a Pacemaker cluster by using [Azure shared disks](/azure/virtual-machines/disks-shared#linux). This option is simple and doesn't require an open network port like the Azure fence agent.

A recently supported and simpler Pacemaker configuration on SLES 15 and later is [HA SAP NetWeaver with simple mount and NFS on SLES for SAP Applications VMs](/azure/sap/workloads/high-availability-guide-suse-nfs-simple-mount). In this configuration, the SAP file shares are taken out of the cluster management, which makes it simpler to operate. Use this HA configuration for all new deployments.

To further manage costs of a large SAP landscape, Linux cluster supports [ASCS multi-SID installation](/azure/virtual-machines/workloads/sap/high-availability-guide-suse-multi-sid) on Azure. Sharing an availability cluster among multiple SAP systems simplifies the SAP landscape and reduces operation costs.

On Standard Load Balancer, you can enable the [HA port](/azure/load-balancer/load-balancer-ha-ports-overview) and avoid the need to configure load balancing rules for many SAP ports. In general, if you enable the direct server return (DSR) feature when you set up a load balancer, server responses to client inquiries can bypass the load balancer. This feature is also known as floating IP. The load balancer can be on-premises or on Azure. This direct connection keeps the load balancer from becoming the bottleneck in the path of data transmission. For the ASCS and HANA database clusters, we recommend that you enable DSR. If VMs in the back-end pool require public outbound connectivity, further [configuration](/azure/virtual-machines/workloads/sap/high-availability-guide-standard-load-balancer-outbound-connections) is required.

For traffic from SAP GUI clients that connect to an SAP server via DIAG protocol or RFC, the Central Services message server balances the load by using SAP application server [logon groups](https://wiki.scn.sap.com/wiki/display/SI/ABAP+Logon+Group+based+Load+Balancing). No extra load balancer is needed.

### Application servers in the application servers tier

You can achieve HA by load balancing traffic within a pool of application servers.

### Database tier

#### HANA replication configuration

The architecture in this guide depicts a highly available SAP HANA database system that consists of two Azure VMs. The native system replication feature of the database tier provides either manual or automatic failover between replicated nodes.

| Failover Type | Configuration | Components Required | Use Case |
|---------------|---------------|---------------------|----------|
| **Manual failover** | Multiple HANA instances with HSR | HSR only | Dev/test environments, lower RTO acceptable |
| **Automatic failover** | HSR + Linux HA Extension (HAE) | HSR + Pacemaker/clustering | Production systems, minimal RTO required |

**Automatic failover details:**
- Linux HAE provides cluster services for HANA resources
- Detects failure events automatically
- Orchestrates failover of faulty services to healthy nodes
- Typical failover time: 60-120 seconds

**Manual failover details:**
- Requires administrator intervention
- Longer recovery time objective (RTO)
- Lower complexity and cost
- Suitable for non-production environments

### Deploy VMs across availability zones

[Availability zones](/azure/virtual-machines/workloads/sap/sap-ha-availability-zones) can enhance service availability. Zones refer to physically separated locations within a specific Azure region. They improve workload availability and protect application services and VMs against datacenter outages. VMs in a single zone are treated as if they're in a single update or fault domain. When zonal deployment is selected, VMs in the same zone are distributed to fault and upgrade domains on a best-effort basis.

#### Availability zone requirements

**Minimum requirements:**
- Minimum of three zones available in supported regions
- Unknown maximum distance between zone datacenters
- Network latency testing required before deployment

**Planning checklist:**

Before deploying SAP systems across availability zones, assess:

- [ ] **Intra-zone latency**: Network latency between VMs in one zone
- [ ] **Inter-zone latency**: Network latency between VMs across chosen zones
- [ ] **Service availability**: Confirm Azure services are available in all chosen zones
- [ ] **VM type availability**: Verify required VM types are available in all chosen zones
- [ ] **Application sensitivity**: Determine application tolerance for network latency
- [ ] **Latency profile**: Create network latency profile using PsPing or Iperf

For comprehensive considerations, see [SAP HA availability zones guide](/azure/virtual-machines/workloads/sap/sap-ha-availability-zones).

> [!NOTE]
> We don't recommend availability zones for DR. A DR site should be at least 100 miles from the primary site to account for natural disasters. The exact distance between datacenters can't be guaranteed.

#### Active/passive deployment example

In this example deployment, the
[active/passive](/azure/virtual-machines/workloads/sap/sap-ha-availability-zones#activepassive-deployment) status refers to the application service state within the zones. In the application layer, all four active application servers of the SAP system are in zone 1. Another set of four passive application servers is built in zone 2 but is shut down. They're activated only when needed.

The two-node clusters for Central Services and the database are stretched across two zones. If zone 1 fails, Central Services and database services run in zone 2. The passive application servers in zone 2 get activated. With all components of this SAP system colocated in the same zone, network latency is minimized.

#### Active/active deployment example

In an [active/active deployment](/azure/virtual-machines/workloads/sap/sap-ha-availability-zones#activeactive-deployment), two sets of application servers are built across two zones. In each zone, two application servers in each set are active. As a result, there are active application servers in both zones in normal operations.

The ASCS and database services run in zone 1. The application servers in zone 2 might have longer network latency when they connect to the ASCS and database services because of the physical distance between the zones.

If zone 1 goes offline, the ASCS and database services fail over to zone 2. The dormant application servers can be brought online to provide full capacity for application processing.

## DR considerations

Every tier in the SAP application stack uses a different approach to provide DR protection. For DR strategies and implementation information, see [DR overview and infrastructure guidelines for SAP workloads](/azure/sap/workloads/disaster-recovery-overview-guide) and [DR guidelines for SAP applications](/azure/sap/workloads/disaster-recovery-sap-guide).

> [!NOTE]
> If there's a regional disaster that causes a mass failover event for many Azure customers in one region, the [resource capacity](/azure/site-recovery/azure-to-azure-common-questions#capacity) of the target region isn't guaranteed. Like all Azure services, Site Recovery continues to add features and capabilities. For the latest information about Azure-to-Azure replication, see the [support matrix](/azure/site-recovery/azure-to-azure-support-matrix).
>
> To help ensure available resource capacity for a DR region, use [on-demand capacity reservation](/azure/virtual-machines/capacity-reservation-overview). Azure allows you to combine your reserve-instance discount to your capacity reservation to reduce costs.  

## Cost considerations

Use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate costs.

For more information, see [Azure Well-Architected Framework cost optimization](/azure/architecture/framework/cost/overview).

### VMs

This architecture uses VMs that run Linux for the management, SAP application, and database tiers.

#### VM payment options

| Payment Model | Best For | Potential Savings | Commitment | Interruptible |
|---------------|----------|-------------------|------------|---------------|
| **Pay-as-you-go** | Unpredictable workloads | 0% (baseline) | None | No |
| **Azure Reservations** | Production workloads | Up to 72% | 1 or 3 years | No |
| **Azure Spot VMs** | Non-critical workloads | Significant | None | Yes |
| **Reserved + Pay-as-you-go** | Mixed workloads | Variable | Flexible | No |

**Spot VM use cases:**
- High-performance computing scenarios
- Batch processing jobs
- Visual rendering applications
- Test environments and CI/CD workloads
- Large-scale stateless applications

**Important:** Spot VMs can be evicted when Azure needs capacity back. Not suitable for production SAP systems.

For pricing details, see:
- [Linux virtual machines pricing](https://azure.microsoft.com/pricing/details/virtual-machines/linux)
- [Azure Reserved Virtual Machine Instances](/azure/virtual-machines/prepay-reserved-vm-instances)
- [Azure reservations documentation](/azure/cost-management-billing/reservations/save-compute-costs-reservations)

### Load Balancer

In this scenario, Azure load balancers are used to distribute traffic to VMs in the application tier subnet.

You're charged only for the number of configured load-balancing and outbound rules. Inbound network address translation rules are free. There's no hourly charge for Standard Load Balancer when no rules are configured.

### ExpressRoute

In this architecture, ExpressRoute is the networking service that's used for creating private connections between an on-premises network and Azure virtual networks.

All inbound data transfer is free. All outbound data transfer is charged based on a predetermined rate. For more information, see [ExpressRoute pricing](https://azure.microsoft.com/pricing/details/expressroute).

## Management and operations considerations

To help keep your system running in production, consider the following points.

### Azure Center for SAP solutions

Azure Center for SAP solutions is an end-to-end solution that enables you to create and run SAP systems as a unified workload on Azure and provides a more seamless foundation for innovation. The [Azure Center for SAP solutions](/azure/sap/center-sap-solutions/overview) guided deployment experience creates the necessary compute, storage, and networking components that you need to run your SAP system. Then you can automate the installation of the SAP software according to Microsoft best practices. You can take advantage of the management capabilities for both new and existing Azure-based SAP systems.

### Backup

You can back up SAP HANA data in many ways. After you migrate to Azure, continue to use any existing backup solutions that you have. Azure provides two native approaches to backup. You can back up [SAP HANA on VMs or use Azure Backup at the file level](/azure/virtual-machines/workloads/sap/sap-hana-backup-guide). Azure Backup is [Backint certified](/azure/backup/azure-backup-architecture-for-sap-hana-backup) by SAP. For more information, see [Azure Backup FAQ](/azure/backup/backup-azure-backup-faq) and [Support matrix for backup of SAP HANA databases on Azure VMs](/azure/backup/sap-hana-backup-support-matrix).

> [!NOTE]
> Only HANA single-container or scale-up deployments support Azure storage snapshots.

### Identity management

Use a centralized identity management system to control access to resources at all levels.

- Provide access to Azure resources through [Azure role-based access control (Azure RBAC)](/azure/role-based-access-control/overview).

- Grant access to Azure VMs through Lightweight Directory Access Protocol, Microsoft Entra ID, Kerberos, or another system.

- Support access within the apps themselves through the services that SAP provides, or use [OAuth 2.0 and Microsoft Entra ID](/entra/identity-platform/v2-oauth2-auth-code-flow).

### Monitoring

To maximize the availability and performance of applications and services on Azure, use [Azure Monitor](/azure/azure-monitor/overview). Azure Monitor is a comprehensive solution for collecting, analyzing, and acting on telemetry from your cloud and on-premises environments. Azure Monitor shows how applications are performing and proactively identifies problems that affect them and the resources that they depend on. For SAP applications that run on SAP HANA and other major database solutions, see [Azure Monitor for SAP solutions](/azure/sap/monitor/about-azure-monitor-sap-solutions) to learn how Azure Monitor for SAP can help you manage SAP services availability and performance.

## Security considerations

### Application security

SAP has its own user management engine to control role-based access and authorization within the SAP application and databases. For more information, see [SAP HANA security overview](https://www.tutorialspoint.com/sap_hana/sap_hana_security_overview.htm).

### Network security

To improve network security, consider using a [perimeter network](../../reference-architectures/dmz/secure-vnet-dmz.yml) that uses an NVA to create a firewall in front of the subnet for Web Dispatcher and the Fiori front-end server pools. You can configure these front-end servers in the perimeter network and use virtual network peering to establish connectivity with the S/4 systems. Alternatively, for scenarios where cost optimization is a priority, deploy active front-end servers that host Fiori applications within the same virtual network as the S/4 systems to minimize data transfer costs.

For comprehensive network security guidance that applies to S/4HANA, see [Security for your SAP landscape](/azure/sap/workloads/planning-guide#security-for-your-sap-landscape).

### Data encryption

Azure infrastructure security ensures that data is encrypted in transit and at rest. For SAP workloads on Linux VMs, you have several [encryption options](/azure/virtual-machines/disk-encryption-overview) to protect your data.

**Recommended encryption approaches**

For SAP HANA data-at-rest encryption, we recommend using SAP HANA-native encryption technology. For broader SAP workloads on Linux, Microsoft recommends the following approaches:

- **Database-native encryption**: Use SAP HANA's built-in encryption for data, log, and backup files to protect SAP database content.
- **Encryption at host**: Enable host-based encryption, optionally combined with Azure Storage Service Encryption and customer-managed keys, for VM-level protection.

**Avoid Azure Disk Encryption (ADE) for SAP workloads**

Azure Disk Encryption (ADE) is not recommended for SAP systems running on Linux due to several limitations:

- Support limitations and operational complexity
- Documented reliability issues with backup, recovery, and high-availability scenarios
- Lack of support by SAP-certified Linux distributions for production SAP environments
- Scheduled retirement by Microsoft

Customers should plan for alternative encryption mechanisms for new deployments and migrate existing systems to the recommended approaches above.

> [!NOTE]
> Don't use HANA data-at-rest encryption and Azure Disk Encryption on the same storage volume. For HANA, use HANA data encryption over [Azure disk storage server-side encryption](/azure/virtual-machines/disk-encryption). Using customer-managed keys might affect I/O throughput.

To enhance the security of data in Azure Files, you can enable [Encryption in Transit (EiT) for Azure Files NFS](/azure/sap/workloads/sap-azure-files-nfs-encryption-in-transit-guide).

## Communities

Communities can answer questions and help you set up a successful deployment. Consider the following resources:

- [SAP on Azure Product Announcements Summary – SAP Sapphire 2025](https://techcommunity.microsoft.com/blog/sapapplications/sap-on-azure-product-announcements-summary-%E2%80%93-sap-sapphire-2025/4415281)
- [Azure community support](https://azure.microsoft.com/support/forums)
- [SAP Community](https://www.sap.com/community.html)
- [Stack Overflow SAP](https://stackoverflow.com/tags/sap/info)

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [Ben Trinh](https://www.linkedin.com/in/bentrinh) | Principal Architect

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

For more information and examples of SAP workloads that use some of the same technologies as this architecture, see the following articles:

- [Deploy SAP S/4HANA or BW/4HANA on Azure](/azure/sap/center-sap-solutions/deploy-s4hana)
- [Use Azure to host and run SAP workload scenarios](/azure/virtual-machines/workloads/sap/get-started)
- [Virtual Machines planning and implementation for SAP NetWeaver](/azure/virtual-machines/workloads/sap/planning-guide)
- [Plan and implement SAP on Azure, data encryption guidance](/azure/sap/workloads/planning-guide#encryption-for-infrastructure-resources)

## Related resource

- [Run SAP production workloads by using an Oracle database on Azure](../../example-scenario/apps/sap-production.yml)

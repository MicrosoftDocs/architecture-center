---
title: Run SAP NetWeaver in Windows on Azure
description: Learn proven practices for running SAP NetWeaver in a Windows environment on Azure to achieve high availability and disaster recovery.
author: bqtrinh
ms.author: bentrin
ms.date: 02/18/2026
ms.topic: concept-article
ms.subservice: architecture-guide
ms.category:
   - databases
   - management-and-governance
ms.custom: arb-sap
---

# Run SAP NetWeaver in Windows on Azure

<!-- cSpell:ignore netweaver HANA SMLG ABAP SPOF WSFC ASCS Iperf SIOS -->

This guide describes proven practices for running SAP NetWeaver in a Windows environment on Azure. The architecture provides high availability. The database uses AnyDB, which is the SAP term for any supported database management system (DBMS) other than SAP HANA.

> [!IMPORTANT]
> This architecture uses SAP NetWeaver. SAP NetWeaver is approaching the end of standard maintenance, and we no longer recommend it for new deployments. To transition your architecture to a successor product, see [Transition architectures from SAP NetWeaver](https://architecture.learning.sap.com/docs/ref-arch/9a5f7b59dc).

## Architecture

The following diagram shows SAP NetWeaver in a Windows environment.

:::image type="complex" source="media/sap-netweaver.svg" alt-text="Architecture diagram that shows a solution for SAP NetWeaver on Windows. The database is AnyDB on Azure VMs with availability sets." lightbox="media/sap-netweaver.svg" border="false":::
Diagram that shows a two‑region cloud architecture with a hub‑and‑spoke network layout. On the left, an on‑premises network connects to the primary region through Azure ExpressRoute. The primary region contains a hub virtual network with a gateway subnet and a shared services subnet. The gateway subnet contains a zone-redundant gateway. The shared services subnet contains Azure Bastion and Azure DNS Private Resolver networking. The hub connects to a spoke virtual network through virtual network peering. The spoke virtual network in the primary region includes an application layer subnet that contains four sections: the SAP Web Dispatcher pool, the SAP Central Services cluster, the SAP Application Server pool, and SMB3/Azure Files shares zone-redundant storage (ZRS). The SAP Web Dispatcher pool contains Application Gateway. The SAP Central Services cluster contains Load Balancer. The spoke also includes a database layer subnet that contains database instances and an associated Load Balancer instance. The shared services subnet, application layer subnet, and database layer subnet include NSGs. A secondary region mirrors the primary region layout, with corresponding application and database sections shown inside virtual networks. Arrows indicate connections and replication paths between the primary and secondary regions.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/sap-netweaver-windows.vsdx) of this architecture.*

> [!NOTE]
> To deploy this architecture, you need appropriate licensing of SAP products and other non-Microsoft technologies.

This architecture deploys a production system that has specific virtual machine (VM) sizes that you can adjust to meet your organization's needs. You can even reduce the deployment to a single VM. The network layout is simplified to demonstrate core architectural principles rather than a complete enterprise network configuration.

### Workflow

The following workflow corresponds to the previous diagram:

1. **SAP database layer:** The database is at the core of each SAP installation and stores application data and programs. In this case, the database is replicated to provide high availability.

1. **External SAP input files:** External non-SAP systems provide data that the SAP system processes. This data is replicated for high-availability purposes.

1. **SAP application server layer:** This layer contains the central application components and processes application data. Azure Site Recovery, a Windows Server failover cluster, and multiple application servers protect this layer to ensure local and remote redundancy.

1. **Azure network gateway in a hub network:** This gateway is the entry point from the on-premises network into the Azure cloud. The hub network includes security measures.

1. **On-premises network connection to Azure:** This connection extends your local on-premises network into Azure via Azure ExpressRoute or a VPN over the internet.

## Components

- [Azure Virtual Machines](/azure/well-architected/service-guides/virtual-machines) is a compute service that provides on-demand, scalable computing resources that run Windows or Linux OS. In this architecture, VMs support both the application tier and database tier.

- Databases are systems that store and manage structured data for applications. In this architecture, the database tier runs any SAP-certified database, such as SQL Server, Oracle, or IBM Db2.

- SAP NetWeaver is an application platform that includes SAP Central Services and application servers for running SAP business applications. In this architecture, the application tier uses Windows VMs to run these components. For high availability, the VMs that run SAP Central Services are set up in a Windows Server failover cluster. WSFC supports Azure file shares or Azure shared disks.
  
  The cluster includes two instances:

  - ABAP SAP Central Services (ASCS)
  - Enqueue Replication Server (ERS)

  The Standard SKU also supports multiple-system identifier (multi-SID) SAP clusters. [Multiple SAP systems on Windows](/azure/sap/workloads/sap-high-availability-guide-wsfc-shared-disk#optional-configurations) can share a common high-availability infrastructure to save cost. Evaluate the cost savings and avoid placing too many systems in one cluster. Azure supports up to five SIDs per cluster.

  There are also partner products like [SIOS DataKeeper Cluster Edition](https://marketplace.microsoft.com/product/sios_datakeeper.sios-datakeeper-8) from SIOS Technology Corp. This software replicates content from independent disks that are attached to the ASCS cluster nodes and then presents the disks as a cluster shared volume to the cluster software.

- [Azure Storage](/azure/storage/common/storage-introduction) is a cloud storage service that provides persistent, durable storage for VM disks. In this architecture, Storage provides data persistence for VMs in the form of virtual hard disks. We recommend [Azure managed disks](/azure/virtual-machines/managed-disks-overview).

- [Azure Virtual Network](/azure/well-architected/service-guides/virtual-network) is a networking service that connects Azure resources to each other with enhanced security. In this architecture, the virtual network connects to an on-premises network via an Azure ExpressRoute gateway in the hub of a [hub-spoke topology](../../networking/architecture/hub-spoke.yml). The spoke serves as the virtual network for the SAP applications and database tiers. The hub virtual network provides shared services like Azure Bastion and backup services.

- [Virtual network peering](/azure/virtual-network/virtual-network-peering-overview) is a networking feature that provides transparent connectivity between virtual networks through the Microsoft backbone network. It avoids performance penalties when you deploy it within a single region. In this architecture, peering connects multiple virtual networks in a hub-and-spoke topology. This topology provides network segmentation and isolation for services deployed on Azure. The virtual network is divided into separate subnets for the application tier (SAP NetWeaver), the database tier, and shared services such as Azure Bastion and a non-Microsoft backup solution.

- A network gateway is a hybrid connectivity service that connects distinct networks and extends your on-premises network to Azure virtual networks. In this architecture, we recommend [ExpressRoute](../../reference-architectures/hybrid-networking/expressroute-vpn-failover.yml) to create private connections that don't traverse the public internet, but you can also use a [site-to-site VPN](/azure/vpn-gateway/vpn-gateway-about-vpngateways) connection. To reduce latency or increase throughput, consider [ExpressRoute Global Reach](/azure/expressroute/expressroute-global-reach) and [ExpressRoute FastPath](/azure/expressroute/about-fastpath), as described later in this article.

- A bastion host or jump box is a secure access solution that provides administrative access to VMs in a virtual network. In this architecture, administrators connect to VMs through a bastion host deployed as part of shared services. If Secure Shell (SSH) and Remote Desktop Protocol (RDP) are your only server administration protocols, use an [Azure Bastion](/azure/bastion/bastion-overview) host. If you use other management tools like SQL Server Management Studio or SAP Frontend, use a traditional, self-deployed jump box.

- [Network security groups (NSGs)](/azure/virtual-network/tutorial-filter-network-traffic-cli) are network security features that filter network traffic to and from Azure resources in a virtual network by using security rules. In this architecture, create NSGs to restrict incoming, outgoing, and intra-subnet traffic.

  [Application security groups (ASGs)](/azure/virtual-network/application-security-groups) provide fine-grained, workload-based network security policies that are centered on applications. In this architecture, you can use ASGs to group VMs by name and secure applications by filtering traffic from trusted network segments.

- [Azure private DNS](/azure/dns/private-dns-overview) is a Domain Name System (DNS) service that provides name resolution and manages and resolves domain names in a virtual network. In this architecture, Azure private DNS handles name resolution without the need to set up a custom DNS solution.

- Load balancers are networking services that distribute incoming network traffic across multiple servers to ensure high availability and reliability. In this architecture, we recommend [Azure Standard Load Balancer](/azure/load-balancer/skus) to distribute traffic to VMs in the SAP application tier subnet. A standard load balancer provides security by default and blocks outbound internet connectivity from VMs. For outbound internet access on the VMs, update your [standard load balancer configuration](/azure/load-balancer/skus). For SAP web-based application high availability, use the built-in [SAP Web Dispatcher](https://help.sap.com/doc/saphelp_em900/9.0/en-US/48/8fe37933114e6fe10000000a421937/content.htm?no_cache=true) or another commercially available load balancer.

  Base your selection on the following details:

  - Your traffic type, like HTTP or SAP GUI
  - The network services that you need, like Secure Sockets Layer (SSL) termination

  For more information, see [Inbound and outbound internet connections for SAP on Azure](./sap-internet-inbound-outbound.yml).

  Standard Load Balancer supports multiple front-end virtual IP addresses.

- [Azure Application Gateway](/azure/well-architected/service-guides/azure-application-gateway) is a web traffic load balancer that operates at the application layer (OSI layer 7) and can make routing decisions based on HTTP request attributes like Uniform Resource Identifier (URI) path or host headers. In this architecture, you can use Application Gateway to manage traffic to your web applications with more sophisticated routing than traditional transport layer (OSI layer-4) load balancers that only route based on source IP address, source port, destination IP address, and destination port.

## Recommendations

This architecture describes a small production-level deployment. Deployments differ based on business requirements, so use these recommendations as a starting point.

### Networking

This architecture uses a hub-spoke topology. The hub virtual network functions as a central point of connectivity to an on-premises network. The spokes are virtual networks that peer with the hub and isolate the SAP workloads. Traffic flows between the on-premises datacenter and the hub through a gateway connection.

### Network interface cards

Network interface cards (NICs) provide all communication among VMs on a virtual network. Traditional on-premises SAP deployments implement multiple NICs per machine to segregate administrative traffic from business traffic.

On Azure, the virtual network sends all traffic through the same network fabric. So you don't need to use multiple NICs for performance purposes. But if your organization needs to segregate traffic, you can deploy multiple NICs per VM, connect each NIC to a different subnet, and use NSGs to enforce different access control policies.

Azure NICs support multiple IP addresses, which aligns with the SAP recommended practice of using virtual host names for installations. For a complete outline, see [SAP note 962955](https://launchpad.support.sap.com/#/notes/962955). To access SAP notes, you need an SAP Service Marketplace account.

### Subnets and NSGs

This architecture subdivides the virtual network address space into subnets. You can associate each subnet with an NSG that defines the access policies for the subnet. Place application servers on a separate subnet. This approach simplifies security by managing subnet security policies rather than the individual servers.

When you associate an NSG with a subnet, the NSG applies to all servers within the subnet and provides fine-grained control over the servers. Set up NSGs by using the [Azure portal](/azure/virtual-network/tutorial-filter-network-traffic?tabs=portal), [Azure PowerShell](/azure/virtual-network/tutorial-filter-network-traffic?tabs=powershell), or the [Azure CLI](/azure/virtual-network/tutorial-filter-network-traffic?tabs=cli).

### ExpressRoute Global Reach

If your network environment includes two or more ExpressRoute connections, use [ExpressRoute Global Reach](/azure/expressroute/expressroute-global-reach) to reduce network hops and latency. This technology provides a Border Gateway Protocol (BGP) route peering between two or more ExpressRoute connections to bridge two ExpressRoute routing domains. Global Reach reduces latency when network traffic traverses more than one ExpressRoute connection. It's currently available only for private peering on ExpressRoute circuits.

Global Reach has no network access control lists (ACLs) or other attributes that you can change. As a result, all routes learned by an ExpressRoute circuit from on-premises and Azure are advertised across the circuit peering to the other ExpressRoute circuit. We recommend that you establish network traffic filtering on-premises to restrict access to resources.

### ExpressRoute FastPath

[ExpressRoute FastPath](/azure/expressroute/about-fastpath) improves the data path performance between your on-premises network and your virtual network. Virtual network peering over FastPath is supported. When you activate FastPath, it sends network traffic directly to VMs in the virtual network and bypasses the gateway.

All new ExpressRoute connections to Azure use FastPath as the default configuration. For existing ExpressRoute circuits, contact Azure support to activate FastPath.

| Scenario                         | FastPath and virtual network peering |
| : ------------------------------ | :--------------------------------- |
|  ExpressRoute Direct             | Supported in same region only      |
|  ExpressRoute provider circuit   | Not supported                      |
|  Global virtual network peering  | Not supported                      |
|  Hub-spoke traffic (Direct)    | Supported                            |
|  Hub-spoke internal load balancer traffic  | Gateway used             |

ExpressRoute provider circuits don't support virtual network peering over FastPath.

When you peer extra virtual networks with the virtual network that connects to ExpressRoute, traffic from your on-premises network to those peered spoke virtual networks is routed through the virtual network gateway instead of over FastPath. To avoid this limitation, connect each virtual network directly to the ExpressRoute circuit.

### Load balancers

[SAP Web Dispatcher](https://help.sap.com/docs/SUPPORT_CONTENT/si/3362959690.html) handles load balancing of HTTP and HTTPS traffic to a pool of SAP application servers. This software load balancer provides application layer services (referred to as *layer 7* in the OSI networking model) that can perform SSL termination and other offloading functions.

[Azure Load Balancer](https://azure.microsoft.com/blog/azure-load-balancer-new-distribution-mode) is a network transmission layer service (layer 4) that balances traffic by using a five-tuple hash from data streams. The hash is based on source IP address, source port, destination IP address, destination port, and protocol type. In SAP cluster deployments on Azure, Load Balancer directs traffic to the primary service instance or to a healthy node when a fault occurs.

We recommend that you use an [internal load balancer](/azure/load-balancer/quickstart-load-balancer-standard-internal-portal) for all SAP scenarios. If VMs in the back-end pool require public outbound connectivity or if you use them in an Azure zone deployment, you need [extra configurations](/azure/sap/workloads/high-availability-guide-standard-load-balancer-outbound-connections) for an internal load balancer. It's secure by default and blocks outbound connectivity unless you explicitly allow it.

For traffic from SAP GUI clients that connect to an SAP server via Dynamic Information and Action Gateway (DIAG) protocol or Remote Function Call (RFC), the SAP Central Services message server balances the load through SAP application server [logon groups](https://userapps.support.sap.com/sap/support/knowledge/en/2472141). For this type of setup, you don't need another load balancer.

### Storage

Some organizations use standard storage for their application servers. SAP doesn't support Standard managed disks. For more information, see [SAP note 1928533](https://service.sap.com/sap/support/notes/1928533). To access SAP notes, you need an SAP Service Marketplace account. We recommend that you use [Azure Premium SSD storage](/azure/virtual-machines/managed-disks-overview) in all cases. A recent update to [SAP note 2015553](https://launchpad.support.sap.com/#/notes/2015553) lists specific use cases that exclude Azure Standard HDD storage and Azure Standard SSD storage.

Application servers don't host business data. So you can use smaller P4 and P6 premium disks to help minimize costs. Premium disks provide the [single-instance VM service-level agreement (SLA)](https://www.microsoft.com/licensing/docs/view/Service-Level-Agreements-SLA-for-Online-Services) if you have a central SAP stack installation.

For high-availability scenarios, you can use [Azure file shares](/azure/storage/files/storage-files-introduction) and [Azure shared disks](/azure/virtual-machines/disks-shared). [Premium SSDs and Azure Ultra Disk Storage](/azure/virtual-machines/managed-disks-overview) are available for Azure shared disks, and Premium SSD is available for Azure file shares.

[Cloud Witness](/windows-server/failover-clustering/deploy-quorum-witness) also uses storage to maintain quorum via a device in a remote Azure region, separate from the primary region where the cluster resides.

For the backup data store, we recommend Azure [cool and archive access tiers](/azure/storage/blobs/access-tiers-overview). These storage tiers provide a cost-effective way to store long-lived data for infrequent access.

[Premium SSD v2](/azure/virtual-machines/disks-types#premium-ssd-v2) supports performance-critical workloads like online transaction processing (OLTP) systems that consistently need submillisecond latency combined with high input/output per second (IOPS) and throughput.

[Ultra Disk Storage](/azure/virtual-machines/disks-types#ultra-disks) reduces disk latency. As a result, it benefits performance-critical applications like the SAP database servers. To compare block storage options in Azure, see [Azure managed disk types](/azure/virtual-machines/disks-types).

For a high-availability, high-performance shared data store, use [Azure NetApp Files](/azure/azure-netapp-files/azure-netapp-files-introduction). Azure NetApp Files is useful for [Oracle](/azure/azure-netapp-files/performance-oracle-single-volumes) database tiers and for [hosting application data](/azure/sap/workloads/high-availability-guide-windows-netapp-files-smb).

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability helps ensure that your application can meet the commitments that you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

Highly available infrastructure solutions rely on resource redundancy. For single-instance VM availability SLAs for various storage types, see [SLA for VMs](https://www.microsoft.com/licensing/docs/view/Service-Level-Agreements-SLA-for-Online-Services). To increase service availability on Azure, [deploy VM resources](/azure/sap/workloads/sap-high-availability-architecture-scenarios#comparison-of-different-deployment-types-for-sap-workload) by using Azure Virtual Machine Scale Sets with flexible orchestration (FD=1), availability zones, or availability sets.

You can deploy SAP workloads regionally or zonally on Azure, depending on the availability and resiliency requirements of the SAP applications. For more information about the available deployment options and their applicability across different Azure regions including across zones, within a single zone, or in a region without zones, see [High-availability architecture and scenarios for SAP NetWeaver](/azure/sap/workloads/sap-high-availability-architecture-scenarios).

This distributed installation of the SAP application replicates the base installation to achieve high availability. For each layer of the architecture, the high-availability design varies.

#### SAP Web Dispatcher in the application servers tier

The SAP Web Dispatcher component serves as a load balancer for SAP traffic among the SAP application servers. To achieve [high availability of SAP Web Dispatcher](https://help.sap.com/docs/SUPPORT_CONTENT/si/3362959690.html), Load Balancer implements either the failover cluster or the parallel SAP Web Dispatcher setup.

For internet-facing communications, we recommend a standalone solution in the perimeter network (also known as *DMZ, demilitarized zone, and screened subnet*) to satisfy security concerns.

[Embedded SAP Web Dispatcher](https://help.sap.com/viewer/00b4e4853ef3494da20ebcaceb181d5e/LATEST/en-US/2e708e2d42134b4baabdfeae953b24c5.html) on ASCS is an alternative option. If you use this option, consider properly sizing the ASCS instance because of the extra workload.

#### SAP Central Services in the application servers tier

A Windows Server failover cluster implements high availability for SAP Central Services. When the cluster storage for the failover cluster is deployed on Azure, you can set it up as a clustered shared disk or as a clustered file share.

- We recommend that you use [Azure Files](/azure/storage/files/storage-files-introduction) as fully managed, cloud-native Server Message Block (SMB) or Network File System (NFS) shares. You can also use [Azure NetApp Files](/azure/azure-netapp-files/azure-netapp-files-introduction), which provides high-performance, enterprise-class NFS and SMB shares.

- To set up clusters by using shared disks on Azure, we recommend that you use [Azure shared disks](/azure/virtual-machines/disks-shared) to set up a [Windows Server failover cluster for SAP Central Services](/azure/virtual-machines/workloads/sap/sap-high-availability-infrastructure-wsfc-shared-disk). For an implementation example, see [Prepare Azure infrastructure for an ASCS cluster by using Azure shared disks](/azure/sap/workloads/sap-high-availability-infrastructure-wsfc-shared-disk).

If you use an internal load balancer, you can activate the [high-availability port](/azure/load-balancer/load-balancer-ha-ports-overview). This port avoids the need to define load-balancing rules for multiple SAP ports. When you set up Azure load balancers, activate Direct Server Return (DSR), which is also called *Floating IP*. DSR provides a way for server responses to bypass the load balancer. This direct connection keeps the load balancer from becoming a bottleneck in the path of data transmission. We recommend that you activate DSR for the ASCS and database clusters.

#### Application services in the application servers tier

Load balance traffic within a pool of application servers to achieve high availability for the SAP application servers. You don't need cluster software, SAP Web Dispatcher, or the Azure load balancer. The SAP message server can load balance client traffic to the application servers defined in an ABAP logon group by using transaction SMLG.

#### Database tier

In this architecture, the source database runs on AnyDB, which refers to any SAP-supported DBMS such as SQL Server, SAP ASE, IBM DB2, or Oracle. The native replication feature of the database tier provides either manual or automatic failover between replicated nodes.

For more information about how to implement specific database systems, see [Virtual Machines DBMS deployment for SAP NetWeaver](/azure/sap/workloads/dbms-guide-general).

#### VMs deployed across availability zones

An availability zone consists of one or more datacenters. This design improves workload availability and protects application services and VMs against datacenter outages. VMs in a single zone are treated as if they're in a single fault domain. When you select zonal deployment, VMs in the same zone are distributed to fault domains on a best-effort basis.

In [Azure regions](https://azure.microsoft.com/explore/global-infrastructure/geographies/) that support multiple zones, at least three zones are available. But the maximum distance between datacenters in these zones isn't guaranteed. To deploy a multitier SAP system across zones, you must know the network latency within a zone and across targeted zones. You also must know your deployed applications' sensitivity to network latency.

Consider the following [factors](/azure/sap/workloads/high-availability-zones) when you deploy resources across availability zones:

- Latency between VMs in one zone
- Latency between VMs across chosen zones
- Availability of the same Azure services (VM types) in the chosen zones

#### Active/inactive deployment example

In this example deployment, the [active/passive](/azure/sap/workloads/high-availability-zones?tabs=passive#deployment-types) status refers to the application service state within the zones. In the application layer, all four active application servers of the SAP system are in zone 1. Another set of four passive application servers is deployed in zone 2 but is shut down. These servers are activated only when they're needed.

The two-node clusters for SAP Central Services and the database services are deployed across two zones. If zone 1 fails, SAP Central Services and the database services run in zone 2. The passive application servers in zone 2 get activated. All components of this SAP system now reside in the same zone, which reduces network latency.

#### Active/active deployment example

In an [active/active deployment](/azure/sap/workloads/high-availability-zones?tabs=active#deployment-types), two sets of application servers are deployed across two zones. Within each zone, two application servers in each set of servers are inactive because they're shut down. As a result, both zones run active application servers during normal operations.

SAP Central Services and the database services run in zone 1. The application servers in zone 2 might have longer network latency when they connect to SAP Central Services and the database services because of the physical distance between zones.

If zone 1 goes offline, SAP Central Services and the database services fail over to zone 2. You can bring the dormant application servers online to provide full capacity for application processing.

#### Disaster recovery considerations

In this context, disaster recovery (DR) means that an entire region becomes unavailable, mainly through natural disasters like fire or flood. Every tier in the SAP application stack uses a different approach to provide DR protection. For more information about DR strategies and implementation, see [DR overview and infrastructure guidelines for SAP workloads](/azure/sap/workloads/disaster-recovery-overview-guide) and [DR guidelines for SAP applications](/azure/sap/workloads/disaster-recovery-sap-guide?tabs=linux).

> [!NOTE]
> If a regional natural disaster causes a large failover event for many Azure customers in one region, the target region's [resource capacity](/azure/site-recovery/azure-to-azure-common-questions#capacity) isn't guaranteed. Site Recovery continues to add features and capabilities. For the latest information about Azure-to-Azure replication, see the [support matrix](/azure/site-recovery/azure-to-azure-support-matrix).

#### Backup

Databases are critical workloads that require a low recovery point objective (RPO) and long-term retention.

- For SAP on SQL Server, you can use [Azure Backup](/azure/backup/backup-azure-sql-database) to back up SQL Server databases that run on VMs. If the database files are stored in Azure Blob Storage, you can use [file-snapshot backups for database files in Azure](/sql/relational-databases/backup-restore/file-snapshot-backups-for-database-files-in-azure).

- For SAP with Oracle on Windows, see [Backup and restore for Azure VMs Oracle database deployment for SAP workloads](/azure/sap/workloads/dbms-guide-oracle#backup-and-restore).

- For other databases, see the backup recommendations for your database provider. If the database supports the Windows Volume Shadow Copy Service (VSS), use VSS snapshots for application-consistent backups.

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

SAP has its own user management engine (UME) to control role-based access and authorization within the SAP application and databases. For more information about application security guidance, see [SAP NetWeaver security guide](https://help.sap.com/docs/SAP_NETWEAVER_701/6f457d836c4b10148949c300573c213b/4aaf6fd65e233893e10000000a42189c.html).

To enhance network security, consider applying a [perimeter network](../../reference-architectures/dmz/secure-vnet-dmz.yml) that uses a network virtual appliance (NVA) as a firewall for the SAP Web Dispatcher subnet.

You can deploy an NVA to filter traffic between virtual networks, but don't place it between the SAP application and the database. Check the routing rules that are defined on the subnet and avoid directing traffic to a single-instance NVA. Routing through a single-instance NVA can cause maintenance downtime and network or clustered-node failures.

For infrastructure security, Azure encrypts data in transit and at rest. For more information about network security, see [Security for your SAP landscape](/azure/sap/workloads/planning-guide#security-for-your-sap-landscape). This article also specifies the network ports that you need to open on the firewalls to support application communication.

#### Encryption

For SAP workloads, Microsoft recommends the following approaches:

- **Database-native encryption**, for example SAP HANA data, log, and backup encryption, to protect SAP database content

- **Encryption at host**, optionally combined with Azure Storage service encryption and customer-managed keys, for VM-level protection

For data-at-rest encryption, SQL Server transparent data encryption (TDE) encrypts SQL Server and Azure SQL Database data files. For more information, see [SQL Server Virtual Machines DBMS deployment for SAP NetWeaver](/azure/sap/workloads/dbms-guide-sqlserver).

To monitor threats from inside and outside the firewall, consider deploying [Microsoft Sentinel](/azure/sentinel/sap/solution-overview). This solution provides continuous threat detection and analytics for SAP systems that are deployed on Azure by using an agentless data connector. For more information, see [Deployment overview](/azure/sentinel/sap/deployment-overview).

Manage security updates and patches to safeguard your information assets. Consider using a holistic [automation approach](/azure/update-manager/view-updates?tabs=singlevm-overview) for this task.

#### Identity management

To control access to resources at all levels, use a centralized identity management system like Microsoft Entra ID and Active Directory Domain Services (AD DS):

- Provide access to Azure resources by using [Azure role-based access control (Azure RBAC)](/azure/role-based-access-control/overview).

- Grant access to Azure VMs by using Lightweight Directory Access Protocol (LDAP), Microsoft Entra ID, Kerberos, or another system.

- Support access within SAP applications by using SAP-provided services or [OAuth 2.0 with Microsoft Entra ID](/entra/identity-platform/v2-oauth2-auth-code-flow).

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

Use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator/) to estimate costs.

#### VMs

This architecture uses VMs for the application tier and the database tier. The SAP NetWeaver tier uses Windows VMs to run SAP services and applications. The database tier runs AnyDB as the database, such as SQL Server, Oracle, or IBM DB2. VMs also serve as jump boxes for management.

VMs have several payment options:

- For workloads that have no predictable time of completion or resource consumption, consider the pay-as-you-go option.

- Consider using [Azure VM reservations](/azure/cost-management-billing/reservations/save-compute-costs-reservations) if you can commit to a one-year or three-year term. VM reservations can significantly reduce costs.

Use [Azure spot VMs](/azure/virtual-machines/spot-vms) for workloads that can be interrupted and don't require completion within a predetermined time frame or an SLA. Azure deploys spot VMs when capacity is available and evicts them when it needs the capacity back. Spot VMs cost less than other VMs. Consider using spot VMs in this architecture to reduce costs for the following components:

- Application servers in production environments that don't have a service-level objective (SLO)

- Application servers in nonproduction environments, including supporting compute such as continuous integration and continuous delivery (CI/CD) agents

Azure Reserved Virtual Machine Instances can reduce your total cost of ownership. You can combine Azure Reserved Virtual Machine Instances rates with a pay-as-you-go subscription to manage costs across predictable and variable workloads. For more information, see [Azure Reserved Virtual Machine Instances](/azure/virtual-machines/prepay-reserved-vm-instances).

If your database tier requires more memory and fewer CPUs, use one of the [constrained virtual CPU (vCPU) VM](/azure/virtual-machines/constrained-vcpu) sizes to reduce per-vCPU software licensing costs.

#### Load Balancer

In this scenario, Load Balancer distributes traffic to VMs in the application-tier subnet.

Azure charges you only for the number of defined load-balancing and outbound rules, and the data that goes through the load balancer. Inbound network address translation (NAT) rules are free. Standard Load Balancer has no hourly charge if you don't create any rules.

#### ExpressRoute

In this architecture, you use ExpressRoute to create private connections between an on-premises network and Azure virtual networks.

All inbound data transfer is free. Azure charges for all outbound data transfer based on a predetermined rate. For more information, see [ExpressRoute pricing](https://azure.microsoft.com/pricing/details/expressroute/).

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

#### Azure Center for SAP solutions

Azure Center for SAP solutions helps you create and run SAP systems as a unified workload on Azure. Its guided deployment experience creates the necessary compute, storage, and networking components that you need to run your SAP system. You can also use it to automate the installation of SAP software according to Microsoft best practices. You can take advantage of the management capabilities for both new and existing Azure-based SAP systems. For more information, see [Azure Center for SAP solutions](/azure/sap/center-sap-solutions/overview).

If you need more control over maintenance events or hardware isolation for either performance or compliance, consider deploying your VMs on [dedicated hosts](/azure/virtual-machines/dedicated-hosts).

#### Monitoring

To maximize the availability and performance of applications and services on Azure, use [Azure Monitor](/azure/azure-monitor/fundamentals/overview). Azure Monitor collects, analyzes, and acts on telemetry from your cloud and on-premises environments. It shows how applications perform and proactively identifies problems that affect them and the resources that they depend on.

For more information about SAP-specific monitoring capabilities, see [Azure Monitor for SAP solutions](/azure/sap/monitor/about-azure-monitor-sap-solutions). Use this guidance to manage the availability and performance of SAP services that run on databases like SAP HANA.

#### Communities

Communities can answer questions and help you set up a successful deployment:

- [Run SAP applications on the Microsoft platform blog](https://techcommunity.microsoft.com/category/saponmicrosoft)
- [SAP community](https://community.sap.com)

### Performance Efficiency

Performance Efficiency refers to your workload's ability to scale to meet user demands efficiently. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

SAP application servers communicate continuously with the database servers. For performance-critical applications that run on database platforms, activate [Write Accelerator](/azure/virtual-machines/how-to-enable-write-accelerator) for the log volume if you use Premium SSD v1. Write Accelerator improves log-write latency and is available for M-series VMs.

To optimize inter-server communications, use [accelerated networking](/azure/virtual-network/accelerated-networking-overview). Most general-purpose and compute-optimized VM instance sizes that have two or more vCPUs support accelerated networking. On instances that support hyperthreading, VM instances that have four or more vCPUs support accelerated networking.

To achieve high IOPS and disk throughput, follow the common practices in storage volume [performance optimization](/azure/virtual-machines/premium-storage-performance), which apply to Azure storage layout. For example, you can position multiple disks together to create a striped disk volume to improve input/output (I/O) performance. To enhance the speed of data retrieval, activate the read cache on storage content that changes infrequently.

[Premium SSD v2](/azure/virtual-machines/disks-types) provides more control over performance settings than Premium SSDs. You can set a Premium SSD v2 disk to any supported size and make granular adjustments to performance without downtime.

[Ultra Disk Storage](/azure/virtual-machines/disks-enable-ultra-ssd) supports I/O-intensive applications. We recommend Ultra Disk Storage over [Write Accelerator](/azure/virtual-machines/how-to-enable-write-accelerator) premium storage when possible. You can individually increase or decrease performance metrics like IOPS and MBps without needing to reboot.

For more information about how to optimize Azure storage for SAP workloads on SQL Server, see [Virtual Machines planning and implementation for SAP NetWeaver](/azure/sap/workloads/planning-guide).

The placement of an NVA between the application and the database layers for any SAP application stack isn't supported. This practice introduces significant processing time for data packets, which leads to unacceptable application performance.

#### Proximity placement groups

SAP application servers usually require frequent communication with the database. The physical proximity of the application server layer and the database layers affects network latency, which can adversely affect application performance.

To optimize network latency, you can use proximity placement groups, which set a logical constraint on the VMs that are deployed in availability sets. Proximity placement groups favor colocation and performance over scalability, availability, or cost. They can improve the user experience for most SAP applications. For more information about scripts that help measure latency, see [Scripts on GitHub](https://github.com/Azure/SAP-on-Azure-Scripts-and-Utilities).

> [!NOTE]
> Not all scenarios require proximity placement groups. For more recommendations about when to use or avoid proximity placement groups, see [Proximity placement groups](/azure/sap/workloads/proximity-placement-scenarios#proximity-placement-groups).

#### Availability zones

[Availability zones](/azure/reliability/availability-zones-overview) provide a way for you to deploy VMs across datacenters, which are physically separated locations within a specific Azure region. Availability zones enhance service availability. But latency can increase if you deploy resources across zones, so keep performance considerations in mind.

Administrators need a clear network latency profile between all zones of a target region before they can determine the resource placement with minimum inter-zone latency. To create this profile, deploy small VMs in each zone for testing. Recommended tools for these tests include [PsPing](/sysinternals/downloads/psping) and [Iperf](https://github.com/esnet/iperf). When the tests are done, remove the VMs that you used for testing. As an alternative, consider using an [Azure inter-zone latency check tool](https://github.com/Azure/SAP-on-Azure-Scripts-and-Utilities/tree/main/AvZone-Latency-Test).

#### Scalability considerations

For the SAP application layer, Azure offers a wide range of VM sizes for scaling up and scaling out. For an inclusive list, see [Supported products and Azure VM types](https://launchpad.support.sap.com/#/notes/1928533). To access SAP notes, you need an SAP Service Marketplace account.

You can scale SAP application servers and the SAP Central Services clusters up and down. You can also scale them out or in by changing the number of instances that you use. The AnyDB database can scale up and down but doesn't scale out. The SAP database container for AnyDB doesn't support sharding.

## Contributors

*Microsoft maintains this article. The following contributor wrote this article.*

Principal author:

- [Ben Trinh](https://www.linkedin.com/in/bentrinh/) | Principal Architect

Other contributor:

- [Steffen Mueller](https://www.linkedin.com/in/steffen-mueller-054ba455/) | Senior Architect

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

For more information and for SAP workload examples that use technologies in this architecture, see the following articles:

- [Virtual Machines planning and implementation for SAP NetWeaver](/azure/virtual-machines/workloads/sap/planning-guide)
- [Use Azure to host and run SAP workload scenarios](/azure/virtual-machines/workloads/sap/get-started)

## Related resource

- [Run SAP production workloads by using an Oracle database on Azure](../../example-scenario/apps/sap-production.yml)

---
title: Run SAP NetWeaver for AnyDB on Azure
description: Proven practices for running SAP NetWeaver in a Windows environment on Azure with high availability.
author: lbrader
ms.date: 05/11/2018
---

# SAP NetWeaver with AnyDB on Azure

This reference architecture shows a set of proven practices for running SAP NetWeaver in a Windows environment on Azure. The architecture is configured for high availability and disaster recovery (HADR). The database shown in this architecture is *AnyDB*, which is the SAP term for any supported DBMS besides SAP HANA. For SAP HANA, see [SAP S/4HANA reference architecture](./sap-s4hana.md).

![](./images/sap-netweaver.png)

> [!NOTE] 
> Deploying SAP products according to this reference architecture requires appropriate licensing of SAP products and other non-Microsoft technologies.

## Architecture

The architecture consists of the following components.

**Virtual networks (VNets)**. This architecture uses two VNets in a [hub-spoke](../hybrid-networking/hub-spoke.md) topology. The hub VNet contains shared services including Active Directory domain servers. The spoke VNet contains the SAP applications and database tier. The VNet is divided into separate subnets for each tier: application (SAP NetWeaver), database, jumpbox, and Active Directory.

**Virtual machines**. The VMs are grouped into the following tiers:

- **SAP NetWeaver**. The application tier uses Windows VMs and runs SAP Central Services and SAP application servers. The VMs that run Central Services are configured as a Windows Server Failover Cluster for high availability, supported by SIOS DataKeeper Cluster Edition.

- **AnyDB**. The database tier runs AnyDB as the source database, such as Microsoft SQL Server, Oracle, or IBM DB2.

- **Jumpbox**. Also called a bastion host. This is a secure virtual machine on the network that administrators use to connect to the other VMs.

- **Active Directory domain controllers**. The domain controllers are used for all VMs and users in the domain.

**Availability sets**. Place the VMs for the SAP Web Dispatcher, SAP application server, and (A)SCS roles into separate [availability sets](/azure/virtual-machines/virtual-machines-windows-manage-availability). Provision at least two VMs for each role. This makes the VMs eligible for a higher service level agreement (SLA). For more information, see [SLA for Virtual Machines](https://azure.microsoft.com/support/legal/sla/virtual-machines).

**Network security groups (NSGs)**. Use [NSGs](/azure/virtual-network/virtual-networks-nsg) to restrict traffic between the various subnets.

**Gateway**. The gateway extends your on-premises network to the Azure virtual network. We recommend ExpressRoute for creating private connections that do not go over the public Internet, but a virtual private network (VPN) can also be used. For more information, see [Connect an on-premises network to Azure](../hybrid-networking/index.md).

**Paired region**. For disaster recover (DR), configure a secondary region that can be used to fail over the application and database. See [Disaster recovery considerations](#disaster-recovery-considerations), below.

## Recommendations

This architecture describes a small production-level enterprise deployment. Your deployment may differ based on your business requirements. Use these recommendations as a starting point.

### SAP Web Dispatcher

The Web Dispatcher component is used as a load balancer for SAP traffic among the SAP application servers. To achieve high availability for the Web Dispatcher component, place two or more Web Dispatcher VMs behind an Azure Load Balancer.

For details about running SAP NetWeaver on Azure VMs, see [Azure Virtual Machines planning and implementation for SAP NetWeaver](/azure/virtual-machines/workloads/sap/planning-guide).

### Application server pool

To manage logon groups for ABAP application servers, SMLG transaction is used. It uses the load balancing function within the Central Services Message Server to distribute the workload among SAP application servers for SAPGUI and RFC traffic. The application server connects to the Central Services through the cluster virtual network name. This avoids the need to change the application server profile for Central Services connectivity after a local failover. Assigning the cluster virtual network name to the endpoint of this internal load balancer is optional.

### SAP Central Services cluster

Central Services can be deployed to a single virtual machine when high availability is not a requirement. However, the single virtual machine becomes a potential single point of failure (SPOF). To achieve high availability, configure Central Services on a Windows Server Failover Cluster. The cluster storage for the failover cluster can be configured using either a clustered shared volume or a file share.

**Shared volume.** Because Azure does not natively support shared disks, SIOS Datakeeper is used to replicate the content of independent disks attached to the cluster nodes and to abstract the drives as a cluster shared volume for the cluster manager. For implementation details, see [Clustering SAP ASCS on Azure](https://blogs.msdn.microsoft.com/saponsqlserver/2015/05/20/clustering-sap-ascs-instance-using-windows-server-failover-cluster-on-microsoft-azure-with-sios-datakeeper-and-azure-internal-load-balancer/).

**File share**. Another way to handle clustering is to implement a file share cluster. SAP has modified the Central Services deployment pattern to access the /sapmnt global directories via a UNC path. This change removes the requirement for SIOS or other shared disk solutions on the Central Services VMs. It is still recommended that the /sapmnt UNC share be highly available. This can be done using [Scale Out File Server](https://blogs.msdn.microsoft.com/saponsqlserver/2017/11/14/file-server-with-sofs-and-s2d-as-an-alternative-to-cluster-shared-disk-for-clustering-of-an-sap-ascs-instance-in-azure-is-generally-available/) (SOFS) and [Storage Spaces Direct](https://blogs.sap.com/2018/03/07/your-sap-on-azure-part-5-ascs-high-availability-with-storage-spaces-direct/) (S2D) in Windows Server 2016. S2D can implement software-defined storage and eliminates the need for SIOS DataKeeper.

> [!NOTE]
> Currently an SOFS cluster does not extend across regions to provide disaster recovery support.

We recommend using [Cloud Witness](/windows-server/failover-clustering/deploy-cloud-witness) as a quorum witness for the Windows Server Failover Cluster. Cloud Witness uses Azure Blob Storage to establish quorum. Provision the blob storage account in a separate region. 

### Availability sets

Availability sets distribute VMs to different physical infrastructure and update groups to improve uptime. Put VMs that perform the same role into an availability set. All VMs within an availability set should perform the same role. Don't mix different roles in the same availability set. For example, don't place a Central Services node in the same availability set as the application server.

### VM disks

For all database server VMs, we recommend using Azure Premium Storage for consistent read/write latency. For production SAP systems, we recommend using [Managed Disks](/azure/virtual-machines/windows/managed-disks-overview) with Premium tier in all cases. Managed disks ensure that the disks for VMs within an availability set are isolated to avoid single points of failure.

For SAP application servers, including the Central Services VMs, you can use Azure Standard Storage to reduce cost, because application execution takes place in memory and disks are used for logging only. However, at this time, Standard Storage is only certified for unmanaged storage. Since application servers do not host any data, you can also use the smaller P4 and P6 Premium Storage disks to help minimize cost.

### NICs

Traditional on-premises SAP deployments use multiple NICs per machine to segregate administrative traffic from business traffic. On Azure, the virtual network is a software-defined network that sends all traffic through the same network fabric. Therefore, the use of multiple NICs is unnecessary. However, if your organization needs to segregate traffic, you can create multiple NICs per VM and assign the NICs to different subnets, which is controlled with NSGs.

### NSGs

Use NSGs to define the access policies for each subnet. When an NSG is associated with a subnet, it applies to all the VMs within the subnet. This allows you to secure VMs more easily by managing network security policies at the level of the subnet, not the individual VM.

For more information about using NSGs for fine-grained control over the VMs in a subnet, see [Filter network traffic with network security groups](/azure/virtual-network/virtual-networks-nsg).

### Load balancers

SAP Web Dispatcher handles load balancing of HTTP(S) traffic to a pool of SAP application servers.

For traffic from SAP GUI clients connecting a SAP server via DIAG protocol and Remote Function Calls (RFC), the Central Services message server balances the load through SAP application server [logon groups](https://wiki.scn.sap.com/wiki/display/SI/ABAP+Logon+Group+based+Load+Balancing), so no additional load balancer is needed.

## Performance and scalability considerations

SAP application servers are in constant communication with the database servers. For performance-critical applications running on any database platform, including SAP HANA, consider enabling [Write Accelerator](/virtual-machines/linux/how-to-enable-write-accelerator) to improve log write latency. To optimize network communication between VMs, enable [Accelerated Networking](https://docs.microsoft.com/en-us/azure/virtual-network/create-vm-accelerated-networking-cli). Note that not all VM series support Accelerated Network.

To achieve high IOPS and disk bandwidth throughput, the common practices in storage volume performance optimization apply in Azure. For example:

- Combining multiple disks to create a striped disk volume improves I/O performance. 
- Enabling the read cache on storage content that changes infrequently enhances the speed of data retrieval.

For SAP on SQL, the blog post [Top 10 Key Considerations for Deploying SAP Applications on Azure](https://blogs.msdn.microsoft.com/saponsqlserver/2015/05/25/top-10-key-considerations-for-deploying-sap-applications-on-azure/) has recommendations optimizing Azure storage for SAP workloads on SQL Server.

At the SAP application layer, Azure offers a wide range of virtual machine sizes for scaling up. For an inclusive list, see [SAP note 1928533](https://launchpad.support.sap.com/#/notes/1928533) (requires SAP Service Marketplace account to access). SAP application servers can scale up/down or scale out by adding more instances.

The Central Services cluster and AnyDB databases can scale up/down, but do not scale out, because only a single primary node is active at one time. The SAP database container for AnyDB does not support sharding.

## Availability considerations

For each layer of the architecture, the high availability design varies.

**SAP Web Dispatcher**. High availability is achieved with redundant instances. See [SAP Web Dispatcher](https://help.sap.com/doc/saphelp_nw70ehp2/7.02.16/48/8fe37933114e6fe10000000a421937/frameset.htm) in the SAP Documentation.

**Central Services**. For high availability of Central Services on Windows VMs, use a Windows Server Failover Cluster. The failover cluster can be configured using either a clustered shared volume or a file share, as described above.

**SAP application servers**. High availability is achieved by load balancing traffic within a pool of application servers.

**Database tier**. This reference architecture assumes the source database is running on AnyDB &mdash; that is, a DBMS such as SQL Server, SAP ASE, IBM DB2, or Oracle. The native replication feature in the database provides either manual or automatic failover between replicated nodes. For implementation details about specific database systems, see [Azure Virtual Machines DBMS deployment for SAP NetWeaver](/azure/virtual-machines/workloads/sap/dbms-guide).

For more information, see [SAP certifications and configurations running on Microsoft Azure](/azure/virtual-machines/workloads/sap/sap-certifications).

## Disaster recovery considerations

For disaster recovery (DR), you must be able to fail over to a secondary region. Each tier uses a different strategy to provide DR protection.

**Application servers.** SAP application servers do not contain business data. A simple DR strategy is to create SAP application servers in the secondary region, and then shut them down. However, any configuration changes or kernel updates on the primary application server must be copied to the VMs in the secondary region. Consider using [Azure Site Recovery](/azure/site-recovery/) to automatically replicate application servers the secondary region.

**Central Services**. Central Services does not persist any business data. You can deploy a VM in the secondary region to run the Central Services role. The only content from the primary Central Services node to synchronize is the /sapmnt share content. In addition, any configuration changes or kernel updates on the primary Central Services servers must be copied to the VM in the secondary region. To synchronize the two servers, you can use Azure Site Recovery to replicate the cluster nodes or simply schedule a job to copy /sapmnt to the disaster recovery region. For details, download the whitepaper [SAP NetWeaver: Building a Hyper-V & Microsoft Azure–based Disaster Recovery Solution](http://download.microsoft.com/download/9/5/6/956FEDC3-702D-4EFB-A7D3-2DB7505566B6/SAP%20NetWeaver%20-%20Building%20an%20Azure%20based%20Disaster%20Recovery%20Solution%20V1_5%20.docx), and refer to section 4.3, SAP SPOF layer (ASCS).

**Database tier**. Use the database's own integrated replication technology for DR. In the case of SQL Server, for example, we recommend using Always On Availability Groups to replicate transactions asynchronously with manual failover. Asynchronous replication avoids an impact to the performance of interactive workloads at the primary site. Manual failover offers the opportunity for a person to evaluate the DR impact and decide if operating from the DR site is justified. For more information, see [Multi-region N-tier application for high availability](../n-tier/multi-region-sql-server.md).

To use Azure Site Recovery to automatically build out a fully replicated production site of your original, you must run customized deployment scripts. For more information, see [Add Azure Automation runbooks to recovery plans](/azure/site-recovery/site-recovery-runbook-automation). Site Recovery first deploys the VMs in availability sets, then runs scripts to add resources such as load balancers.

For the backup data store, we recommend Azure [cool access](/azure/storage/blobs/storage-blob-storage-tiers#cool-access-tier) and [archive access](/azure/storage/blobs/storage-blob-storage-tiers#archive-access-tier) storage tiers. These storage tiers are cost-effective ways to store long-lived data that is infrequently accessed.

## Manageability considerations

Azure Operations Management Suite (OMS) provides enhanced monitoring of Azure virtual machines.  

For SAP-based monitoring of resources and service performance of the SAP infrastructure, use the [Azure Enhanced Monitoring Extension for SAP](/azure/virtual-machines/workloads/sap/deployment-guide#d98edcd3-f2a1-49f7-b26a-07448ceb60ca). This extension feeds Azure monitoring statistics into the SAP application for operating system monitoring and DBA Cockpit functions. For more information, see [Azure Virtual Machines deployment for SAP NetWeaver](/azure/virtual-machines/workloads/sap/deployment-guide#detailed-tasks-for-sap-software-deployment).

## Security considerations

SAP has its own Users Management Engine (UME) to control role-based access and authorization within the SAP application. For details, see [SAP HANA Security - An Overview](https://archive.sap.com/documents/docs/DOC-62943) (requires SAP Service Marketplace account to access).

For additional network security, consider implementing a network DMZ, which uses a network virtual appliance to create a firewall in front of the Web Dispatcher subnet. For more information, see [Network DMZ reference architectures](../dmz/index.md).

For infrastructure security, data is encrypted in transit and at rest. For more information, see the Security Considerations section of [Azure Virtual Machines planning and implementation for SAP NetWeaver](/azure/virtual-machines/workloads/sap/planning-guide#security-considerations). That article also specifies the network ports that must be opened on the firewalls to allow application communication.

To encrypt the VM disks, use [Azure Disk Encryption](/azure/security/azure-security-disk-encryption). For Windows VMs, Azure Disk Encryption uses BitLocker to provide volume encryption for the OS and the data disks. It also works with Azure Key Vault to help you control and manage the disk-encryption keys and secrets in your key vault subscription. Data on the VM disks are encrypted at rest in your Azure storage.

## Communities

Communities can answer questions and help you set up a successful deployment. 

- [Running SAP Applications on the Microsoft Platform Blog](https://blogs.msdn.microsoft.com/saponsqlserver/)
- [Azure Community Support](https://azure.microsoft.com/support/community/)
- [SAP Community](https://www.sap.com/community.html)
- [Stack Overflow](https://stackoverflow.com/tags/sap/)

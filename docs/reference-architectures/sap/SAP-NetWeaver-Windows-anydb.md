---
title: Deploy SAP Application Layer (Netweaver) on Windows Using Azure
description:  Proven practices for running SAP NetWeaver on Windows virtual machines in a high availability environment on Azure.
author: njray
ms.date: 4/20/18
---

# Deploy SAP NetWeaver (Windows) for AnyDB on Azure Virtual Machines
[!INCLUDE [header](../../_includes/header.md)]

This reference architecture shows a set of proven practices for running SAP NetWeaver in a Windows environment on Azure with high availability. The database is AnyDB, the SAP term for any supported DBMS besides SAP HANA. This architecture is deployed with specific virtual machine (VM) sizes that can be changed to accommodate your organization’s needs. 

![0][0]


> [!NOTE]
> Deploying SAP products according to this reference architecture requires appropriate licensing of SAP products and other non-Microsoft technologies.


## Architecture

The architecture consists of the following infrastructure and key software components.

- **Virtual network**. The [Azure Virtual Network][vnet] service securely connects Azure resources to each other. In this architecture, the virtual network connects to an on-premises environment through a VPN gateway.

- **Subnets**. The virtual network is subdivided into separate subnets for each tier: application (SAP NetWeaver), database, shared services (the jumpbox), and Active Directory.

- **Virtual machines**. This architecture uses virtual machines for the application tier and database tier, grouped as follows:

   - **SAP NetWeaver**. The application tier uses Windows virtual machines and runs SAP Central Services and SAP application servers. The VMs that run Central Services are configured as a Windows Server Failover Cluster for high availability, supported by SIOS DataKeeper Cluster Edition.

   - **AnyDB**. The database tier runs AnyDB as the source database, such as Microsoft SQL Server, Oracle, or IBM DB2. 

   - **Jumpbox**. Also called a bastion host. This is a secure virtual machine on the network that administrators use to connect to the other virtual machines.

   - **Windows Server Active Directory domain controllers**. The domain controllers are used on all VMs and users in the domain.

- **Availability sets**. Virtual machines for the SAP Web Dispatcher, SAP application server, and (A)SCS, roles are grouped into separate [availability sets][availability], and at least two virtual machines are provisioned per role. This makes the virtual machines eligible for a higher [service level agreement][sla] (SLA).

- **NICs.** [Network interface cards][nic] (NICs) enable all communication of virtual machines on a virtual network.

- **Network security groups**. To restrict traffic between the various subnets in the virtual network, you can create [network security groups][nsg] (NSGs).

- **Gateway**. A gateway extends your on-premises network to the Azure virtual network. [ExpressRoute][expressroute] is the recommended Azure service for creating private connections that do not go over the public Internet, but a [Site-to-Site][s2s] connection can also be used. 

- **Azure Storage**. To provide persistent storage of a virtual machine’s virtual hard disk (VHD), [Azure Storage][azure-storage] is required. It is also used by [Cloud Witness][cloud-witness] to implement a failover cluster operation.

## Recommendations
Your requirements might differ from the architecture described here. Use these recommendations as a starting point.

### VMs running SAP Web Dispatcher pool
The Web Dispatcher component is used as a load balancer for SAP traffic among the SAP application servers. To achieve high availability for the Web Dispatcher component, Azure Load Balancer is used to implement the parallel Web Dispatcher setup in a round-robin configuration for HTTP(S) traffic distribution among the available Web Dispatchers in the balancers pool. 

For details about running SAP NetWeaver in Azure VMs, see [Azure Virtual Machines planning and implementation for SAP NetWeaver][vm-planning].

### VMs running application servers pool
To manage logon groups for ABAP application servers, the SMLG transaction is used. It uses the load balancing function within the message server of the Central Services to distribute workload among SAP application servers pool for SAPGUIs and RFC traffic. The application server connection to the highly available Central Services  is through the cluster virtual network name. Assigning the cluster virtual network name to the endpoint of this internal load balancer is optional.

### VMs running SAP Central Services cluster
This reference architecture runs Central Services on VMs in the application tier. The Central Services is a potential single point of failure (SPOF) when deployed to a single VM—typical deployment when high availability is not a requirement. To implement a high availability solution, either a shared disk cluster or a file share cluster can be used.

To configure VMs for a shared disk cluster, use [Windows Server Failover Cluster][wsfc]. [Cloud Witness][cloud-witness] is recommended as a quorum witness. To support the failover cluster environment, [SIOS DataKeeper Cluster Edition][sios] performs the cluster shared volume function by replicating independent disks owned by the cluster nodes. Azure does not natively support shared disks and therefore requires solutions provided by SIOS. 

For details, see “3. Important Update for SAP Customers Running ASCS on SIOS on Azure” at [Running SAP applications on the Microsoft platform][running-sap-blog].

Another way to handle clustering is to implement a file share cluster. [SAP][file-share-blog] recently modified the Central Services deployment pattern to access the /sapmnt global directories via a UNC path. This change [removes the requirement][removes-requirement] for SIOS or other shared disk solutions on the Central Services VMs. It is still recommended to ensure that the /sapmnt UNC share is [highly available][sapmnt]. This can be done on the Central Services instance by using Windows Server Failover Cluster with [Scale Out File Server][sofs] (SOFS) and the [Storage Spaces Direct][s2d] (S2D) feature in Windows Server 2016. S2D can implement software-defined storage and eliminates the need for SIOS DataKeeper.


### Availability sets
Availability sets distribute servers to different physical infrastructure and update groups to improve service availability. Put virtual machines that perform the same role into an availability sets to help guard against downtime caused by Azure infrastructure maintenance and to meet [SLAs][sla] (SLAs). Two or more virtual machines per availability set is recommended.

All virtual machines in a set must perform the same role. Do not mix servers of different roles in the same availability set. For example, don’t place a Central Services node in the same availability set with the application server.


### NICs
Traditional on-premises SAP deployments implement multiple network interface cards (NICs) per machine to segregate administrative traffic from business traffic. On Azure, the virtual network is a software-defined network that sends all traffic through the same network fabric. Therefore, the use of multiple NICs is unnecessary.

### Subnets and NSGs
This architecture subdivides the virtual network address space into subnets. This reference architecture focuses primarily on the application tier subnet. Each subnet can be associated with a NSG that defines the access policies for the subnet. Place application servers on a separate subnet so you can secure them more easily by managing the subnet security policies, not the individual servers. 

When a NSG is associated with a subnet, it applies to all the servers within the subnet. For more information about using NSGs for fine-grained control over the servers in a subnet, see [Filter network traffic with network security groups][filter-network].


### Load balancers
[SAP Web Dispatcher][sap-dispatcher] handles load balancing of HTTP(S) traffic to a pool of SAP application servers. 

For traffic from SAP GUI clients connecting a SAP server via DIAG protocol and Remote Function Calls (RFC), the Central Services message server balances the load through SAP application server [logon groups][logon-groups], so no additional load balancer is needed. 

### Azure Storage
For all database server virtual machines, we recommend using Azure Premium Storage for consistent read/write latency. For any single instance virtual machine using Premium Storage for all operating system disks and data disks, see [SLA for Virtual Machines][sla]. Also, for production SAP systems, we recommend using Premium [Azure Managed Disks][managed-disks] in all cases. For reliability, Managed Disks are used to manage the VHD files for the disks. Managed disks ensure that the disks for virtual machines within an availability set are isolated to avoid single points of failure. 

For SAP application servers, including the Central Services virtual machines, you can use Azure Standard Storage to reduce cost, because application execution takes place in memory and disks are used for logging only. However, at this time, Standard Storage is only certified for unmanaged storage. Since application servers do not host any data, you can also use the smaller P4 and P6 Premium Storage disks to help minimize cost.

Azure Storage is also used by [Cloud Witness][cloud-witness] to maintain quorum with a device in a remote Azure region away from the primary region where the cluster resides.

For the backup data store, we recommend using Azure [coolaccess tier][cool-blob-storage] and [archieve access tier][cool-blob-storage] storage. These storage tiers are cost-effective ways to store long-lived data that is infrequently accessed.

### Performance
SAP application servers carry on constant communications with the database servers. For performance-critical applications running on any database platforms, including SAP HANA, consider enabling [Write Accelerator][write-accelerator] to improve log write latency (in preview as of this writing). To optimize inter-server communications, use the [Accelerated Network][accelerated-network]. Note that these accelerators are available only for certain VM series.

To achieve high IOPS and disk bandwidth throughput, the common practices in storage volume [performance optimization][perf-opt] apply to Azure storage layout. For example, combining multiple disks together to create a striped disk volume improves IO performance. Enabling the read cache on storage content that changes infrequently enhances the speed of data retrieval.

For SAP on SQL, the [Top 10 Key Considerations for Deploying SAP Applications on Azure][top-10] blog offers excellent advice on optimizing Azure storage for SAP workloads on SQL Server.

## Scalability considerations
At the SAP application layer, Azure offers a wide range of virtual machine sizes for scaling up and scaling out. For an inclusive list, see [SAP note 1928533][sap-1928533] - SAP Applications on Azure: Supported Products and Azure VM Types. (SAP Service Marketplace account required for access). SAP application servers can scale up or scale down. The Central Services cluster and AnyDB databases only scale out.

## Availability considerations
In this distributed installation of the SAP application, the base installation is replicated to achieve high availability. For each layer of the architecture, the high availability design varies.

### Application tier
High availability for SAP Web Dispatcher is achieved with redundant instances. See [SAP Web Dispatcher][swd] in the SAP Documentation.

High availability of the Central Services is implemented with Windows Server Failover Cluster. When deployed on Azure, the cluster storage for the failover cluster can be configured using two approaches: either a clustered shared volume or a file share.

Since shared disks are not possible on Azure, SIOS Datakeeper is used to replicate the content of independent disks attached to the cluster nodes and to abstract the drives as a cluster shared volume for the cluster manager. For implementation details, see [Clustering SAP ASCS on Azure][clustering].

Another option is to use a file share served up by the [Scale Out Fileserver][sofs] (SOFS). SOFS offers resilient file shares you can use as a cluster shared volume for the Windows cluster. A SOFS cluster can be shared among multiple Central Services nodes. As of this writing, SOFS is used only for high availability design, because the SOFS cluster does not extend across regions to provide disaster recovery support.

High availability for the SAP application servers is achieved by load balancing traffic within a pool of application servers.

See [SAP certifications and configurations running on Microsoft Azure][sap-certifications].

### Database tier
This reference architecture assumes the source database is running on AnyDB—that is, a DBMS such as SQL Server, SAP ASE, IBM DB2, or Oracle. The database tier’s native replication feature provides either manual or automatic failover between replicated nodes. 

For implementation details about specific database systems, see [Azure Virtual Machines DBMS deployment for SAP NetWeaver][vm-dbms]. 

## Disaster recovery considerations
Each tier uses a different strategy to provide disaster recovery (DR) protection.

- **Application servers tier.**SAP application servers do not contain business data. On Azure, a simple DR strategy is to create SAP application servers in the DR region, then shut them down. Upon any configuration changes or kernel updates on the primary application server, the same changes must be copied to the virtual machines in the DR region. For example, the kernel executables copied to the DR virtual machines. For automatic replication of application servers to a DR region, [Azure Site Recovery][asr] is the recommended solution.

- **Central Services.** This component of the SAP application stack also does not persist business data. You can build a VM in the disaster recovery region to run the Central Services role. The only content from the primary Central Services node to synchronize is the /sapmnt share content. Also, if configuration changes or kernel updates take place on the primary Central Services servers, they must be repeated on the VM in the disaster recovery region running Central Services. To synchronize the two servers, you can use either Azure Site Recovery to replicate the cluster nodes or simply use a regularly scheduled copy job to copy /sapmnt to the disaster recovery region. For details about this simple replication method’s build, copy, and test failover process, download [SAP NetWeaver: Building a Hyper-V and Microsoft Azure–based Disaster Recovery Solution][sap-netweaver-dr], and refer to "4.3. SAP SPOF layer (ASCS)."

- **Database tier.** DR is best implemented with the database’s own integrated replication technology. In the case of SQL Server, for example, we recommend using AlwaysOn Availability Group to establish a replica in a remote region, replicating transactions asynchronously with manual failover. Asynchronous replication avoids an impact to the performance of interactive workloads at the primary site. Manual failover offers the opportunity for a person to evaluate the DR impact and decide if operating from the DR site is justified. 

To use Azure Site Recovery to automatically build out a fully replicated production site of your original, you must run customized [deployment scripts][scripts]. Site Recovery first deploys the VMs in availability sets, then runs scripts to add resources such as load balancers. 

## Manageability considerations
Azure provides several functions for [monitoring and diagnostics][monitoring] of the overall infrastructure. Also, enhanced monitoring of Azure virtual machines is handled by Azure Operations Management Suite (OMS).

To provide SAP-based monitoring of resources and service performance of the SAP infrastructure, the [Azure SAP Enhanced Monitoring][sap-enhanced] extension is used. This extension feeds Azure monitoring statistics into the SAP application for operating system monitoring and DBA Cockpit functions. 

## Security considerations
SAP has its own Users Management Engine (UME) to control role-based access and authorization within the SAP application. For details, see [SAP HANA Security - An Overview][sap-security]. (A SAP Service Marketplace account is required for access.)

For infrastructure security, data is encrypted in transit and at rest. The “Security considerations” section of the [SAP NetWeaver on Azure Virtual Machines (VMs) – Planning and Implementation Guide][netweaver-on-azure] begins to address network security. The guide also specifies the network ports you must open on the firewalls to allow application communication. 

To encrypt Windows virtual machine disks, you can use [Azure Disk Encryption][disk-encryption]. It uses the BitLocker feature of Windows to provide volume encryption for the operating system and the data disks. The solution also works with Azure Key Vault to help you control and manage the disk-encryption keys and secrets in your key vault subscription. Data on the virtual machine disks are encrypted at rest in your Azure storage.

## Communities
Communities can answer questions and help you set up a successful deployment. Consider the following:

* [Running SAP Applications on the Microsoft Platform Blog][running-sap-blog]
* [Azure Forum][azure-forum]
* [SAP Community][sap-community]
* [Stack Overflow SAP][stack-overflow]

## Solution deployment
A deployment for this reference architecture is available on [GitHub][gitnub]. It includes documentation in Markdown format as well as code artifacts for the deployment.


  

[accelerated-network]: https://azure.microsoft.com/en-us/blog/linux-and-windows-networking-performance-enhancements-accelerated-networking/
[asr]: /azure/site-recovery/site-recovery-overview
[availability]: /azure/virtual-machines/windows/tutorial-availability-sets
[azure-cli]: https://docs.microsoft.com/en-us/cli/azure/install-azure-cli
[azure-forum]: https://azure.microsoft.com/en-us/support/forums/
[azure-large-instances]: /azure/virtual-machines/workloads/sap/hana-overview-architecture
[azure-lb]: /azure/load-balancer/load-balancer-overview
[azure-storage]: /azure/storage/storage-standard-storage
[azure-trust-center]: https://azure.microsoft.com/en-us/support/trust-center/
[backup-faq]: /azure/backup/backup-azure-backup-faq
[cloud-witness]: https://docs.microsoft.com/en-us/windows-server/failover-clustering/deploy-cloud-witness
[clustering]: https://blogs.msdn.microsoft.com/saponsqlserver/2015/05/20/clustering-sap-ascs-instance-using-windows-server-failover-cluster-on-microsoft-azure-with-sios-datakeeper-and-azure-internal-load-balancer/
[cool-blob-storage]: /azure/storage/storage-blob-storage-tiers
[disk-encryption]: /azure/security/azure-security-disk-encryption
[expressroute]: /azure/architecture/reference-architectures/hybrid-networking/expressroute
[file-share-blog]: https://blogs.sap.com/2018/03/19/migration-from-a-shared-disk-cluster-to-a-file-share-cluster/
[filter-network]: https://azure.microsoft.com/en-us/blog/multiple-vm-nics-and-network-virtual-appliances-in-azure/
[github]: https://github.com/mspnp/reference-architectures/tree/master/sap/sap-hana
[hana-backup]: /azure/virtual-machines/workloads/sap/sap-hana-backup-guide
[hana-guide]: https://help.sap.com/viewer/2c1988d620e04368aa4103bf26f17727/2.0.01/en-US/7eb0167eb35e4e2885415205b8383584.html
[ilb]: /azure/load-balancer/load-balancer-internal-overview
[logon-groups]: https://wiki.scn.sap.com/wiki/display/SI/ABAP+Logon+Group+based+Load+Balancing
[managed-disks]: /azure/storage/storage-managed-disks-overview
[monitoring]: /azure/architecture/best-practices/monitoring
[multiple-vm-nics]: https://azure.microsoft.com/en-us/blog/multiple-vm-nics-and-network-virtual-appliances-in-azure/
[netweaver-on-azure]: /azure/virtual-machines/workloads/sap/planning-guide
[nic]: /azure/virtual-network/virtual-network-network-interface
[nsg]: /azure/virtual-network/virtual-networks-n
[perf-opt]: /azure/virtual-machines/windows/premium-storage-performance
[planning]: /azure/vpn-gateway/vpn-gateway-plan-design
[protecting-sap]: https://blogs.msdn.microsoft.com/saponsqlserver/2016/05/06/protecting-sap-systems-running-on-vmware-with-azure-site-recovery/
[ref-arch]: /azure/architecture/reference-architectures/
[removes-requirement]: https://blogs.msdn.microsoft.com/saponsqlserver/2017/08/10/high-available-ascs-for-windows-on-file-share-shared-disk-no-longer-required/
[running-SAP]: https://blogs.msdn.microsoft.com/saponsqlserver/2016/06/07/sap-on-sql-general-update-for-customers-partners-june-2016/
[running-sap-blog]: https://blogs.msdn.microsoft.com/saponsqlserver/2017/05/04/sap-on-azure-general-update-for-customers-partners-april-2017/
[sap-1943937]: https://launchpad.support.sap.com/#/notes/1943937
[sap-1928533]: https://launchpad.support.sap.com/#/notes/1928533
[sap-cerfications]: /azure/virtual-machines/workloads/sap/sap-certifications
[sap-community]: https://www.sap.com/community.html
[sap-dispatcher]: https://help.sap.com/doc/saphelp_nw73ehp1/7.31.19/en-US/48/8fe37933114e6fe10000000a421937/frameset.htm
[sap-dispatcher-ha]: https://help.sap.com/doc/saphelp_nw73ehp1/7.31.19/en-US/48/9a9a6b48c673e8e10000000a42189b/frameset.htm
[sap-dispatcher-install]: https://wiki.scn.sap.com/wiki/display/SI/Web+Dispatcher+Installation
[sap-enhanced]: /azure/virtual-machines/workloads/sap/deployment-guide#detailed-tasks-for-sap-software-deployment
[sap-guide]: https://service.sap.com/instguides
[sap-ha]: https://support.sap.com/content/dam/SAAP/SAP_Activate/AGS_70.pdf
[sap-hana-on-azure]: https://azure.microsoft.com/en-us/services/virtual-machines/sap-hana/
[sap-netweaver-dr]: http://download.microsoft.com/download/9/5/6/956FEDC3-702D-4EFB-A7D3-2DB7505566B6/SAP%20NetWeaver%20-%20Building%20an%20Azure%20based%20Disaster%20Recovery%20Solution%20V1_5%20.docx
[s2d]: https://blogs.sap.com/2018/03/07/your-sap-on-azure-part-5-ascs-high-availability-with-storage-spaces-direct/
[s2s]: /azure/vpn-gateway/vpn-gateway-howto-site-to-site-resource-manager-portal
[sapmnt]: https://blogs.sap.com/2017/07/21/how-to-create-a-high-available-sapmnt-share/
[sap-security]: https://archive.sap.com/documents/docs/DOC-62943
[scripts]: /azure/site-recovery/site-recovery-runbook-automation
[sios]: https://azuremarketplace.microsoft.com/en-us/marketplace/apps/sios_datakeeper.sios-datakeeper-8
[sla]: https://azure.microsoft.com/support/legal/sla/virtual-machines
[sofs]: https://blogs.msdn.microsoft.com/saponsqlserver/2017/11/14/file-server-with-sofs-and-s2d-as-an-alternative-to-cluster-shared-disk-for-clustering-of-an-sap-ascs-instance-in-azure-is-generally-available/
[stack-overflow]: http://stackoverflow.com/tags/sap/info
[swd]: https://help.sap.com/doc/saphelp_nw70ehp2/7.02.16/en-us/48/8fe37933114e6fe10000000a421937/frameset.htm
[template-bb]: https://github.com/mspnp/template-building-blocks/wiki
[top-10]: https://blogs.msdn.microsoft.com/saponsqlserver/2015/05/25/top-10-key-considerations-for-deploying-sap-applications-on-azure/
[vm-dbms]: /azure/virtual-machines/workloads/sap/dbms-guide
[vm-planning]: /azure/virtual-machines/workloads/sap/planning-guide
[vnet]: /azure/virtual-network/virtual-networks-overview
[white-papers]: https://azure.microsoft.com/en-us/blog/azure-compliance-white-paper-o-rama/
[write-accelerator]: /azure/virtual-machines/workloads/sap/how-to-enable-write-accelerator
[wsfc]: https://blogs.sap.com/2018/01/25/how-to-create-sap-resources-in-windows-failover-cluster/
[0]: ./images/SAP-windows.png "SAP application architecture on Windows using Azure "

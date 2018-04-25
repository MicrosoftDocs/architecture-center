---
title: Deploy SAP S/4HANA on Linux Virtual Machines on Azure
description:  Proven practices for running an SAP application layer on Linux virtual machines in a high availability environment on Azure.
author: njray
ms.date: 4/20/18
---

# Deploy SAP S/4HANA on Linux Virtual Machines on Azure
[!INCLUDE [header](../../_includes/header.md)]

This reference architecture shows a set of proven practices for running S/4HANA in a high availability environment that supports disaster recovery on Azure. This architecture is deployed with specific virtual machine (VM) sizes that can be changed to accommodate your organization’s needs. 

![0][0]


> [!NOTE]
> Deploying SAP products according to this reference architecture requires appropriate licensing of SAP products and other non-Microsoft technologies.


## Architecture

This reference architecture describes a built-out, enterprise-grade, production-level system. To suit your business needs, this configuration can be reduced to a single virtual machine. However, the following components are required:

- **Virtual network**. The [Azure Virtual Network][vnet] service securely connects Azure resources to each other. In this architecture, the virtual network connects to an on-premises environment through a VPN gateway.

- **Subnets**. The virtual network is subdivided into separate [subnets][subnet] for each tier: application (SAP NetWeaver), database, shared services (the jumpbox), and Active Directory.

- **Virtual machines**. This architecture uses virtual machines running Linux for the application tier and database tier, grouped as follows:

   - **Application tier**. Includes the Fiori Front-end Server pool, SAP Web Dispatcher pool, application server pool, and SAP Central Services cluster. For high availability of Central Services on Azure Linux virtual machines, a highly available Network File System (NFS) service is required.

   - **NFS cluster**. This architecture uses an [NFS][nfs] server running on a Linux cluster to store data shared between SAP systems. This centralized cluster can be shared across multiple SAP systems. For high availability of the NFS service, the appropriate High Availability Extension for the selected Linux distribution is used.

   - **SAP HANA**. The database tier uses two or more Linux virtual machines in a cluster to achieve high availability. HANA System Replication (HSR) is used to replicate contents between primary and secondary HANA systems. Linux clustering is used to detect system failures and facilitate automatic failover. A storage-based or cloud-based fencing mechanism can be used to ensure the failed system is isolated or shut down to avoid the cluster split-brain condition.

   - **Jumpbox**. Also called a bastion host. This is a secure virtual machine on the network that administrators use to connect to the other virtual machines. It can run Windows or Linux. Use a Windows jumpbox for web browsing convenience when using HANA Cockpit or HANA Studio management tools.

- **Availability sets**. Virtual machines for all pools and clusters (Web Dispatcher, SAP application servers, Central Services, NFS, and HANA) are grouped into separate [availability sets][availability], and at least two virtual machines are provisioned per role. This makes the virtual machines eligible for a higher [service level agreement][sla] (SLA).

- **NICs.** [Network interface cards][nic] (NICs) enable all communication of virtual machines on a virtual network.

- **Network security groups**. To restrict traffic between the various subnets in the virtual network, you can create [network security groups][nsg] (NSGs).

- **Gateway**. A gateway extends your on-premises network to the Azure virtual network. [ExpressRoute][expressroute] is the recommended Azure service for creating private connections that do not go over the public Internet, but a [Site-to-Site][s2s] connection can also be used. 

- **Azure Storage**. To provide persistent storage of a virtual machine’s virtual hard disk (VHD), [Azure Storage][azure-storage] is required.

## Recommendations
This architecture describes a small production-level enterprise deployment. Your deployment will differ based on your business requirements. Use these recommendations as a starting point.

### Virtual machines
In application server pools and clusters, adjust the number of virtual machines based on your requirements. The [Azure Virtual Machines planning and implementation][vm-planning] guide includes details about running SAP NetWeaver on virtual machines, but the information applies to SAP S/4HANA as well.

For details about SAP support for Azure virtual machine types and throughput metrics (SAPS), see SAP Note [1928533][sap-1928533]. 

### VMs running SAP Web Dispatcher pool
The [Web Dispatcher][swd] component is used as a load balancer for SAP traffic among the SAP application servers. To achieve high availability for the Web Dispatcher component, Azure Load Balancer is used to implement the parallel Web Dispatcher setup in a round-robin configuration for HTTP(S) traffic distribution among the available Web Dispatchers in the balancers back-end pool. 

### VMs running Fiori Front-end Server
The Fiori Front-end Server requires a [NetWeaver Gateway][nw-gateway]. For very large deployments, a separate server for the NetWeaver gateway may be required in front of the Fiori front-end server pool.

### VMs running application servers pool
To manage logon groups for ABAP application servers, the SMLG transaction is used. It uses the load balancing function within the message server of the Central Services to distribute workload among SAP application servers pool for SAPGUIs and RFC traffic. The application server connection to the highly available Central Services is through the cluster virtual network name. This avoids the need to change the application server profile for Central Services connectivity after a local failover. 

### VMs running SAP Central Services cluster
Central Services can be deployed to a single virtual machine when high availability is not a requirement. However, the single virtual machine becomes a potential single point of failure (SPOF) for the SAP environment. For a highly available Central Services deployment, a highly available NFS cluster and a highly available Central Services cluster are used.

### VMs running NFS cluster
DRBD (Distributed Replicated Block Device) is used for replication between the nodes of the NFS cluster.

### Availability sets
Availability sets distribute servers to different physical infrastructure and update groups to improve service availability. Put virtual machines that perform the same role into an availability sets to help guard against downtime caused by Azure infrastructure maintenance and to meet [SLAs][sla] (SLAs). Two or more virtual machines per availability set is recommended.

All virtual machines in a set must perform the same role. Do not mix servers of different roles in the same availability set. For example, don’t place a Central Services node in the same availability set with the application server.

### NICs
Traditional on-premises SAP deployments implement multiple network interface cards (NICs) per machine to segregate administrative traffic from business traffic. On Azure, the virtual network is a software-defined network that sends all traffic through the same network fabric. Therefore, the use of multiple NICs is unnecessary.

### Subnets and NSGs
This architecture subdivides the virtual network address space into subnets. This reference architecture focuses primarily on the application tier subnet. Each subnet can be associated with a NSG that defines the access policies for the subnet. Place application servers on a separate subnet so you can secure them more easily by managing the subnet security policies, not the individual servers. 

When a NSG is associated with a subnet, it applies to all the servers within the subnet. For more information about using NSGs for fine-grained control over the servers in a subnet, see [Filter network traffic with network security groups][filter-network]. See also [Planning and design for VPN Gateway][vpn].

### Load balancers
[SAP Web Dispatcher][sap-dispatcher] handles load balancing of HTTP(S) traffic to a pool of SAP application servers. 

For traffic from SAP GUI clients connecting a SAP server via DIAG protocol and Remote Function Calls (RFC), the Central Services message server balances the load through SAP application server [logon groups][logon-groups], so no additional load balancer is needed. 

### Azure Storage
We recommend using Azure Premium Storage for the database server virtual machines. Premium storage provides consistent read/write latency. For details about using Premium Storage for the operating system disks and data disks of a single-instance virtual machine, see [SLA for Virtual Machines][sla]. 

For all production SAP systems, we recommend using Premium [Azure Managed Disks][managed-disks]. Managed Disks are used to manage the VHD files for the disks, adding reliability. They also ensure that the disks for virtual machines within an availability set are isolated to avoid single points of failure.

For SAP application servers, including the Central Services virtual machines, you can use Azure Standard Storage to reduce cost, because application execution takes place in memory and uses disks for logging only. However, at this time, Standard Storage is only certified for unmanaged storage. Since application servers do not host any data, you can also use the smaller P4 and P6 Premium Storage disks to help minimize cost.

For the backup data store, we recommend using Azure [cool access tier][cool-blob-storage] and [archive access tier][cool-blob-storage] storage. These storage tiers are cost-effective ways to store long-lived data that is infrequently accessed.

### Performance
SAP application servers carry on constant communications with the database servers. For the HANA database virtual machines,consider enabling [Write Accelerator][write-accelerator] to improve log write latency (in preview as of this writing). To optimize inter-server communications, use the [Accelerated Network][accelerated-network]. Note that these accelerators are available only for certain VM series.

To achieve high IOPS and disk bandwidth throughput, the common practices in storage volume [performance optimization][perf-opt] apply to Azure storage layout. For example, combining multiple disks together to create a striped disk volume improves IO performance. Enabling the read cache on storage content that changes infrequently enhances the speed of data retrieval. For details about performance requirements, see SAP note [1943937][sap-1943937] - Hardware Configuration Check Tool (SAP Service Marketplace account required for access).

## Scalability considerations
At the SAP application layer, Azure offers a wide range of virtual machine sizes for scaling up and scaling out. For an inclusive list, see [SAP note 1928533][sap-1928533] - SAP Applications on Azure: Supported Products and Azure VM Types. (SAP Service Marketplace account required for access). As we continue to certify more virtual machines types, you can scale up or down with the same cloud deployment. 

At the database layer, this architecture runs HANA on VMs. If your workload exceeds the maximum VM size, Microsoft also offers [Azure Large Instances][azure-large-instances] for SAP HANA. These physical servers are co-located in a Microsoft Azure certified datacenter and as of this writing, provide up to 20 TB of memory capacity for a single instance. Multi-node configuration is also possible with a total memory capacity of up to 60 TB.

## Availability considerations
In this distributed installation of the SAP application, the base installation is replicated to achieve high availability. For each layer of the architecture, the high availability design varies.

### Application tier
- Web Dispatcher: High availability for SAP Web Dispatcher is achieved with redundant instances. See [SAP Web Dispatcher][swd] in the SAP Documentation.

- Fiori servers: High availability is achieved by load balancing traffic within a pool of servers.

- Central Services: For high availability of Central Services on Azure Linux virtual machines, the appropriate High Availability Extension for the selected Linux distribution is used, and the highly available NFS cluster hosts DRBD storage.

- Application servers: High availability is achieved by load balancing traffic within a pool of application servers.


### Database tier
This reference architecture depicts a highly available SAP HANA database system consisting of two Azure virtual machines. The database tier’s native system replication feature provides either manual or automatic failover between replicated nodes:

- For manual failover, deploy more than one HANA instance and use HANA System Replication (HSR).

- For automatic failover, use both HSR and Linux High Availability Extension (HAE) for your Linux distribution. Linux HAE leverages corosync and [pacemaker][pacemaker] to provide the cluster service to the HANA resources, detect failure events, and orchestrate the failover of errant services to the healthy node. 

See [SAP certifications and configurations running on Microsoft Azure][sap-certifications].

## Disaster recovery considerations
Each tier uses a different strategy to provide disaster recovery (DR) protection.

- **Application servers tier.**SAP application servers do not contain business data. On Azure, a simple DR strategy is to create SAP application servers in the DR region, then shut them down. Upon any configuration changes or kernel updates on the primary application server, the same changes must be copied to the virtual machines in the DR region. For example, the kernel executables copied to the DR virtual machines. For automatic replication of application servers to a DR region, [Azure Site Recovery][asr] is the recommended solution.

- **Central Services.** This component of the SAP application stack also does not persist business data. You can build a VM in the disaster recovery region to run the Central Services role. The only content from the primary Central Services node to synchronize is the /sapmnt share content. Also, if configuration changes or kernel updates take place on the primary Central Services servers, they must be repeated on the VM in the disaster recovery region running Central Services. To synchronize the two servers, you can use either Azure Site Recovery to replicate the cluster nodes or simply use a regularly scheduled copy job to copy /sapmnt to the disaster recovery region. For details about this simple replication method’s build, copy, and test failover process, download [SAP NetWeaver: Building a Hyper-V and Microsoft Azure–based Disaster Recovery Solution][sap-netweaver-dr], and refer to "4.3. SAP SPOF layer (ASCS)."

- **SAP database tier.** Use HSR for HANA-supported replication. In addition to a local, two-node high availability setup, HSR supports multi-tier replication where a third node in a separate Azure region acts as a foreign entity, not part of the cluster, and registers to the secondary replica of the clustered HSR pair as its replication target. This form a replication daisy chain. The failover to the DR node is a manual process.

To use Azure Site Recovery to automatically build out a fully replicated production site of your original, you must run customized [deployment scripts][scripts]. Site Recovery first deploys the VMs in availability sets, then runs scripts to add resources such as load balancers. 

## Manageability considerations
SAP HANA has a backup feature that makes use of the underlying Azure infrastructure. To back up the SAP HANA database running on Azure virtual machines, both the SAP HANA snapshot and Azure storage snapshot are used to ensure the backup files’ consistency. For details, see [Backup guide for SAP HANA on Azure Virtual Machines][backup-guide] and the [Azure Backup service FAQ][backup-faq]. Only HANA single container deployments support Azure storage snapshot.

### Identity management
Control access to resources by using a centralized identity management system at all levels:

- Provide access to Azure resources through [role-based access control][rbac] (RBAC). 
- Grant access to Azure VMs through LDAP, Azure Active Directory, Kerberos, or another system. 
- Support access within the apps themselves through the services that SAP provides, or use [OAuth 2.0 and Azure Active Directory][oauth]. 

### Monitoring
Azure provides several functions for [monitoring and diagnostics][monitoring] of the overall infrastructure. Also, enhanced monitoring of Azure virtual machines (Linux or Windows) is handled by Azure Operations Management Suite (OMS). 

To provide SAP-based monitoring of resources and service performance of the SAP infrastructure, the [Azure SAP Enhanced Monitoring][enhanced-monitoring] extension is used. This extension feeds Azure monitoring statistics into the SAP application for operating system monitoring and DBA Cockpit functions. SAP enhanced monitoring is a mandatory prerequisite to run SAP on Azure. For details, see SAP Note [2191498][sap-2191498] – SAP on Linux with Azure: Enhanced Monitoring.

## Security considerations
SAP has its own Users Management Engine (UME) to control role-based access and authorization within the SAP application. For details, see [SAP HANA Security - An Overview][sap-security]. (A SAP Service Marketplace account is required for access.)

For infrastructure security, data is encrypted in transit and at rest. The “Security considerations” section of the [SAP NetWeaver on Azure Virtual Machines (VMs) – Planning and Implementation Guide][netweaver-on-azure] begins to address network security and applies to S/4HANA. The guide also specifies the network ports you must open on the firewalls to allow application communication. 

To encrypt Windows virtual machine disks, you can use [Azure Disk Encryption][disk-encryption]. It uses the BitLocker feature of Windows to provide volume encryption for the operating system and the data disks. The solution also works with Azure Key Vault to help you control and manage the disk-encryption keys and secrets in your key vault subscription. Data on the virtual machine disks are encrypted at rest in your Azure storage.

For SAP HANA data-at-rest encryption, we recommend using the SAP HANA native encryption technology. 

> [!NOTE]
> Don't use the HANA data-at-rest encryption with Azure disk encryption on the same server.


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
[backup-guide]: /azure/virtual-machines/workloads/sap/sap-hana-backup-guide
[backup-faq]: /azure/backup/backup-azure-backup-faq
[cloud-witness]: https://docs.microsoft.com/en-us/windows-server/failover-clustering/deploy-cloud-witness
[clustering]: https://blogs.msdn.microsoft.com/saponsqlserver/2015/05/20/clustering-sap-ascs-instance-using-windows-server-failover-cluster-on-microsoft-azure-with-sios-datakeeper-and-azure-internal-load-balancer/
[cool-blob-storage]: /azure/storage/storage-blob-storage-tiers
[disk-encryption]: /azure/security/azure-security-disk-encryption
[enhanced-monitoring]: /azure/virtual-machines/workloads/sap/deployment-guide#d98edcd3-f2a1-49f7-b26a-07448ceb60ca
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
[nfs]: /azure/virtual-machines/workloads/sap/high-availability-guide-suse-nfs?branch=pr-en-us-32903
[nic]: /azure/virtual-network/virtual-network-network-interface
[nsg]: /azure/virtual-network/virtual-networks-n
[nw-gateway]: https://help.sap.com/doc/saphelp_gateway20sp12/2.0/en-US/76/08828d832e4aa78748e9f82204a864/content.htm?no_cache=true
[oauth]: /azure/active-directory/develop/active-directory-protocols-oauth-code
[pacemarker]: /azure/virtual-machines/workloads/sap/high-availability-guide-suse-pacemaker
[perf-opt]: /azure/virtual-machines/windows/premium-storage-performance
[planning]: /azure/vpn-gateway/vpn-gateway-plan-design
[protecting-sap]: https://blogs.msdn.microsoft.com/saponsqlserver/2016/05/06/protecting-sap-systems-running-on-vmware-with-azure-site-recovery/
[rbac]: /azure/active-directory/role-based-access-control-what-is
[ref-arch]: /azure/architecture/reference-architectures/
[removes-requirement]: https://blogs.msdn.microsoft.com/saponsqlserver/2017/08/10/high-available-ascs-for-windows-on-file-share-shared-disk-no-longer-required/
[running-SAP]: https://blogs.msdn.microsoft.com/saponsqlserver/2016/06/07/sap-on-sql-general-update-for-customers-partners-june-2016/
[running-sap-blog]: https://blogs.msdn.microsoft.com/saponsqlserver/2017/05/04/sap-on-azure-general-update-for-customers-partners-april-2017/
[sap-1943937]: https://launchpad.support.sap.com/#/notes/1943937
[sap-1928533]: https://launchpad.support.sap.com/#/notes/1928533
[sap-2191498]: https://launchpad.support.sap.com/#/notes/2191498
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
[subnet]: /azure/virtual-network/virtual-network-manage-subnet
[swd]: https://help.sap.com/doc/saphelp_nw70ehp2/7.02.16/en-us/48/8fe37933114e6fe10000000a421937/frameset.htm
[template-bb]: https://github.com/mspnp/template-building-blocks/wiki
[top-10]: https://blogs.msdn.microsoft.com/saponsqlserver/2015/05/25/top-10-key-considerations-for-deploying-sap-applications-on-azure/
[vm-dbms]: /azure/virtual-machines/workloads/sap/dbms-guide
[vm-planning]: /azure/virtual-machines/workloads/sap/planning-guide
[vnet]: /azure/virtual-network/virtual-networks-overview
[vpn]: /azure/vpn-gateway/vpn-gateway-plan-design
[white-papers]: https://azure.microsoft.com/en-us/blog/azure-compliance-white-paper-o-rama/
[write-accelerator]: /azure/virtual-machines/workloads/sap/how-to-enable-write-accelerator
[wsfc]: https://blogs.sap.com/2018/01/25/how-to-create-sap-resources-in-windows-failover-cluster/
[0]: ./images/SAP-linux.png "SAP S/4HANA architecture on Azure "

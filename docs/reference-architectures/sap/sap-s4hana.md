---
title: S/4HANA for Linux Virtual Machines on Azure
description: Proven practices for running SAP S/4HANA in a Linux environment on Azure with high availability.
author: lbrader
ms.date: 05/11/2018
---

# SAP S/4HANA for Linux on Azure

This reference architecture shows a set of proven practices for running S/4HANA in a Linux environment on Azure. The architecture is configured for high availability and disaster recovery (HADR).

![](./images/sap-s4hana.png)

 
> [!NOTE] 
> Deploying SAP products according to this reference architecture requires appropriate licensing of SAP products and other non-Microsoft technologies.

# Architecture

The architecture consists of the following components.

**Virtual networks (VNets)**. This architecture uses two VNets in a [hub-spoke](../hybrid-networking/hub-spoke.md) topology. The hub VNet connects to the organization's on-premises network through a virtual network gateway. The spoke VNet contains the SAP applications and database tier. The hub and spoke communicate through [virtual network peering](/azure/virtual-network/virtual-network-peering-overview). 

The hub VNet contains the following subnets:

- **Gateway subnet**. Contains the virtual network gateway. For more information, see [Connect an on-premises network to Azure](../hybrid-networking/index.md).

- **Shared services subnet**. Contains a jumpbox VM, which is used to manage the other VMs. Depending on your requirements, this subnet might also have VMs for other shared services such as patching, IP tables, and backup (not shown). 

- **Identity management subnet**. Contains VMs that perform network authentication, usually either Active Directory domain controllers or Kerberos servers. 

The spoke VNet contains an application subnet and a database subnet.

**Virtual machines**. This architecture uses virtual machines running Linux for the application and database tiers.

- **Application tier**. The application tier includes the Fiori Front-end Server pool, SAP Web Dispatcher pool, application server pool, and SAP Central Services cluster. For high availability of Central Services on Linux VMs, a highly available Network File System (NFS) service is required.

- **NFS cluster**. This architecture uses an [NFS server](/azure/virtual-machines/workloads/sap/high-availability-guide-suse-nfs) running on a Linux cluster to store data shared between SAP systems. This centralized cluster can be shared across multiple SAP systems. For high availability of the NFS service, use the appropriate High Availability Extension for the selected Linux distribution.

- **SAP HANA**. The database tier uses two or more Linux virtual machines in a cluster to achieve high availability. HANA System Replication (HSR) is used to replicate contents between primary and secondary HANA systems. Linux clustering is used to detect system failures and trigger automatic failover. A storage-based or cloud-based fencing mechanism can be used to ensure the failed system is isolated or shut down to avoid the cluster split-brain condition.

- **Jumpbox**. Also called a bastion host. This is a secure virtual machine on the network that administrators use to connect to the other virtual machines. It can run Windows or Linux. Use a Windows jumpbox for web browsing convenience when using HANA Cockpit or HANA Studio management tools.

**Availability sets**. Place the VMs for the SAP Web Dispatcher, SAP application servers, Central Services, NFS, and HANA roles into separate [availability sets](/azure/virtual-machines/virtual-machines-windows-manage-availability). Provision at least two VMs for each role. This makes the VMs eligible for a higher service level agreement (SLA). For more information, see [SLA for Virtual Machines](https://azure.microsoft.com/support/legal/sla/virtual-machines).

**Network security groups (NSGs)**. Use [NSGs](/azure/virtual-network/virtual-networks-nsg) to restrict traffic between the various subnets.

**Gateway**. The gateway extends your on-premises network to the Azure virtual network. We recommend ExpressRoute for creating private connections that do not go over the public Internet, but a virtual private network (VPN) can also be used. For more information, see [Connect an on-premises network to Azure](../hybrid-networking/index.md).

**Paired region**. For disaster recovery (DR), configure a secondary region that can be used to fail over the application and database. See [Disaster recovery considerations](#disaster-recovery-considerations), below.

## Recommendations

Your requirements might differ from the architecture described here. Use these recommendations as a starting point.

### Virtual machines

For the application server pools and clusters, adjust the number of VMs based on your requirements. The [Azure Virtual Machines planning and implementation guide](/azure/virtual-machines/workloads/sap/planning-guide) includes details about running SAP NetWeaver on virtual machines, but the information applies to SAP S/4HANA as well.

For details about SAP support for Azure virtual machine types and throughput metrics (SAPS), see [SAP Note 1928533](https://launchpad.support.sap.com/#/notes/1928533). 

### SAP Web Dispatcher pool

The Web Dispatcher component is used as a load balancer for SAP traffic among the SAP application servers. To achieve high availability for the Web Dispatcher component, place two or more Web Dispatcher VMs behind an Azure Load Balancer. Web Dispatcher uses a round-robin configuration for HTTP(S) traffic distribution among the available Web Dispatchers in the balancers pool

### Fiori Front-end Server

The Fiori Front-end Server uses a [NetWeaver Gateway](https://help.sap.com/doc/saphelp_gateway20sp12/2.0/en-US/76/08828d832e4aa78748e9f82204a864/content.htm). For small deployments, it can be loaded on the Fiori server. For large deployments, consider deploying a separate server for the NetWeaver Gateway in front of the Fiori Front-end Server pool.

### Application servers pool

To manage logon groups for ABAP application servers, the SMLG transaction is used. It uses the load balancing function within the Central Services Message Server to distribute the workload among SAP application servers for SAPGUI and RFC traffic. The application server connects to the Central Services through the cluster virtual network name. This avoids the need to change the application server profile for Central Services connectivity after a local failover.

### SAP Central Services cluster

Central Services can be deployed to a single virtual machine when high availability is not a requirement. However, the single virtual machine becomes a potential single point of failure (SPOF) for the SAP environment. To achieve high availability, configure a Central Services cluster and an NFS cluster.

DRBD (Distributed Replicated Block Device) is used for replication between the nodes of the NFS cluster.

### Availability sets

Availability sets distribute VMs to different physical infrastructure and update groups to improve uptime. Put VMs that perform the same role into an availability set. All VMs within an availability set should perform the same role. Don't mix different roles in the same availability set. For example, don't place a Central Services node in the same availability set as the application server.

### VM disks

For the database server VMs, we recommend using Azure Premium Storage for consistent read/write latency. We recommend using [Managed Disks](/azure/virtual-machines/windows/managed-disks-overview) with Premium tier in all cases. Managed disks ensure that the disks for VMs within an availability set are isolated to avoid single points of failure.

For SAP application servers, including the Central Services VMs, you can use Azure Standard Storage to reduce cost, because application execution takes place in memory and disks are used for logging only. However, at this time, Standard Storage is only certified for unmanaged storage. Since application servers do not host any data, you can also use the smaller P4 and P6 Premium Storage disks to help minimize cost.

### NICs

Traditional on-premises SAP deployments use multiple NICs per machine to segregate administrative traffic from business traffic. On Azure, the virtual network is a software-defined network that sends all traffic through the same network fabric. Therefore, the use of multiple NICs is unnecessary. However, if your organization needs to segregate traffic, you can create multiple NICs per VM and assign the NICs to different subnets, which is controlled with NSGs.

### Subnets and NSGs

Use NSGs to define the access policies for each subnet. When an NSG is associated with a subnet, it applies to all the VMs within the subnet. This allows you to secure VMs more easily by managing network security policies at the level of the subnet, not the individual VM.

For more information about using NSGs for fine-grained control over the VMs in a subnet, see [Filter network traffic with network security groups](/azure/virtual-network/virtual-networks-nsg).

### Load balancers

SAP Web Dispatcher handles load balancing of HTTP(S) traffic to a pool of SAP application servers.

For traffic from SAP GUI clients connecting a SAP server via DIAG protocol or Remote Function Calls (RFC), the Central Services message server balances the load through SAP application server [logon groups](https://wiki.scn.sap.com/wiki/display/SI/ABAP+Logon+Group+based+Load+Balancing), so no additional load balancer is needed.

## Performance considerations

SAP application servers are in constant communication with the database servers. For the HANA database VMs, consider enabling [Write Accelerator](/virtual-machines/linux/how-to-enable-write-accelerator) to improve log write latency. To optimize network communication between VMs, enable [Accelerated Networking](https://docs.microsoft.com/en-us/azure/virtual-network/create-vm-accelerated-networking-cli). Note that not all VM series support Accelerated Networking.

To achieve high IOPS and disk bandwidth throughput, the common practices in storage volume performance optimization apply in Azure. For example:

- Combining multiple disks to create a striped disk volume improves I/O performance. 
- Enabling the read cache on storage content that changes infrequently enhances the speed of data retrieval.

For details about performance requirements, see [SAP note 1943937 - Hardware Configuration Check Tool](https://launchpad.support.sap.com/#/notes/1943937) (requires SAP Service Marketplace account to access).

## Scalability considerations

At the SAP application layer, Azure offers a wide range of virtual machine sizes for scaling up. For an inclusive list, see [SAP note 1928533](https://launchpad.support.sap.com/#/notes/1928533) (requires SAP Service Marketplace account to access). SAP application servers can scale up/down or scale out by adding more instances.

For the database tier, this architecture runs HANA on VMs. If your workload exceeds the maximum VM size, Microsoft also offers [SAP HANA on Azure (Large Instances)](/azure/virtual-machines/workloads/sap/hana-overview-architecture). These physical servers are co-located in a Microsoft Azure certified datacenter and provide up to 20 TB of memory capacity for a single instance. Multi-node configuration is also possible with a total memory capacity of up to 60 TB.

## Availability considerations

For each layer of the architecture, the high availability design varies.

**SAP Web Dispatcher**. High availability is achieved with redundant instances. See [SAP Web Dispatcher](https://help.sap.com/doc/saphelp_nw70ehp2/7.02.16/48/8fe37933114e6fe10000000a421937/frameset.htm) in the SAP Documentation.

**Fiori servers**. High availability is achieved by load balancing traffic within a pool of servers.

**Central Services**. For high availability of Central Services on Linux virtual machines, use the appropriate High Availability Extension (HAE) for the selected Linux distribution. The NFS cluster hosts DRBD storage.

**SAP application servers**. High availability is achieved by load balancing traffic within a pool of application servers.

**HANA database**. This architecture uses two HANA VMs. The native system replication feature in HANA supports either manual or automatic failover.

* For manual failover, use HANA System Replication (HSR). 
* For automatic failover, use both HSR and HAE for your Linux distribution. Linux HAE provides the cluster services to the HANA resources, detecting failure events and orchestrating failover to a healthy node. 

For more information, see [SAP certifications and configurations running on Microsoft Azure](/azure/virtual-machines/workloads/sap/sap-certifications).

## Disaster recovery considerations

For disaster recovery (DR), you must be able to fail over to a secondary region. Each tier uses a different strategy to provide DR protection.

**Application servers.** SAP application servers do not contain business data. A simple DR strategy is to create SAP application servers in the secondary region, and then shut them down. However, any configuration changes or kernel updates on the primary application server must be copied to the VMs in the secondary region. Consider using [Azure Site Recovery](/azure/site-recovery/) to automatically replicate application servers the secondary region.

**Central Services**. Central Services do not persist any business data. You can deploy a VM in the secondary region to run the Central Services role. The only content from the primary Central Services node to synchronize is the /sapmnt share content. In addition, any configuration changes or kernel updates on the primary Central Services servers must be copied to the VM in the secondary region. To synchronize the two servers, you can use Azure Site Recovery to replicate the cluster nodes or simply schedule a job to copy /sapmnt to the disaster recovery region. For details, download the whitepaper [SAP NetWeaver: Building a Hyper-V & Microsoft Azure–based Disaster Recovery Solution](http://download.microsoft.com/download/9/5/6/956FEDC3-702D-4EFB-A7D3-2DB7505566B6/SAP%20NetWeaver%20-%20Building%20an%20Azure%20based%20Disaster%20Recovery%20Solution%20V1_5%20.docx), and refer to section 4.3, SAP SPOF layer (ASCS). This whitepaper shows a Windows configuration but you can implement an equivalent configuration for Linux.

**HANA database**. Use HSR for HANA-supported replication. HSR supports multitier replication. In this configuration, the secondary HANA instance in the primary region is replicated to a third HANA instance in the DR region, using asynchronous replication. This forms a replication daisy chain. Failover to this HANA instance is a manual process.

To use Azure Site Recovery to automatically build out a fully replicated production site of your original, you must run customized deployment scripts. For more information, see [Add Azure Automation runbooks to recovery plans](/azure/site-recovery/site-recovery-runbook-automation). Site Recovery first deploys the VMs in availability sets, then runs scripts to add resources such as load balancers.

SAP HANA has a backup feature that uses the underlying Azure infrastructure. To back up the SAP HANA database, both the SAP HANA snapshot and Azure storage snapshot are used to ensure the consistency of the backup files. For details, see [Backup guide for SAP HANA on Azure Virtual Machines](/azure/virtual-machines/workloads/sap/sap-hana-backup-guide) and the [Azure Backup service FAQ](/azure/backup/backup-azure-backup-faq). Only HANA single container deployments support Azure storage snapshot.

For the backup data store, we recommend Azure [cool access](/azure/storage/blobs/storage-blob-storage-tiers#cool-access-tier) and [archive access](/azure/storage/blobs/storage-blob-storage-tiers#archive-access-tier) storage tiers. These storage tiers are cost-effective ways to store long-lived data that is infrequently accessed.

## Manageability considerations

Control access to resources by using a centralized identity management system at all levels:

- Provide access to Azure resources through [role-based access control](/azure/role-based-access-control/overview) (RBAC). 
- Grant access to Azure VMs through LDAP, Azure Active Directory, Kerberos, or 
another system. 
- Support access within the apps themselves through the services that SAP provides, or use [OAuth 2.0 and Azure Active Directory](/azure/active-directory/develop/active-directory-protocols-oauth-code). 

Azure Operations Management Suite (OMS) provides enhanced monitoring of Azure virtual machines.  

For SAP-based monitoring of resources and service performance of the SAP infrastructure, use the [Azure Enhanced Monitoring Extension for SAP](/azure/virtual-machines/workloads/sap/deployment-guide#d98edcd3-f2a1-49f7-b26a-07448ceb60ca). This extension feeds Azure monitoring statistics into the SAP application for operating system monitoring and DBA Cockpit functions. SAP enhanced monitoring is a mandatory prerequisite to run SAP on Azure. For more information, see [SAP Note 2191498 – SAP on Linux with Azure: Enhanced Monitoring](https://launchpad.support.sap.com/).

## Security considerations

SAP has its own Users Management Engine (UME) to control role-based access and authorization within the SAP application. For details, see [SAP HANA Security - An Overview](https://archive.sap.com/documents/docs/DOC-62943) (requires SAP Service Marketplace account to access).

For additional network security, consider implementing a network DMZ, which uses a network virtual appliance to create a firewall in front of the Web Dispatcher and Fiori Front-End Server subnets. For more information, see [Network DMZ reference architectures](../dmz/index.md).

For infrastructure security, data is encrypted in transit and at rest. For more information, see the Security Considerations section of [Azure Virtual Machines planning and implementation for SAP NetWeaver](/azure/virtual-machines/workloads/sap/planning-guide#security-considerations). (These recommendations also apply to S/4HANA.) That article also specifies the network ports that must be opened on the firewalls to allow application communication.

To encrypt the VM disks, use [Azure Disk Encryption](/azure/security/azure-security-disk-encryption). For Linux VMs, Azure Disk Encryption uses the DM-Crypt feature of Linux to provide volume encryption for the OS and the data disks. It also works with Azure Key Vault to help you control and manage the disk-encryption keys and secrets in your key vault subscription. Data on the VM disks are encrypted at rest in your Azure storage.

For SAP HANA data-at-rest encryption, we recommend using the SAP HANA native encryption technology. 

> [!NOTE]
> Do not use the HANA data-at-rest encryption with Azure Disk Encryption on the same server. For HANA, use only HANA data encryption.

## Communities

Communities can answer questions and help you set up a successful deployment. 

- [Running SAP Applications on the Microsoft Platform Blog](https://blogs.msdn.microsoft.com/saponsqlserver/)
- [Azure Community Support](https://azure.microsoft.com/support/community/)
- [SAP Community](https://www.sap.com/community.html)
- [Stack Overflow](https://stackoverflow.com/tags/sap/)

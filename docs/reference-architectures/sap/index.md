---
title: Deploy SAP NetWeaver and SAP HANA on Azure
description:  Proven practices for running SAP HANA in a high availability environment on Azure.
author: njray
ms.date: 6/29/17
---

# Deploy SAP NetWeaver and SAP HANA on Azure
[!INCLUDE [header](../../_includes/header.md)]

This reference architecture shows a set of proven practices for running SAP HANA in a high availability environment on Azure. 

![0][0]
Figure 1. SAP HANA architecture using Microsoft Azure.


> [!NOTE]
- SAP HANA is certified for production OLAP workloads on Azure GS5-series virtual machines. This reference architecture is for Azure virtual machines in the G-series and M-series and differs from [SAP HANA on Azure Large Instances][azure-large-instances].

- Deployment of this reference architecture requires appropriate licensing of SAP products and other non-Microsoft technologies.

- For information about the partnership between Microsoft and SAP, see [SAP HANA on Azure][sap-hana-on-azure]. 
>

## Architecture

This reference architecture depicts a distributed installation of SAP applications. There are several databases that SAP applications can use, and here the SAP HANA database is described. All the servers in this reference architecture are deployed on Windows virtual machines except the SAP HANA server, which runs Linux. Although this document focuses on a highly available environment within a single Azure region, all components of this architecture can be replicated to secondary regions for disaster recovery purposes.

The architecture consists of the following components.

- **Virtual network**. The Azure Virtual Network service securely connects Azure resources to each other. A virtual network is a representation of your own network in the cloud—that is, a logical isolation of the Azure cloud dedicated to your subscription. The virtual network in this reference architecture connects to an on-premises environment through a VPN gateway.

- **Subnets**. A subnet defines a logical collection of network resources by specifying address ranges within a virtual network. Subnets make it easier to manage and segregate network traffic without impacting performance. Create a separate subnet for each tier: application (SAP NetWeaver), database (SAP HANA), and management (the jumpbox).

- **Availability sets**. These are groups of virtual machines running the same workload. Using availability sets improves the availability of a service during system failure or routine cloud platform maintenance.

- **Load balancers.** The SAP Web Dispatcher component is used as a load balancer  for SAP traffic among the SAP application servers. To achieve high availability of the SWD component, the [Azure Load Balancer][azure-lb] is used to implement the parallel web dispatcher configuration described in the [High Availability of the SAP Web Dispatcher][sap-dispatcher-ha] article.  In this case, the Azure load balancer is configured in a round robin configuration for HTTP(S) traffic distribution among the available SWDs in the cluster or balancers pool. 

- **SMLG.** The internal load balancer in ABAP Central Services (ASCS) is used for balancing the SAP application server pool for SAPGUI and RFC traffic. An Azure [internal load balancer][ilb] is also used to implement the ASCS Windows Server Failover Cluster (WSFC). The application server connection to the highly available ASCS is through the cluster virtual network name. Assigning the cluster virtual network name to the endpoint of this internal load balancer is optional.
    
- **NICs.** Network interface cards (NICs) enable all communication of virtual machines on a virtual network.

- **Network security groups**. To restrict traffic between the various subnets in the virtual network, you can create [network security groups][nsg] (NSGs).

    
- **VPN.** To extend on-premises networks into Azure over a dedicated private connection, a VPN is created. See our [planning and design][planning] recommendations.

    > [!NOTE]
    > [ExpressRoute][expressroute] is the recommended Azure service for creating private connections that do not go over the  public Internet.

   
- **Jumpbox**. In the management subnet, this secure virtual machine on the network (also called a bastion host) allows administrators to connect to the other virtual machines for administrative tasks only.

- **Azure virtual machines**. Windows Azure virtual machines are used for administration and SAP workloads. The database runs on Linux Azure virtual machines.

- **Azure Storage**. Not shown in the architecture diagram above. However, this is required to provide persistent storage of a virtual machine's virtual hard disk (VHD). The VHDs are stored as _unmanaged disks_ in an [Azure Storage][azure-storage] account.

- **SIOS DataKeeper**. To support the WSFC environment, SIOS DataKeeper Cluster Edition performs the cluster shared volume (CSV) function by replicating independent disks owned by the cluster nodes. For details, see “3. Important Update for SAP Customers Running ASCS on SIOS on Azure” at [Running SAP applications on the Microsoft platform][running-sap].

- **SAP NetWeaver**. This application layer performs business logic computation and includes SAP ASCS and the application servers.

- **Database tier**. SAP supports multiple database technologies. This document  focuses on SAP HANA. The SAP HANA in-memory data platform provides high availability at the data tier through the HANA System Replication (HSR) feature, which implements a manual failover.
 

## Recommendations
Your requirements might differ from the architecture described here. Use these recommendations as a starting point.

### SAP application on Azure
The common practice for achieving high availability is through redundancy of critical components. In this distributed installation of the SAP application on a centralized database, the base installation is replicated to achieve high availability. For each layer of the architecture, the high availability design varies depending on the components as follows:

- **Web Dispatcher.** High availability is achieved with redundant SAP Web Dispatcher  instances with SAP application traffic. See [SAP Web Dispatcher][swd] in the SAP Documentation.

- **ASCS.** For high availability of ASCS on Azure Windows virtual machines, WSFC is used with SIOS DataKeeper to implement the cluster shared volume. For implementation details, see [Clustering SAP ASCS on Azure][clustering].

- **Application servers.** High availability is achieved by load balancing traffic within a pool of application servers.

- **Database tier.** For SAP HANA running on Azure, the common approach to  high availability is to implement HSR (not implemented by this deployment). This replication solution doesn't offer automatic failover. To do that, use additional HA extensions from the Linux distribution.

### Availability sets
Putting virtual machines that perform the same role into an availability sets guards against downtime caused by Azure infrastructure maintenance and contributes to meeting [service level agreements][sla] (SLAs). Availability sets help minimize the impact of resource capacity during maintenance. Three or more virtual machines per availability set is recommended.

Remember not to mix servers of different roles in the same availability set. For example, don't place a ASCS node in the same availability set with the application server. When an availability set contains only virtual machines performing the same role, the Azure fabric tries to ensure that the services provided by the servers in the set remain available even during system failure.

### Subnets
Using multiple subnets, you can control different network security profiles in a consistent manner. For example, end users connect to SAP application servers during their normal business operations, but only administrators need access to the database servers. Place application servers on a separate subnet so you can secure them more easily by managing the subnet security policies, not the individual servers.

### Load balancers
[SAP Web Dispatcher][sap-dispatcher] handles load balancing of HTTP(S) traffic to dual-stack servers (ABAP and Java). SAP has advocated single-stack application servers for years, so very few applications run on a dual-stack deployment model nowadays. The Azure Load Balancer depicted in the architecture diagram implements the high availability cluster for the SAP Web Dispatcher.

For traffic from SAPGUI clients connecting a SAP server via DIAG and Remote Function Calls (RFC), the SCS message server balances the load by creating SAP App Server [Logon Groups][logon-groups], so no additional load balancer is needed. 

### NICs
SAP landscape management functions require segregation of server traffic on different NICs. For example, business data should be separated from administrative traffic and backup traffic. Using multiple NICs to connect to different subnets provides the means for data segregation. For more information, see “Networking” in  [Building High Availability for SAP NetWeaver and SAP HANA][sap-ha].

To implement traffic segregation in a virtual machine, each NIC should be connected to a separate subnet. For example, for the SAP application servers, the data communication NIC should be connected to the application server subnet, and the administration NIC should be connected to the management subnet. For configuration details, see [Multiple VM NICs and Network Virtual Appliances in Azure][multiple-vm-nics].

### Network security groups
We recommend connecting servers that perform the same role, such as application servers and database servers, to a single subnet. When a network security group is associated with a subnet, it then applies to all the servers within the subnet. To note exceptions, servers that require a special security profile may be connected to their own subnet and associated with a network security group within the group. For implementation details, see [Filter network traffic with network security groups][filter-network].

### Azure Storage
With all database server virtual machines, we recommend using Azure Premium Storage for consistent read/write latency. For SAP application servers, including the (A)SCS virtual machines, you can use Azure Standard Storage, because application execution takes place in memory and uses disks for logging only.

To achieve high IOPS and disk bandwidth throughput, the common practices in storage volume performance optimization apply to Azure storage layout. For example, striping multiple disks together to create a larger disk volume improves IO performance. Enabling the read cache on storage content that changes infrequently enhances the speed of data retrieval. For details about performance requirements, see [SAP note 1943937 - Hardware Configuration Check Tool][sap-1943937].

For the backup data store, we recommend using Azure [cool blob storage][cool-blob-storage]. The cool storage tier is a cost-effective way to store data that is less frequently accessed and long-lived.

  > [!IMPORTANT]
    > We recommend the use of [managed disks][managed-disks]. Managed disks do not require a storage account. You simply specify the size and type of disk and it is deployed in a highly available way. Our [reference architectures][ref-arch] do not currently deploy managed disks but the [template building blocks][template-bb] will be updated to deploy managed disks in version 2.
    > 

## Scalability considerations
At the SAP application layer, Azure offers a wide range of virtual machine sizes for scaling up and scaling out. For an inclusive list, see [SAP note 1928533 - SAP Applications on Azure: Supported Products and Azure VM Types][sap-1928533].

For SAP HANA on Azure virtual machines with both OLTP and OLAP SAP applications, the SAP-certified virtual machine size is GS5 single instance. As larger virtual machines become available, you can scale up with the same cloud deployment. For larger workloads, Microsoft also offers [Azure Large Instances][azure-large-instances] for SAP HANA on physical servers co-located in a Microsoft Azure certified datacenter, which provides up to 4 TB of memory capacity for a single instance at this time. Multi-node configuration is also possible with a total memory capacity of up to 32 TB.

## Availability considerations
This reference architecture deploys a single instance database on Azure GS5-series virtual machines. The database tier's native system replication feature provides either manual or automatic failover between replicated nodes. To further lower unplanned downtime on Linux-based database systems, a high availability extension for the specific Linux distribution is required.

## Disaster recovery considerations
In an SAP three-tier deployment, each tier uses a different strategy to provide disaster recovery (DR) protection.

- **Application servers tier.** SAP application servers don't contain business data. On Azure, a simple DR strategy is to create SAP application servers in the DR region, then shut them down.  Upon any configuration changes or kernel updates on the primary application server, the same changes must be copied to VMs in the DR region. For example, the kernel executables copied to the DR VMs.

- **SAP Central Services.** This component of the SAP application stack also doesn't persist business data. You can build a VM in the DR region to run the SCS role. The only content from the primary SCS node to synchronize is the **/sapmnt** share content. Also, if configuration changes or kernel updates take place on the primary SCS servers, they must be repeated on the DR SCS. To synchronize the two servers, simply use a regularly scheduled copy job to copy **/sapmnt** to the DR side. For details about the build, copy, and test failover process, download [SAP NetWeaver: Building a Hyper-V and Microsoft Azure–based Disaster Recovery Solution][sap-netweaver-dr], and refer to "4.3. SAP SPOF layer (ASCS)."

- **SAP database tier.** Use the database-specific replication solution. With HANA, use HANA-supported replication solutions such as HSR or Storage Replication. 

## Manageability considerations
SAP HANA has a backup feature that makes use of the underlying Azure infrastructure. To back up the SAP HANA database running on Azure virtual machines, both the SAP HANA snapshot and Azure storage snapshot are used to ensure the backup files' consistency. For details, see [Backup guide for SAP HANA on Azure Virtual Machines][hana-backup] and the [Azure Backup service FAQ][backup-faq].

Azure provides several functions for [monitoring and diagnostics][monitoring] of the overall infrastructure. Also, enhanced monitoring of Azure virtual machines (Linux or Windows) is handled by Azure Operations Management Suite (OMS).

To provide SAP-based monitoring of resources and service performance of the SAP infrastructure, the Azure SAP Enhanced Monitoring extension is used. This extension feeds Azure monitoring statistics into the SAP application for operating system monitoring and DBA Cockpit functions. 

## Security considerations
SAP has its own Users Management Engine (UME) to control role-based access and authorization within the SAP application. For details, see [SAP HANA Security - An Overview][sap-security]. (A SAP Service Marketplace account is required for access.)

For infrastructure security, data is safeguarded in transit and at rest. The “Security considerations” section of the [SAP NetWeaver on Azure Virtual Machines (VMs) – Planning and Implementation Guide][netweaver-on-azure] begins to address network security. The guide also specifies the network ports you must open on the firewalls to allow application communication. 

To encrypt Windows and Linux IaaS virtual machine disks, you can use [Azure Disk Encryption][disk-encryption], now in general availability in all Azure public regions and AzureGov regions for Standard virtual machines and virtual machines with Premium storage. Azure Disk Encryption uses the BitLocker feature of Windows and the DM-Crypt feature of Linux to provide volume encryption for the operating system and the data disks. The solution also works with Azure Key Vault to help you control and manage the disk-encryption keys and secrets in your key vault subscription. Data on the virtual machine disks are encrypted at rest in your Azure storage.

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

> [!NOTE]
> 
> You need access to the SAP Software Download Center to carry out the application and HANA database installations.

### Prerequisites

* Before deploying this reference architecture, verify that your subscription has sufficient quota. If you don't have enough cores, use the Azure portal to submit a support request for more quota.

* To estimate the cost of this deployment, see the [Azure Pricing Calculator][azure-pricing]. This reference architecture deploys the following:

| Resource name            | Purpose                                                                                                                                 | VM     |
|--------------------------|-----------------------------------------------------------------------------------------------------------------------------------------|--------|
| ```ra-sap-wdp-vm1```     | SAP Web Dispatcher instance                                                                                                             | DS11v2 |
| ```ra-sap-wdp-vmN```     | Virtual machiness for Web Dispatcher  (where _N_ is an incrementing number based on the number of virtual machines you deployed).       | DS11v2 |
| ```ra-sap-data-vm1```    | SAP HANA database instance                                                                                                              | GS5    |
| ```ra-sapApps-scs-vm1``` | SAP Central Services                                                                                                                    | DS11v2 |
| ```ra-sapApps-scs-vmN``` | Virtual machines for SCS  (where _N_ is an incrementing number based on the number of virtual machines you deployed).                   | DS11v2 |
| ```ra-sapApps-vm1```     | SAP NetWeaver application                                                                                                               | DS11v2 |
| ```ra-sapApps-vmN```     | Virtual machines associated with NetWeaver  (where _N_ is an incrementing number based on the number of virtual machines you deployed). | DS11v2 |

### Deploy SAP infrastructure
To run the PowerShell script that deploys this architecture, use the latest version of the Azure [command line interface][azure-cli] (CLI).

You can deploy this architecture incrementally or all at once. The first time, we recommend an incremental deployment so you can see what each deployment step does. Specify the increment in the order shown, using one of the following *mode* parameters:

| Mode           | What it does                                                                                                            |
|----------------|-----------------------------------------------------|
| infrastructure | Deploys the network infrastructure in Azure.        |
| workload       | Deploys the SAP servers to the network.             |
| security       | Deploys the network security group to the network.  |
| all            | Deploys all the preceding deployments.              |


1. Download or clone the .zip file containing all the files and folders from the [GitHub][github] repository.

2. In the **parameters** folder, customize each parameter file according to your needs.

3. Open a PowerShell console and navigate to the folder where you downloaded the script and parameter files.

4. Run the cmdlet below using your own subscription ID, location, operating system type, and resource group name. For \<mode\>, specify `infrastructure`, `workload`, `security`, or `all`.

```
 .\Deploy-ReferenceArchitecture -SubscriptionId <id> -Location <location> -ResourceGroupName <resource group> <mode>
```

5.  When prompted, log on to your Azure account. The deployment scripts start to run and can take a couple hours to complete depending on the mode you selected.

### Configure SAP applications and database
After deploying the SAP infrastructure, install and configure your SAP applications and HANA database on the virtual machines as described below.

> [!NOTE]
> For SAP installation instructions, you must have a SAP Support Portal username and password to download the [SAP installation guides][sap-guide].

1.  Sign-in to the virtual machine named **ra-sap-wdp-vm1**.

    1.  Install and configure the SAP Web Dispatcher instance using the steps described in the [Web Dispatcher Installation][sap-dispatcher-install] wiki.

    2.  Repeat for the rest of the virtual machines named **ra-sap-wdp-vmN** (where N is an incrementing number based on the number of virtual machines you deployed).

2.  Sign-in to the virtual machine named **ra-sap-data-vm1**.

    1.  Install and configure the SAP Hana Database instance using the [SAP HANA Server Installation and Update Guide][hana-guide].

3.  Sign-in to the virtual machine named **ra-sapApps-scs-vm1**.

    1.  Install and configure the SAP Central Services (SCS) using the [SAP installation guides][sap-guide].

    2.  Repeat for the rest of the virtual machines named **ra-sapApps-scs-vmN** (where N is an incrementing number based on the number of virtual machines you deployed).

4.  Sign-in to the virtual machine named **ra-sapApps-vm1**.

    1.  Install and configure the SAP NetWeaver application using the [SAP installation guides][sap-guide].

    2.  Repeat for the rest of the virtual machines named **ra-sapApps-vmN** (where N is an incrementing number based on the number of virtual machines you deployed).
  



[azure-cli]: https://docs.microsoft.com/en-us/cli/azure/install-azure-cli
[azure-forum]: https://azure.microsoft.com/en-us/support/forums/
[azure-large-instances]: /azure/virtual-machines/workloads/sap/hana-overview-architecture
[azure-lb]: /azure/load-balancer/load-balancer-overview
[azure-storage]: /azure/storage/storage-standard-storage
[azure-trust-center]: https://azure.microsoft.com/en-us/support/trust-center/
[backup-faq]: /azure/backup/backup-azure-backup-faq
[clustering]: https://blogs.msdn.microsoft.com/saponsqlserver/2015/05/20/clustering-sap-ascs-instance-using-windows-server-failover-cluster-on-microsoft-azure-with-sios-datakeeper-and-azure-internal-load-balancer/
[cool-blob-storage]: /azure/storage/storage-blob-storage-tiers
[disk-encryption]: /azure/security/azure-security-disk-encryption
[expressroute]: /azure/architecture/reference-architectures/hybrid-networking/expressroute
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
[nsg]: /azure/virtual-network/virtual-networks-n
[planning]: /azure/vpn-gateway/vpn-gateway-plan-design
[protecting-sap]: https://blogs.msdn.microsoft.com/saponsqlserver/2016/05/06/protecting-sap-systems-running-on-vmware-with-azure-site-recovery/
[ref-arch]: /azure/architecture/reference-architectures/
[running-SAP]: https://blogs.msdn.microsoft.com/saponsqlserver/2016/06/07/sap-on-sql-general-update-for-customers-partners-june-2016/
[running-sap-blog]: https://blogs.msdn.microsoft.com/saponsqlserver/2017/05/04/sap-on-azure-general-update-for-customers-partners-april-2017/
[sap-1943937]: https://launchpad.support.sap.com/#/notes/1943937
[sap-1928533]: https://launchpad.support.sap.com/#/notes/1928533
[sap-community]: https://www.sap.com/community.html
[sap-dispatcher]: https://help.sap.com/doc/saphelp_nw73ehp1/7.31.19/en-US/48/8fe37933114e6fe10000000a421937/frameset.htm
[sap-dispatcher-ha]: https://help.sap.com/doc/saphelp_nw73ehp1/7.31.19/en-US/48/9a9a6b48c673e8e10000000a42189b/frameset.htm
[sap-dispatcher-install]: https://wiki.scn.sap.com/wiki/display/SI/Web+Dispatcher+Installation
[sap-guide]: https://service.sap.com/instguides
[sap-ha]: https://support.sap.com/content/dam/SAAP/SAP_Activate/AGS_70.pdf
[sap-hana-on-azure]: https://azure.microsoft.com/en-us/services/virtual-machines/sap-hana/
[sap-netweaver-dr]: http://download.microsoft.com/download/9/5/6/956FEDC3-702D-4EFB-A7D3-2DB7505566B6/SAP%20NetWeaver%20-%20Building%20an%20Azure%20based%20Disaster%20Recovery%20Solution%20V1_5%20.docx
[sap-security]: https://archive.sap.com/documents/docs/DOC-62943
[sla]: https://azure.microsoft.com/support/legal/sla/virtual-machines
[stack-overflow]: http://stackoverflow.com/tags/sap/info
[swd]: https://help.sap.com/doc/saphelp_nw70ehp2/7.02.16/en-us/48/8fe37933114e6fe10000000a421937/frameset.htm
[template-bb]: https://github.com/mspnp/template-building-blocks/wiki
[white-papers]: https://azure.microsoft.com/en-us/blog/azure-compliance-white-paper-o-rama/
[0]: ./images/sap-hana.png "SAP HANA architecture using Microsoft Azure"
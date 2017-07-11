---
title: Deploy SAP NetWeaver and SAP HANA on Azure
description:  Proven practices for running SAP HANA in a high availability environment on Azure.
author: njray
ms.date: 6/29/17
---

# Deploy SAP NetWeaver and SAP HANA on Azure

This reference architecture shows a set of proven practices for running SAP HANA in a high availability environment on Azure. [**Deploy this solution**.](#deploy-the-solution)

![0][0]

> [!NOTE]
> Deploying this reference architecture requires appropriate licensing of SAP products and other non-Microsoft technologies. For information about the partnership between Microsoft and SAP, see [SAP HANA on Azure][sap-hana-on-azure].

## Architecture

The architecture consists of the following components.

- **Virtual network (VNet)**. A VNet is a representation of a logically isolated network in Azure. All of the VMs in this reference architecture are deployed to the same VNet. The VNet is further subdivided into subnets. Create a separate subnet for each tier, including application (SAP NetWeaver), database (SAP HANA), management (the jumpbox), and Active Directory.

- **Virtual machines (VMs)**. The VMs for this architecture are grouped into several distinct tiers.

    - **SAP NetWeaver**. Includes SAP ASCS, SAP Web Dispatcher, and the SAP application servers. 
    
    - **SAP HANA**. This reference architecture uses SAP HANA for the database tier, running on a single [GS5][vm-sizes-mem] instance. SAP HANA is certified for production OLAP workloads on GS5 or [SAP HANA on Azure Large Instances][azure-large-instances]. This reference architecture is for Azure virtual machines in the G-series and M-series. For information about SAP HANA on Azure Large Instances, see [SAP HANA (large instances) overview and architecture on Azure][azure-large-instances].
   
    - **Jumpbox**. Also called a bastion host. This is a secure VM on the network that administrators use to connect to the other VMs. 
     
    - **Windows Server Active Directory (AD) domain controllers.** The domain controllers are used to configure the Windows Server Failover Cluster (see below).
 
- **Availability sets**. Place the VMs for the SAP Web Dispatcher, SAP application server, and SAP ACSC roles into separate availability sets, and provision at least two VMs for each role. This makes the VMs eligible for a higher service level agreement (SLA).
    
- **NICs.** The VMs that run SAP NetWeaver and SAP HANA require two network interfaces (NICs). Each NIC is assigned to a different subnet, to segregate different types of traffic. See [Recommendations](#recommendations) below for more information.

- **Windows Server Failover Cluster**. The VMs that run SAP ACSC are configured as a failover cluster for high availability. To support the failover cluster, SIOS DataKeeper Cluster Edition performs the cluster shared volume (CSV) function by replicating independent disks owned by the cluster nodes. For details, see [Running SAP applications on the Microsoft platform][running-sap].
    
- **Load balancers.** Two [Azure Load Balancer][azure-lb] instances are used. The first, shown on the left of the diagram, distributes traffic to the SAP Web Dispatcher VMs. This configuration implements the parallel web dispatcher option described in [High Availability of the SAP Web Dispatcher][sap-dispatcher-ha]. The second load balancer, shown on the right, enables failover in the Windows Server Failover Cluster, by directing incoming connections to the active/healthy node.

- **VPN Gateway.** The VPN Gateway extends your on-premises network to the Azure VNet. You can also use ExpressRoute, which uses a dedicated private connection that does not go over the public Internet. The example solution does not deploy the gateway. For more information, see [Connect an on-premises network to Azure][hybrid-networking].

## Recommendations

Your requirements might differ from the architecture described here. Use these recommendations as a starting point.

### Load balancers

[SAP Web Dispatcher][sap-dispatcher] handles load balancing of HTTP(S) traffic to dual-stack servers (ABAP and Java). SAP has advocated single-stack application servers for years, so very few applications run on a dual-stack deployment model nowadays. The Azure load balancer shown in the architecture diagram implements the high availability cluster for the SAP Web Dispatcher.

Load balancing of traffic to the application servers is handled within SAP. For traffic from SAPGUI clients connecting to a SAP server via DIAG and Remote Function Calls (RFC), the SCS message server balances the load by creating SAP App Server [Logon Groups][logon-groups]. 

SMLG is an SAP ABAP transaction used to manage the logon load balancing capability of SAP Central Services. The backend pool of the logon group has more than one ABAP application server. Clients accessing ASCS cluster services connect to the Azure load balancer through a frontend IP address. The ASCS cluster virtual network name also has an IP address. Optionally, this address can be associated with an additional IP address on the Azure load balancer, so that the cluster can be managed remotely.  

### NICs

SAP landscape management functions require segregation of server traffic on different NICs. For example, business data should be separated from administrative traffic and backup traffic. Assigning multiple NICs to different subnets enables this data segregation. For more information, see "Network" in [Building High Availability for SAP NetWeaver and SAP HANA][sap-ha] (PDF).

Assign the administration NIC to the management subnet, and assign the data communication NIC to a separate subnet. For configuration details, see [Create and manage a Windows virtual machine that has multiple NICs][multiple-vm-nics].

### Azure Storage

With all database server VMs, we recommend using Azure Premium Storage for consistent read/write latency. For SAP application servers, including the (A)SCS virtual machines, you can use Azure Standard Storage, because application execution takes place in memory and uses disks for logging only.

For best reliability, we recommend using [Azure Managed Disks][managed-disks]. Managed disks ensure that the disks for VMs within an availability set are isolated to avoid single points of failure.

> [!NOTE]
> Currently the Resource Manager template for this reference architecture does not use managed disks. We are planning to update the template to use managed disks.

To achieve high IOPS and disk bandwidth throughput, the common practices in storage volume performance optimization apply to Azure storage layout. For example, striping multiple disks together to create a larger disk volume improves IO performance. Enabling the read cache on storage content that changes infrequently enhances the speed of data retrieval. For details about performance requirements, see [SAP note 1943937 - Hardware Configuration Check Tool][sap-1943937].

For the backup data store, we recommend using the [cool storage tier][cool-blob-storage] of Azure Blob storage. The cool storage tier is a cost-effective way to store data that is less frequently accessed and long-lived.

## Scalability considerations

At the SAP application layer, Azure offers a wide range of virtual machine sizes for scaling up. For an inclusive list, see [SAP note 1928533 - SAP Applications on Azure: Supported Products and Azure VM Types][sap-1928533]. Scale out by adding more VMs to the availability set.

For SAP HANA on Azure virtual machines with both OLTP and OLAP SAP applications, the SAP-certified virtual machine size is GS5 with a single VM instance. For larger workloads, Microsoft also offers [Azure Large Instances][azure-large-instances] for SAP HANA on physical servers co-located in a Microsoft Azure certified datacenter, which provides up to 4 TB of memory capacity for a single instance at this time. Multi-node configuration is also possible with a total memory capacity of up to 32 TB.

## Availability considerations

In this distributed installation of the SAP application on a centralized database, the base installation is replicated to achieve high availability. For each layer of the architecture, the high availability design varies:

- **Web Dispatcher.** High availability is achieved with redundant SAP Web Dispatcher instances with SAP application traffic. See [SAP Web Dispatcher][swd] in the SAP Documentation.

- **ASCS.** For high availability of ASCS on Azure Windows virtual machines, Windows Sever Failover Clustering is used with SIOS DataKeeper to implement the cluster shared volume. For implementation details, see [Clustering SAP ASCS on Azure][clustering].

- **Application servers.** High availability is achieved by load balancing traffic within a pool of application servers.

- **Database tier.** This reference architecture deploys a single SAP HANA database instance. For high availability, deploy more than one instance and use HANA System Replication (HSR) to implement manual failover. To enable automatic failover, an HA extension for the specific Linux distribution is required.

### Disaster recovery considerations

Each tier uses a different strategy to provide disaster recovery (DR) protection.

- **Application servers.** SAP application servers don't contain business data. On Azure, a simple DR strategy is to create SAP application servers in another region. Upon any configuration changes or kernel updates on the primary application server, the same changes must be copied to VMs in the DR region. For example, the kernel executables copied to the DR VMs.

- **SAP Central Services.** This component of the SAP application stack also doesn't persist business data. You can build a VM in the DR region to run the SCS role. The only content from the primary SCS node to synchronize is the **/sapmnt** share content. Also, if configuration changes or kernel updates take place on the primary SCS servers, they must be repeated on the DR SCS. To synchronize the two servers, simply use a regularly scheduled copy job to copy **/sapmnt** to the DR side. For details about the build, copy, and test failover process, download [SAP NetWeaver: Building a Hyper-V and Microsoft Azure–based Disaster Recovery Solution][sap-netweaver-dr], and refer to "4.3. SAP SPOF layer (ASCS)."

- **Database tier.** Use HANA-supported replication solutions such as HSR or Storage Replication. 

## Manageability considerations

SAP HANA has a backup feature that uses the underlying Azure infrastructure. To back up the SAP HANA database running on Azure virtual machines, both the SAP HANA snapshot and Azure storage snapshot are used to ensure the consistency of backup files. For details, see [Backup guide for SAP HANA on Azure Virtual Machines][hana-backup] and the [Azure Backup service FAQ][backup-faq].

Azure provides several functions for [monitoring and diagnostics][monitoring] of the overall infrastructure. Also, enhanced monitoring of Azure virtual machines (Linux or Windows) is handled by Azure Operations Management Suite (OMS).

To provide SAP-based monitoring of resources and service performance of the SAP infrastructure, use the Azure SAP Enhanced Monitoring extension. This extension feeds Azure monitoring statistics into the SAP application for operating system monitoring and DBA Cockpit functions. 

## Security considerations

SAP has its own Users Management Engine (UME) to control role-based access and authorization within the SAP application. For details, see [SAP HANA Security - An Overview][sap-security]. (A SAP Service Marketplace account is required for access.)

For infrastructure security, data is safeguarded in transit and at rest. The “Security considerations” section of the [SAP NetWeaver on Azure Virtual Machines (VMs) – Planning and Implementation Guide][netweaver-on-azure] begins to address network security. The guide also specifies the network ports you must open on the firewalls to allow application communication. 

To encrypt Windows and Linux IaaS virtual machine disks, you can use [Azure Disk Encryption][disk-encryption]. Azure Disk Encryption uses the BitLocker feature of Windows and the DM-Crypt feature of Linux to provide volume encryption for the operating system and the data disks. The solution also works with Azure Key Vault to help you control and manage the disk-encryption keys and secrets in your Key Vault subscription. Data on the virtual machine disks are encrypted at rest in your Azure storage.

For SAP HANA data-at-rest encryption, we recommend using the SAP HANA native encryption technology.

> [!NOTE]
> Don't use the HANA data-at-rest encryption with Azure disk encryption on the same server.

Consider using [network security groups][nsg] (NSGs) to restrict traffic between the various subnets in the VNet.

## Deploy the solution 

The deployment scripts for this reference architecture are available on [GitHub][github].


### Prerequisites

- You must have access to the SAP Software Download Center to complete the installation.
 
- Install the latest version of [Azure PowerShell][azure-ps]. 

- Before deploying, verify that your subscription has sufficient quota for VM cores. If not, use the Azure portal to submit a support request for more quota.

- To estimate the cost of this deployment, see the [Azure Pricing Calculator][azure-pricing]. 
 
This reference architecture deploys the following VMs:

| Resource name | VM Size | Purpose  |
|---------------|---------|----------|
| `ra-sapApps-scs-vm1` ... `ra-sapApps-scs-vmN` | DS11v2 | SAP Central Services |
| `ra-sapApps-vm1` ... `ra-sapApps-vmN` | DS11v2 | SAP NetWeaver application |
| `ra-sap-wdp-vm1` ... `ra-sap-wdp-vmN` | DS11v2 | SAP Web Dispatcher |
| `ra-sap-data-vm1` | GS5 | SAP HANA database instance |
| `jumpbox-vm1` | DS1V2 | Jumpbox |

A single SAP HANA instance is deployed. For the application VMs, the number of instances to deploy is specified in the template parameters.

### Deploy SAP infrastructure

You can deploy this architecture incrementally or all at once. The first time, we recommend an incremental deployment, so that you can see what each deployment step does. Specify the increment using one of the following *mode* parameters

| Mode           | What it does                                                                                                            |
|----------------|-----------------------------------------------------|
| infrastructure | Deploys the network infrastructure in Azure.        |
| workload       | Deploys the SAP servers to the network.             |
| all            | Deploys all the preceding deployments.              |

To deploy the solution, perform the following steps:

1. Download or clone [GitHub repo][github] to your local computer.

2. Open a PowerShell window and navigate to the `/sap/sap-hana/` folder.

3. Run the following PowerShell cmdlet. For `subscription id`, use your Azure subscription ID. For `<location>`, specify an Azure region, such as `eastus` or `westus`. For `<mode>`, specify one of the modes listed above.

    ```powershell
     .\Deploy-ReferenceArchitecture -SubscriptionId <subscription id> -Location <location> -ResourceGroupName <resource group> <mode>
    ```

4.  When prompted, log on to your Azure account. 

The deployment scripts can take up to several hours to complete, depending on the mode you selected.

> [!WARNING]
> The parameter files include a hard-coded password (`AweS0me@PW`) in various places. Change these values before you deploy.
 
### Configure SAP applications and database

After deploying the SAP infrastructure, install and configure your SAP applications and HANA database on the virtual machines as follows.

> [!NOTE]
> For SAP installation instructions, you must have a SAP Support Portal username and password to download the [SAP installation guides][sap-guide].

1. Log into the jumpbox (`jumpbox-vm1`). You will use the jumpbox to log into the other VMs. 

2.  For each VM named `ra-sap-wdp-vm1` ... `ra-sap-wdp-vmN`, log into the VM, and install and configure the SAP Web Dispatcher instance using the steps described in the [Web Dispatcher Installation][sap-dispatcher-install] wiki.

3.  Log into the VM named `ra-sap-data-vm1`. Install and configure the SAP Hana Database instance using the [SAP HANA Server Installation and Update Guide][hana-guide].

4. For each VM named `ra-sapApps-scs-vm1` ... `ra-sapApps-scs-vmN`, log into the VM, and install and configure the SAP Central Services (SCS) using the [SAP installation guides][sap-guide].

5.  For each VM named `ra-sapApps-vm1` ... `ra-sapApps-vmN`, log into the VM, and install and configure the SAP NetWeaver application using the [SAP installation guides][sap-guide].



[azure-large-instances]: /azure/virtual-machines/workloads/sap/hana-overview-architecture
[azure-lb]: /azure/load-balancer/load-balancer-overview
[azure-pricing]: https://azure.microsoft.com/pricing/calculator/
[azure-ps]: /powershell/azure/overview
[backup-faq]: /azure/backup/backup-azure-backup-faq
[clustering]: https://blogs.msdn.microsoft.com/saponsqlserver/2015/05/20/clustering-sap-ascs-instance-using-windows-server-failover-cluster-on-microsoft-azure-with-sios-datakeeper-and-azure-internal-load-balancer/
[cool-blob-storage]: /azure/storage/storage-blob-storage-tiers
[disk-encryption]: /azure/security/azure-security-disk-encryption
[github]: https://github.com/mspnp/reference-architectures/tree/master/sap/sap-hana
[hana-backup]: /azure/virtual-machines/workloads/sap/sap-hana-backup-guide
[hana-guide]: https://help.sap.com/viewer/2c1988d620e04368aa4103bf26f17727/2.0.01/en-US/7eb0167eb35e4e2885415205b8383584.html
[hybrid-networking]: ../hybrid-networking/index.md
[logon-groups]: https://wiki.scn.sap.com/wiki/display/SI/ABAP+Logon+Group+based+Load+Balancing
[managed-disks]: /azure/storage/storage-managed-disks-overview
[monitoring]: /azure/architecture/best-practices/monitoring
[multiple-vm-nics]: /azure/virtual-machines/windows/multiple-nics
[netweaver-on-azure]: /azure/virtual-machines/workloads/sap/planning-guide
[nsg]: /azure/virtual-network/virtual-networks-nsg
[running-SAP]: https://blogs.msdn.microsoft.com/saponsqlserver/2016/06/07/sap-on-sql-general-update-for-customers-partners-june-2016/
[sap-1943937]: https://launchpad.support.sap.com/#/notes/1943937
[sap-1928533]: https://launchpad.support.sap.com/#/notes/1928533
[sap-dispatcher]: https://help.sap.com/doc/saphelp_nw73ehp1/7.31.19/en-US/48/8fe37933114e6fe10000000a421937/frameset.htm
[sap-dispatcher-ha]: https://help.sap.com/doc/saphelp_nw73ehp1/7.31.19/en-US/48/9a9a6b48c673e8e10000000a42189b/frameset.htm
[sap-dispatcher-install]: https://wiki.scn.sap.com/wiki/display/SI/Web+Dispatcher+Installation
[sap-guide]: https://service.sap.com/instguides
[sap-ha]: https://support.sap.com/content/dam/SAAP/SAP_Activate/AGS_70.pdf
[sap-hana-on-azure]: https://azure.microsoft.com/en-us/services/virtual-machines/sap-hana/
[sap-netweaver-dr]: http://download.microsoft.com/download/9/5/6/956FEDC3-702D-4EFB-A7D3-2DB7505566B6/SAP%20NetWeaver%20-%20Building%20an%20Azure%20based%20Disaster%20Recovery%20Solution%20V1_5%20.docx
[sap-security]: https://archive.sap.com/documents/docs/DOC-62943
[vm-sizes-mem]: /azure/virtual-machines/windows/sizes-memory
[swd]: https://help.sap.com/doc/saphelp_nw70ehp2/7.02.16/en-us/48/8fe37933114e6fe10000000a421937/frameset.htm
[0]: ./images/sap-hana.png "SAP HANA architecture using Microsoft Azure"
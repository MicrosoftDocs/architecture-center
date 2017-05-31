---
title: Deploy SAP NetWeaver and SAP HANA on Azure
description:  This Microsoft Azure reference architecture shows a set of proven practices for running SAP HANA in a high availability environment on Azure.
author: njray
ms.date: 05/30/17
---

# Deploy SAP NetWeaver and SAP HANA on Azure
[!INCLUDE [header](../../_includes/header.md)]

This reference architecture shows a set of proven practices for running SAP HANA in a high availability environment on Azure. 

![0][0]
Figure 1. SAP HANA architecture using Microsoft Azure.

\* For details about SMLG and Azure Load Balancer, see the “Load balancer” item
in the following “Architecture” section.

> [!NOTE]
-   SAP HANA is certified for production OLAP workloads on Azure GS5-series
    virtual machines. This reference architecture is for Azure virtual machines
    in the G-series and M-series and differs from [SAP HANA on Azure Large Instances][azure-large-instances].

-   Deployment of this reference architecture requires appropriate licensing of
    SAP products and other non-Microsoft technologies.

-   For information about the partnership between Microsoft and SAP, see [SAP HANA on Azure][sap-hana-on-azure]. 
>

## Architecture

This reference architecture depicts a distributed installation of SAP applications on a SAP HANA database. Although this document focuses on a highly available environment within a single Azure region, all components of this architecture may be replicated to secondary regions for disaster recovery purposes.

The architecture consists of the following components.

-   **Virtual network**. The Azure Virtual Network service securely connects
    Azure resources to each other. A virtual network is a representation of your
    own network in the cloud—that is, a logical isolation of the Azure cloud
    dedicated to your subscription. You can also connect virtual networks to
    your network on premises.

-   **Subnets**. A subnet defines a logical collections of network resources by
    specifying address ranges within a virtual network. Subnets make it easier
    to manage and segregate network traffic without impacting performance. For
    example, you can create a separate subnet for each tier: application (SAP
    NetWeaver), database (SAP HANA), and management (the jumpbox).

-   **Availability sets**. These are groups of virtual machines performing the
    same role. Using availability sets improves the availability of a service
    during system failure or routine cloud platform maintenance.


-	**Load balancers.** [Azure Load Balancer][azure-lb] (shown on the left in Figure 1) is used in a round-robin configuration for
    HTTP or HTTPS traffic distribution among the SAP application servers of the
    same type (either ABAP or Java). SMLG, the internal load balancer in ABAP
    Central Services (ASCS), is used for balancing the SAP application server
    pool.  An Azure [internal load balancer][ilb] (shown on the right in Figure 1) is also used to implement the ASCS Windows
    Server Failover Cluster (WSFC). The application server connection to the
    highly available ASCS is through the cluster virtual network name. Assigning
    the cluster virtual network name to the endpoint of this internal load
    balancer is optional.

-	**NICs.** Network interface cards (NICs) enable all communication of virtual
    machines on a virtual network.

-   **Network security groups**. To restrict traffic between the various subnets
    in the virtual network, you can create [network security
    groups][nsg] (NSGs).

    
-	**VPN.** To extend on-premises networks into Azure over a dedicated private
    connection, a VPN is created. See our [planning and design][planning] recommendations.

    > [!NOTE]
    > [ExpressRoute][expressroute] is the recommended Azure service for creating private connections that do not go over the public Internet.
    > 
   
-   **Jumpbox**. In the management subnet, this secure virtual machine on the
    network (also called a bastion host) allows administrators to connect to the
    other virtual machines for administrative tasks only.

-   **Azure virtual machines**. Windows Azure virtual machines are used for
    administration and SAP workloads. The SAP HANA database runs on Linux Azure
    virtual machines.

-   **Azure Storage**. This is a persistent store. The operating system, SAP
    application, and business data are stored in [Azure Storage][azure-storage].

-   **SIOS DataKeeper**. To support the WSFC environment, SIOS DataKeeper
    Cluster Edition performs the cluster shared volume (CSV) function by
    replicating independent disks owned by the cluster nodes. For details, see
    “3. Important Update for SAP Customers Running ASCS on SIOS on Azure” at
    [Running SAP applications on the Microsoft
    platform][running-sap].

-   **SAP NetWeaver**. This application layer performs business logic
    computation and includes SAP ASCS and the application servers.

-   **SAP HANA**. This SAP in-memory data platform provides high availability at
    the data tier through the HANA System Replication (HSR) feature, which
    implements a manual failover.
 

## Recommendations
Your requirements might differ from the architecture described here. Use these recommendations as a starting point.

### SAP application on Azure
The common practice for achieving high availability is through redundancy of
critical components. In this distributed installation of the SAP application on
a SAP HANA database, the base installation is replicated to achieve high
availability. For each layer of the architecture, the high availability design
varies depending on the components as follows:

-	**ASCS.** For high availability of ASCS on Azure Windows virtual machines,
    WSFC is used with SIOS DataKeeper to implement the cluster shared volume.
    For implementation details, see [Clustering SAP ASCS on Azure][clustering].

- **Application servers.** High availability is achieved by load balancing
    traffic within a pool of application servers.

-	**HANA database.** The HSR feature provides native database-level
    replication. Automatic failover is possible with HA extensions from the
    operating system vendor. 

### Availability sets
Putting virtual machines that perform the same role into an availability sets
guards against downtime caused by Azure infrastructure maintenance and
contributes to meeting [service level agreements][sla] (SLAs). Availability sets help minimize the impact of resource capacity during
maintenance. Three or more virtual machines per availability set is recommended.

Remember not to mix servers of different roles in the same availability set. For
example, don’t place a ASCS node in the same availability set with the
application server. When an availability set contains only virtual machines
performing the same role, the Azure fabric tries to ensure that the services
provided by the servers in the set remain available even during system failure.

### Subnets
Using multiple subnets, you can control different network security profiles in a
consistent manner. For example, end users connect to SAP application servers
during their normal business operations, but only administrators need access to
the database servers. Place application servers on a separate subnet so you can
secure them more easily by managing the subnet security policies, not the
individual servers.

### Load balancers
Azure Load Balancer or SAP Web Dispatcher can distribute HTTP(S) connections to
the application server pool among servers of the same type, either ABAP or Java. [SAP Web Dispatcher][sap-dispatcher]. handles load balancing of HTTP(S) traffic to dual-stack servers (ABAP and Java). SAP has advocated single-stack application servers for years, so very few
applications run on a dual-stack deployment model.

For traffic from SAPGUI clients connecting a SAP server via DIAG and Remote
Function Calls (RFC), the SCS message server balances the load by creating SAP
App Server [Logon Groups][logon-groups], so no additional load balancer is needed. 

### NICs
SAP landscape management functions require segregation of server traffic on
different NICs. For example, business data should be separated from
administrative traffic and backup traffic. Please refer to the [SAP LandScape
Management (LaMa) 3.0
announcement][lama].
Using multiple NICs to connect to different subnets provides the means for data
segregation. For more information, see “Networking” in  [Building High Availability for SAP NetWeaver and SAP HANA][sap-ha].

To implement traffic segregation in a virtual machine, each NIC should be
connected to a separate subnet. For example, for the SAP application servers,
the data communication NIC should be connected to the application server subnet,
and the administration NIC should be connected to the management subnet. For
configuration details, see [Multiple VM NICs and Network Virtual Appliances in Azure][multiple-vm-nics].

### Network security groups
We recommend connecting servers that perform the same role, such as application
servers and database servers, to a single subnet. When a network security group
is associated with a subnet, it then applies to all the servers within the
subnet. To note exceptions, servers that require a special security profile may
be connected to their own subnet and associated with a network security group
within the group. For implementation details, see  [Filter network traffic with network security groups][filter-network].

### Azure Storage
With all database server virtual machines, we recommend using Azure Premium
Storage for consistent read/write latency. For SAP application servers including
the (A)SCS virtual machines, we recommend using Azure Standard Storage, because
application execution takes place in memory and uses disks for logging only.

Each Azure blob has an IOPS quota. The common practices in storage volume
performance optimization applies to Azure storage layout. For example, striping
multiple disks together to create a larger disk volume improves IO performance.
Enabling the read cache on storage content that changes infrequently enhances
the speed of data retrieval.

For the backup data store, we recommend using Azure [cool blob storage][cool-blob-storage].
The cool storage tier is a cost-effective way to store data that is less
frequently accessed and long-lived.

For simplicity, we recommend using [Azure Managed Disks][managed-disks] to manage the storage associated with the virtual machine disks. For the entire
deployment, use Premium storage for all disk performance-dependent workloads

We recommend using Managed Disks for all layers of the SAP application stack.
The Managed Disks service makes it much simpler to deploy your virtual machines.
For example, you no longer need to set up additional storage accounts per
virtual machine to handle limits (such as 20,000 IOPS per account), because
Managed Disks handles storage behind the scenes. Managed Disks also makes sure
the disks of virtual machines in an availability set are sufficiently isolated
from each other to avoid single points of failure.

## Scalability considerations
t the SAP application layer, Azure offers a wide range of virtual machine sizes
for scaling up and scaling out. Please see SAP note 1928533 for an inclusive
list.

For SAP HANA on Azure virtual machines with both OLTP and OLAP SAP applications,
the SAP-certified virtual machine size is GS5 single instance. As larger virtual
machines become available, you can scale up with the same cloud deployment. For
larger workloads, Microsoft also offers [Azure Large
Instances][azure-large-instances] for SAP HANA on physical servers co-located in a Microsoft Azure certified
datacenter, which provides up to 4 TB of memory capacity for a single instance
at this time. Multi-node configuration is also possible with a total memory
capacity of up to 32 TB.

## Availability considerations
A SAP HANA native system replication feature provides manual failover. To
further lower unplanned downtime, a high availability extension for the specific
Linux distribution is required.

## Disaster recovery considerations
Azure Site Recovery (ASR) is effective in replicating both Windows and Linux SAP
application servers onto a remote region for disaster recovery (DR). Don’t use
ASR to replicate database content, however. As a virtual machine replication
technology, ASR can’t guarantee database consistency for recovery. Instead, use
a native database replication technology such a SQL Always On Availability Group
or Log Shipping. Or, in the case of SAP HANA DB, use HSR across Azure regions
for database replication. For implementation details, review the blog,
[Protecting SAP Systems Running on VMware with Azure Site Recovery][protecting-sap].

In addition, ASR can’t be used to replicate clustered nodes. For the SCS layer,
use either a three-node geo-cluster (see SAP reference implementation note
1634991), or simply schedule a batch job to copy the `/sapmnt` content to the DR
region. The sapmnt file-share is an SAP share that contains application server
executables and logs, but no SAP business transactional data. The copies refresh
the `/sapmnt` share of a prebuilt SCS node to keep kernel executables in sync with
the SCS in the primary region.

## Operational considerations
SAP HANA has a backup feature that makes use of the underlying Azure
infrastructure. To back up the SAP HANA database running on Azure virtual
machines, both the SAP HANA snapshot and Azure storage snapshot are used to
ensure the backup files’ consistency. For details, see [Backup guide for SAP HANA on Azure Virtual Machines][hana-backup] and the [Azure Backup service FAQ][backup-faq].

Azure provides several functions for [monitoring and diagnostics][monitoring] of the overall infrastructure. Also, enhanced monitoring of Azure virtual
machines (Linux or Windows) is handled by Azure Operations Management Suite
(OMS).

To provide SAP-based monitoring of resources and service performance of the SAP
infrastructure, the Azure SAP Enhanced Monitoring extension is used. This
extension feeds Azure monitoring statistics into the SAP application for
operating system monitoring and DBA Cockpit functions. 

## Security considerations
SAP has its own Users Management Engine (UME) to control role-based access and
authorization within the SAP application. For details, see [SAP HANA Security - An Overview][sap-security]. (A SAP Service Marketplace account is required for access.)

For infrastructure security, data is safeguarded in transit and at rest. The
“Security considerations” section of the [SAP NetWeaver on Azure Virtual Machines (VMs) – Planning and Implementation Guide][netweaver-on-azure] begins to address network security. The guide also specifies the network ports
you must open on the firewalls to allow application communication. 

To encrypt Windows and Linux IaaS virtual machine disks, you can use [Azure Disk Encryption][disk-encryption],
now in general availability in all Azure public regions and AzureGov regions for
Standard virtual machines and virtual machines with Premium storage. Azure Disk
Encryption uses the BitLocker feature of Windows and the DM-Crypt feature of
Linux to provide volume encryption for the operating system and the data disks.
The solution also works with Azure Key Vault to help you control and manage the
disk-encryption keys and secrets in your key vault subscription. Data on the
virtual machine disks are encrypted at rest in your Azure storage.

For SAP HANA data-at-rest encryption, we recommend using the SAP HANA native
encryption technology.

> [!NOTE]
> Don’t use the HANA data-at-rest encryption with Azure disk encryption on the same server.
> 
>


## Compliance considerations
Azure as an infrastructure platform is compliant with many security and regulatory requirements. For more information, see the [Azure Trust Center][azure-trust-center]. For guidelines about implementing compliance, see the list of [white papers][white-papers] on the Azure blog. 

## Communities
Communities can answer questions and help you set up a successful deployment. Consider the following:

* [Running SAP Applications on the Microsoft Platform Blog][running-sap-blog]
* [Azure Forum][azure-forum]
* [SAP Community][sap-community]
* [Stack Overflow SAP][stack-overflow]

## Solution deployment
A deployment for this reference architecture is available on GitHub. It includes
documentation in Markdown format as well as code artifacts for the deployment.

> [!NOTE]
> 
> You need access to the SAP Software Download Center to carry out the
application and HANA database installations.
> 

### Deploy SAP infrastructure
To deploy this reference architecture, you can use PowerShell, bash, or the
Azure portal. To do so using your own parameter files, follow the instructions
below.

1. Download all the files and folders in this folder.
2. In the **parameters** folder, customize each parameter file according to your needs.
3. Follow the steps in one of the following sections to deploy your solution.

#### Use Azure portal
1. Copy your parameters files to a URI that is publicly accessible.
2. Right-click **Deploy to Azure** below and select either **Open link in new tab** or **Open link in new window**.
   [![Deploy to Azure](/azure/guidance/_images/blueprints/deploybutton.png)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fmspnp%2Freference-architectures%2Flarry%2Fsap%2Fsap%2Fsap-hana%2Fazuredeploy.json)
3. In the Azure portal, enter values for the following settings: 
   
   * For **Subscription**, choose the subscription you want to use for your deployment.
   * For **Resource group**, select **Create New** and enter the name you defined in your parameters file.
   * In the **Location** box, select a region for your deployment.
   * In the **Parameter Root Uri** box, enter the URL of the public location where you copied your parameter files. 
   * Review the terms and conditions, then click the **I agree to the terms and conditions stated above** checkbox.
   * Click the **Purchase** button, then wait for the deployment to finish. The deployment status is shown under **Notifications**.

#### Use PowerShell
1. Open a PowerShell console and navigate to the folder where you downloaded
    the script and parameter files.
2. Run the cmdlet below using your own subscription ID, location, operating
    system type, and resource group name.

```
 .\Deploy-ReferenceArchitecture -SubscriptionId <id> -Location <location> -ResourceGroupName <resource group> 
```

#### Bash
1. Open a bash console and navigate to the folder where you downloaded the
    script and parameter files.
2. Run the command below using your own subscription ID, location, operating
    system type, and resource group name.

```
 sh deploy-reference-architecture.sh -s <subscription id> -l <location> -r <resource group> 
```

### Configure SAP applications and database
After deploying the SAP infrastructure as described above, you need to install
and configure your SAP applications and HANA database on the virtual machines as
described below.

> [!NOTE]
> For SAP installation instructions, you must have a SAP Support Portal username and password to download the [SAP installation guides][sap-guide].
> 
>

1.  Sign-in to the virtual machine named `ra-sap-data-vm1`.

    1.  Install and configure the SAP Hana Database instance using the
        [SAP HANA Server Installation and Update Guide][hana-guide].

2.  Sign-in to the virtual machine named `ra-sapApps-scs-vm1`.

    1.  Install and configure the SAP Central Services (SCS) using the
        [SAP installation guides][sap-guide].

    2.  Repeat step 2 for the rest of the virtual machines named
        `ra-sapApps-scs-vmN` (where N is an incrementing number based on the
        number of virtual machines you deployed).

3.  Sign-in to the virtual machine named `ra-sapApps-vm1`.

    1.  Install and configure the SAP NetWeaver application using the
        [SAP installation guides][sap-guide].

4.  Repeat step 3 for the rest of the virtual machines named `ra-sapApps-vmN`
    (where N is an incrementing number based on the number of virtual machines
    you deployed).

  




[azure-forum]: https://azure.microsoft.com/en-us/support/forums/
[azure-large-instances]: /azure/virtual-machines/workloads/sap/hana-overview-architecture
[azure-lb]: /azure/load-balancer/load-balancer-overview
[azure-storage]: /azure/storage/storage-introduction
[azure-trust-center]: https://azure.microsoft.com/en-us/support/trust-center/
[backup-faq]: /azure/backup/backup-azure-backup-faq
[clustering]: https://blogs.msdn.microsoft.com/saponsqlserver/2015/05/20/clustering-sap-ascs-instance-using-windows-server-failover-cluster-on-microsoft-azure-with-sios-datakeeper-and-azure-internal-load-balancer/
[cool-blob-storage]: /azure/storage/storage-blob-storage-tiers
[disk-encryption]: /azure/security/azure-security-disk-encryption
[expressroute]: /azure/architecture/reference-architectures/hybrid-networking/expressroute
[filter-network]: https://azure.microsoft.com/en-us/blog/multiple-vm-nics-and-network-virtual-appliances-in-azure/
[hana-backup]: /azure/virtual-machines/workloads/sap/sap-hana-backup-guide
[hana-guide]: https://help.sap.com/viewer/2c1988d620e04368aa4103bf26f17727/2.0.01/en-US/7eb0167eb35e4e2885415205b8383584.html
[lama]: https://blogs.sap.com/2017/03/07/announcing-general-availability-of-sap-landscape-management-3.0/
[ilb]: /azure/load-balancer/load-balancer-internal-overview
[logon-groups]: https://wiki.scn.sap.com/wiki/display/SI/ABAP+Logon+Group+based+Load+Balancing
[managed-disks]: /azure/storage/storage-managed-disks-overview
[monitoring]: /azure/architecture/best-practices/monitoring
[multiple-vm-nics]: https://azure.microsoft.com/en-us/blog/multiple-vm-nics-and-network-virtual-appliances-in-azure/
[netweaver-on-azure]: /azure/virtual-machines/workloads/sap/planning-guide
[nsg]: /azure/virtual-network/virtual-networks-n
[planning]: /azure/vpn-gateway/vpn-gateway-plan-design
[protecting-sap]: https://blogs.msdn.microsoft.com/saponsqlserver/2016/05/06/protecting-sap-systems-running-on-vmware-with-azure-site-recovery/
[running-SAP]: https://blogs.msdn.microsoft.com/saponsqlserver/2016/06/07/sap-on-sql-general-update-for-customers-partners-june-2016/
[running-sap-blog]: https://blogs.msdn.microsoft.com/saponsqlserver/2017/05/04/sap-on-azure-general-update-for-customers-partners-april-2017/
[sap-community]: https://www.sap.com/community.html
[sap-dispatcher]: https://help.sap.com/doc/saphelp_nw73ehp1/7.31.19/en-US/48/8fe37933114e6fe10000000a421937/frameset.htm
[sap-guide]: https://service.sap.com/instguides
[sap-ha]: https://support.sap.com/content/dam/SAAP/SAP_Activate/AGS_70.pdf
[sap-hana-on-azure]: https://azure.microsoft.com/en-us/services/virtual-machines/sap-hana/
[sap-security]: https://archive.sap.com/documents/docs/DOC-62943
[sla]: https://azure.microsoft.com/support/legal/sla/virtual-machines
[stack-overflow]: http://stackoverflow.com/tags/sap/info
[white-papers]: https://azure.microsoft.com/en-us/blog/azure-compliance-white-paper-o-rama/
[0]: ../_images/SAP-HANA-RA-diagram.png "SAP HANA architecture using Microsoft Azure"
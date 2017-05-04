---
title: Deploy SAP NetWeaver and SAP HANA on Azure
description:  This Microsoft Azure reference architecture shows a set of proven practices for running SAP HANA in a high availability environment on Azure.
author: njray
ms.date: 05/02/17
---

# Deploy SAP NetWeaver and SAP HANA on Azure
[!INCLUDE [header](../../_includes/header.md)]

This reference architecture shows a set of proven practices for running SAP HANA in a high availability environment on Azure. 

![0][0]
Figure 1. SAP HANA architecture using Microsoft Azure.

> [!NOTE]
> Deployment of this reference architecture requires appropriate licensing of SAP products and other non-Microsoft technologies.
> 
>

## Architecture

This reference architecture depicts a distributed installation of SAP applications on a SAP HANA database. Although this document focuses on a highly available environment within a single Azure region, all components of this architecture may be replicated to secondary regions for disaster recovery purposes.

The architecture consists of the following components.

-	**Virtual network.** The Azure Virtual Network service securely connects Azure resources to each other. A virtual network is a representation of your own network in the cloud—that is, a logical isolation of the Azure cloud dedicated to your subscription. You can also connect virtual networks to your network on premises. 
-	**Subnets.** A subnet defines a logical collections of network resources by specifying address ranges within a virtual network. Subnets make it easier to manage and segregate network traffic. For example, you can create a separate subnet for each tier: application (SAP NetWeaver), database (SAP HANA), and management (the jumpbox).
-	**Availability sets.** These are groups of VMs performing the same role. Using availability sets improves the availability of a service during system failure or routine cloud platform maintenance. 
-	**Load balancers.** [Azure Load Balancer][azure-lb] distributes HTTP or HTTPS traffic among the SAP application servers of the same type (either ABAP or Java). An Azure [internal load balancer][ilb] is also used to implement the virtual network name for Windows Server Failover Cluster (WSFC).
-	**NICs.** Network interface cards (NICs) enable all communication of VMs on a virtual network.
-	Network security groups. To restrict traffic between the various subnets in the virtual network, you can create [network security groups][nsg] (NSGs).
-	**VPN.** Use this network connectivity option to allow secure network traffic between an on-premises network and an Azure virtual network. See our [planning and design][planning] recommendations.
-	**Jumpbox.** In the management subnet, this secure virtual machine on the network (also called a bastion host) allows administrators to connect to the other virtual machines for administrative tasks only.
-	**Azure virtual machines.** Windows Azure VMs are used for administration and SAP workloads. The SAP HANA database runs on Linux Azure VMs.
-	**Azure Storage.** This is a persistent store. The operating system, SAP application, and business data are stored in [Azure Storage][azure-storage].
-	**SIOS DataKeeper.** To support the WSFC environment, SIOS DataKeeper Cluster Edition performs the cluster shared volume (CSV) function by replicating independent disks owned by the cluster nodes.
-	**SAP Netweaver.** This application layer performs business logic computation and includes SAP Central Services (SCS) and the application servers.
-	**SAP HANA.** This SAP in-memory data platform provides high availability at the data tier through the HANA System Replication (HSR) feature, which implements a manual failover. 

## Recommendations
Your requirements might differ from the architecture described here. Use these recommendations as a starting point.

### SAP application on Azure
The common practice for achieving high availability is through redundancy of critical components. In this distributed installation of the SAP application on a SAP HANA database, the base installation is replicated to achieve high availability. The high availability design of each layer of the architecture varies depending on the components as follows:

-	**SCS.** For high availability of SCS on Azure Windows VMs, WSFC is used with SIOS DataKeeper to implement the cluster shared volume. For implementation details, please see [Clustering SAP ASCS on Azure][clustering].
- **Application servers.** High availability is achieved by load balancing traffic within a pool of identical servers. 
-	**HANA database.** The HSR feature provides basic replication. Automatic failover is possible with HA extensions from the operating system vendor. 

### Availability sets
Putting VMs that perform the same role into an availability sets guards against downtime caused by Azure infrastructure maintenance and contributes to meeting [service level agreements][sla] (SLAs). Availability sets help minimize the impact of resource capacity during maintenance. Three or more VMs per availability set is recommended.

As a reminder, don’t mix servers of different roles in the same availability set. For example, don’t place a SCS node in the same availability set with the application server. When an availability set contains only VMs performing the same role, the Azure fabric tries to ensure that the services provided by the servers in the set remain available even during system failure.

### Subnets
Using multiple subnets, you can control different network security profiles in a consistent manner. For example, end users connect to SAP application servers during their normal business operations, but only administrators need access to the database servers. Place application servers on a separate subnet so you can secure them more easily by simply managing the subnet security policies, not the individual servers.

### Load balancers
Azure Load Balancer or SAP Web Dispatcher can distribute HTTP(S) connections to the application server pool among servers of the same type, either ABAP or Java. To load balance HTTP(S) traffic to dual-stack servers (ABAP and Java), use the [SAP Web Dispatcher][sap-dispatcher]. 

For traffic from SAPGUI clients connecting a SAP server via DIAG and Remote Function Calls (RFC), the SCS message server balances the load by creating SAP App Server [Logon Groups][logon-groups], so no additional load balancer is needed. 

### NICs
SAP landscape management functions require segregation of server traffics on different NICs. For example, business data should be separated from administrative traffic and backup traffic. Using multiple NICs to connect to different subnets provides the means for data segregation. For more information, please see “Networking” in [Building High Availability for SAP NetWeaver and SAP HANA][sap-ha].

To implement traffic segregation in a VM, each NIC should be connected to a separate subnet. For example, for the SAP application servers, the data communication NIC should be connected to the application server subnet, and the administration NIC should be connected to the management subnet. For configuration details, please see [Multiple VM NICs and Network Virtual Appliances in Azure][multiple-vm-nics].

### Network security groups
We recommend connecting servers that perform the same role, such as application servers and database servers, to a single subnet. An NSG can be associated with the subnet and will then apply to all the servers within the subnet. If there are exceptions, those servers that require a special security profile may be connected to their own subnet and with an NSG for that group. For implementation details, please see [Filter network traffic with network security groups][filter-network].

### Azure Storage
With all database server VMs, we recommend using Azure Premium Storage for consistent read/write latency. For SAP application servers including the SCS VMs, we recommend using Azure Standard Storage, because application execution takes place in memory and uses disks for logging only.

## Scalability considerations
At the SAP application layer, Azure offers a wide range of virtual machine sizes for scaling up and scaling out. Please see SAP note 1928533 for an inclusive list. 

For SAP HANA on Azure VM with both OLTP and OLAP SAP applications, the SAP-certified VM size is GS5 single instance. Larger VMs are coming soon, and scaling up will be possible. For larger workloads, Microsoft also offers the Azure Large Instances for SAP HANA on physical servers co-located in a Microsoft Azure certified datacenter, which provide up to 4 TB of memory capacity for a single instance at this time. Multi-node configuration is also possible with a total memory capacity of up to 32 TB.

## Availability considerations
SAP HANA native system replication feature provides manual failover. To further lower unplanned downtime, a high availability extension for the specific Linux distribution is required.

## Disaster recovery considerations
Azure Site Recovery (ASR) is effective in replicating both Windows and Linux SAP application servers onto a remote region for disaster recovery. Don’t use ASR to replicate database content, however. As a VM replication technology, ASR can’t guarantee database consistency for recovery. Instead, use a native database replication technology such a SQL Always On Availability Group or Log Shipping. Or in the case of SAP HANA DB, use HSR across Azure regions for database replication.

Also, ASR can’t be used to replicate clustered nodes. For the SCS layer, use either a three-node geo-cluster (see SAP reference implementation note 1634991), or simply schedule a batch job to copy the `/sapmnt` content to the DR region. The sapmnt file-share is SAP share that contains application server executables and logs but no SAP business transactional data. The copies refresh the `/sapmnt` share of a prebuilt SCS node to keep kernel executables in sync with the SCS in the primary region.

## Operational considerations
SAP HANA has a backup feature that makes use of the underlying Azure infrastructure. To back up the SAP HANA database running on Azure VMs, both the SAP HANA snapshot and Azure storage snapshot are used to ensure the backup files’ consistency. For details, please see [Backup guide for SAP HANA on Azure Virtual Machines][hana-backup].

Azure provides several functions for [monitoring and diagnostics][monitoring] of the overall infrastructure. Also, Enhanced monitoring of Azure VMs (Linux or Windows) is handled by Azure Operations Management Suite (OMS). 

To monitor the resources and service performance of SAP applications, the Linux SAP Enhanced Monitoring extension is used. This extension feeds Azure monitoring statistics into the SAP application for OS monitoring and DBA Cockpit functions. 

## Security considerations
SAP has its own Users Management Engine (UME) to control role-based access and authorization within the SAP application. For details, see [SAP HANA Security - An Overview][sap-security].(A SAP Service Marketplace account is required for access.)

For infrastructure security, data is safeguarded in transit and at rest. The “Security considerations” section of the [SAP NetWeaver on Azure Virtual Machines (VMs) – Planning and Implementation Guide][netweaver-on-azure] begins to address network security. It also specifies the network ports you must open on the firewalls to allow application communication. 

For Azure VM storage encryption for SAP application servers, use Azure [disk encryption][disk-encryption] for Windows and Linux VMs. 

For SAP HANA data-at-rest encryption, we recommend using the SAP HANA native encryption technology. 

> [!NOTE]
> Don’t use the HANA data-at-rest encryption with Azure disk encryption on the same server.
> 
>


## Compliance considerations
Azure as an infrastructure platform is compliant with many security and regulatory requirements. For more information, see the [Azure Trust Center][azure-trust-center]. For guidelines about implementing compliance, see the [list of white papers][white-papers] on the Azure blog. 

## Communities
Communities can answer questions and help you set up a successful deployment. Consider the following:

-	[Azure Forum][azure-forum]
-	[SAP Community][sap-community]
-	[Stack Overflow SAP][stack-overflow]

## Solution deployment
A deployment for this reference architecture is available on GitHub. It includes documentation in Markdown format as well as code artifacts for the deployment. 

### Deploy SAP infrastructure
To deploy this reference architecture, you can use PowerShell, bash, or the Azure portal. To do so using your own parameter files, follow the instructions below.

1. Download all the files and folders in this folder.
2. In the **parameters** folder, customize each parameter file according to your needs.
3. Follow the steps in one of the following sections to deploy your solution.

#### Use Azure portal
1. Copy your parameters files to a URI that is publicly accessible.
2. Right-click the button below and select either **Open link in new tab** or **Open link in new window**.
   [![Deploy to Azure](/azure/guidance/_images/blueprints/deploybutton.png)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fmspnp%2Freference-architectures%2Fmaster%2Fguidance-compute-single-vm%2Fazuredeploy.json)
3. In the Azure portal, enter values for the following settings: 
   
   * For **Subscription**, choose the subscription you want to use for your deployment.
   * For **Resource group**, select **Create New** and enter the name you defined in your parameters file.
   * In the **Location** box, select a region for your deployment.
   * In the **Parameter Root Uri** box, enter the URL of the public location where you copied your parameter files. 
   * Review the terms and conditions, then click the **I agree to the terms and conditions stated above** checkbox.
   * Click the **Purchase** button, then wait for the deployment to finish. The deployment status is shown under **Notifications**.

#### Use PowerShell
1. Open a PowerShell console and navigate to the folder where you downloaded the script and parameter files.
2. Run the cmdlet below using your own subscription ID, location, OS type, and resource group name.

```
 .\Deploy-ReferenceArchitecture -SubscriptionId <id> -Location <location> -ResourceGroupName <resource group> 
```
#### Bash
1. Open a bash console and navigate to the folder where you downloaded the script and parameter files.
2. Run the command below using your own subscription id, location, OS type, and resource group name.

```
 sh deploy-reference-architecture.sh -s <subscription id> -l <location> -r <resource group> 
```

### Configure SAP applications and database
After deploying the SAP infrastructure as described above, you need to install and configure your SAP applications and Hana database on the virtual machines as described below.

> [!NOTE]
> To install NetWeaver and SCS, you must have an SAP Support Portal username and password for access to the [SAP install guides][sap-guide].
> 
>


1. Log on to the virtual machine named `ra-sapApps-vm1`.
  - Install and configure the SAP NetWeaver application using the [SAP install guides][sap-guide].
2. Repeat step 1 for the rest of the virtual machines named `ra-sapApps-vmN` (where N is an incrementing number based on the number of virtual machines you deployed).
3. Log on to the virtual machine named `ra-sapApps-scs-vm1`.
  - Install and configure SCS using the [SAP install guides][sap-guide].
4. Repeat step 3 for the rest of the virtual machines named `ra-sapApps-scs-vmN` (where N is an incrementing number based on the number of virtual machines you deployed).
5. Log on to the virtual machine named `ra-sap-data-vm1`.
  - Install and configure the SAP Hana Database using the [SAP HANA Server Installation and Update Guide][hana-guide]. 
  




[azure-forum]: https://azure.microsoft.com/en-us/support/forums/
[azure-lb]: /azure/load-balancer/load-balancer-overview
[azure-storage]: /azure/storage/storage-introduction
[azure-trust-center]: https://azure.microsoft.com/en-us/support/trust-center/
[clustering]: https://blogs.msdn.microsoft.com/saponsqlserver/2015/05/20/clustering-sap-ascs-instance-using-windows-server-failover-cluster-on-microsoft-azure-with-sios-datakeeper-and-azure-internal-load-balancer/
[disk-encryption]: /azure/security/azure-security-disk-encryption
[filter-network]: https://azure.microsoft.com/en-us/blog/multiple-vm-nics-and-network-virtual-appliances-in-azure/
[hana-backup]: /azure/virtual-machines/workloads/sap/sap-hana-backup-guide
[hana-guide]: https://help.sap.com/viewer/2c1988d620e04368aa4103bf26f17727/2.0.01/en-US/7eb0167eb35e4e2885415205b8383584.html
[ilb]: /azure/load-balancer/load-balancer-internal-overview
[logon-groups]: https://wiki.scn.sap.com/wiki/display/SI/ABAP+Logon+Group+based+Load+Balancing
[monitoring]: /azure/architecture/best-practices/monitoring
[multiple-vm-nics]: https://azure.microsoft.com/en-us/blog/multiple-vm-nics-and-network-virtual-appliances-in-azure/
[netweaver-on-azure]: /azure/virtual-machines/workloads/sap/planning-guide
[nsg]: /azure/virtual-network/virtual-networks-n
[planning]: /azure/vpn-gateway/vpn-gateway-plan-design
[sap-community]: https://www.sap.com/community.html
[sap-dispatcher]: https://help.sap.com/doc/saphelp_nw73ehp1/7.31.19/en-US/48/8fe37933114e6fe10000000a421937/frameset.htm
[sap-guide]: https://service.sap.com/instguides
[sap-ha]: https://support.sap.com/content/dam/SAAP/SAP_Activate/AGS_70.pdf
[sap-security]: https://archive.sap.com/documents/docs/DOC-62943
[sla]: https://azure.microsoft.com/support/legal/sla/virtual-machines
[stack-overflow]: http://stackoverflow.com/tags/sap/info
[white-papers]: https://azure.microsoft.com/en-us/blog/azure-compliance-white-paper-o-rama/
[0]: ../_images/SAP-HANA-RA-diagram.png "SAP HANA architecture using Microsoft Azure"
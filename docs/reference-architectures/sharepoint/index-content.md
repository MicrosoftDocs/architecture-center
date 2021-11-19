This reference architecture shows proven practices for deploying a highly available SharePoint Server 2016 farm on Azure, using MinRole topology and SQL Server Always On availability groups. The SharePoint farm is deployed in a secured virtual network with no Internet-facing endpoint or presence.

![Reference architecture for a highly available SharePoint Server 2016 farm in Azure](./images/sharepoint-ha.png)

*Download a [Visio file][visio-download] of this architecture.*

## Architecture

This architecture builds on the one shown in [Run Windows VMs for an N-tier application][windows-n-tier]. It deploys a SharePoint Server 2016 farm with high availability inside an Azure virtual network (VNet). This architecture is suitable for a test or production environment, a SharePoint hybrid infrastructure with Microsoft 365, or as the basis for a disaster recovery scenario.

The architecture consists of the following components:

- **Resource groups**. A [resource group][resource-group] is a container that holds related Azure resources. One resource group is used for the SharePoint servers, and another resource group is used for infrastructure components that are independent of VMs, such as the virtual network and load balancers.

- **Virtual network (VNet)**. The VMs are deployed in a VNet with a unique intranet address space. The VNet is further subdivided into subnets.

- **Virtual machines (VMs)**. The VMs are deployed into the VNet, and private static IP addresses are assigned to all of the VMs. Static IP addresses are recommended for the VMs running SQL Server and SharePoint Server 2016, to avoid issues with IP address caching and changes of addresses after a restart.

- **Availability sets**. Place the VMs for each SharePoint role into separate [availability sets][availability-set], and provision at least two virtual machines (VMs) for each role. This configuration makes the VMs eligible for a higher service level agreement (SLA).

- **Internal load balancer**. The [load balancer][load-balancer] distributes SharePoint request traffic from the on-premises network to the front-end web servers of the SharePoint farm.

- **Network security groups (NSGs)**. For each subnet that contains virtual machines, a [network security group][nsg] is created. Use NSGs to restrict network traffic within the VNet, in order to isolate subnets.

- **Gateway**. The gateway provides a connection between your on-premises network and the Azure virtual network. Your connection can use ExpressRoute or site-to-site VPN. For more information, see [Connect an on-premises network to Azure][hybrid-ra].

- **Windows Server Active Directory (AD) domain controllers**. This reference architecture deploys Windows Server AD domain controllers. These domain controllers run in the Azure VNet and have a trust relationship with the on-premises Windows Server AD forest. Client web requests for SharePoint farm resources are authenticated in the VNet rather than sending that authentication traffic across the gateway connection to the on-premises network. In DNS, intranet A or CNAME records are created so that intranet users can resolve the name of the SharePoint farm to the private IP address of the internal load balancer.

  SharePoint Server 2016 also supports using [Azure Active Directory Domain Services](/azure/active-directory-domain-services). Azure AD Domain Services provides managed domain services so that you don't need to deploy and manage domain controllers in Azure.

- **SQL Server Always On availability group**. For high availability of the SQL Server database, we recommend [SQL Server Always On availability groups][sql-always-on]. Two virtual machines are used for SQL Server. One contains the primary database replica, and the other contains the secondary replica.

- **Majority node VM**. This VM allows the failover cluster to establish a quorum. For more information, see [Understanding Quorum Configurations in a Failover Cluster][sql-quorum].

- **SharePoint servers**. The SharePoint servers perform the web front-end, caching, application, and search roles.

- **Jumpbox**. Also called a [bastion host][bastion-host]. This is a secure VM on the network that administrators use to connect to the other VMs. The jump box has an NSG that allows remote traffic only from public IP addresses on a safe list. The NSG should permit remote desktop (RDP) traffic.

## Recommendations

Your requirements might differ from the architecture described here. Use these recommendations as a starting point.

### Resource group recommendations

We recommend separating resource groups according to the server role, and having a separate resource group for infrastructure components that are global resources. In this architecture, the SharePoint resources form one group, while the SQL Server and other utility assets form another.

### Virtual network and subnet recommendations

Use one subnet for each SharePoint role, plus a subnet for the gateway and one for the jump box.

The gateway subnet must be named *GatewaySubnet*. Assign the gateway subnet address space from the last part of the virtual network address space. For more information, see [Connect an on-premises network to Azure using a VPN gateway][hybrid-vpn-ra].

### VM recommendations

This architecture requires a minimum of 44 cores:

- 8 SharePoint servers on Standard_DS3_v2 (4 cores each) = 32 cores
- 2 Active Directory domain controllers on Standard_DS1_v2 (1 core each) = 2 cores
- 2 SQL Server VMs on Standard_DS3_v2 = 8 cores
- 1 majority node on Standard_DS1_v2 = 1 core
- 1 management server on Standard_DS1_v2 = 1 core

For all SharePoint roles except the Search Indexer, we recommended using the [Standard_DS3_v2][vm-sizes-general] VM size. The Search Indexer should be at least the [Standard_DS13_v2][vm-sizes-memory] size. For more information, see [Hardware and software requirements for SharePoint Server 2016][sharepoint-reqs]. For the SQL Server VMs, we recommend a minimum of 4 cores and 8 GB RAM. For more information, see [Storage and SQL Server capacity planning and configuration (SharePoint Server)](/sharepoint/administration/storage-and-sql-server-capacity-planning-and-configuration#estimate-memory-requirements).

### NSG recommendations

We recommend having one NSG for each subnet that contains VMs, to enable subnet isolation. If you want to configure subnet isolation, add NSG rules that define the allowed or denied inbound or outbound traffic for each subnet. For more information, see [Filter network traffic with network security groups][virtual-networks-nsg].

Do not assign an NSG to the gateway subnet, or the gateway will stop functioning.

### Storage recommendations

The storage configuration of the VMs in the farm should match the appropriate best practices used for on-premises deployments. SharePoint servers should have a separate disk for logs. SharePoint servers hosting search index roles require additional disk space for the search index to be stored. For SQL Server, the standard practice is to separate data and logs. Add more disks for database backup storage, and use a separate disk for [tempdb][tempdb].

For best reliability, we recommend using [Azure Managed Disks][managed-disks]. Managed disks ensure that the disks for VMs within an availability set are isolated to avoid single points of failure.

Use Premium managed disks for all SharePoint and SQL Server VMs. You can use Standard managed disks for the majority node server, the domain controllers, and the management server.

### SharePoint Server recommendations

Before configuring the SharePoint farm, make sure you have one Windows Server Active Directory service account per service. For this architecture, you need, at a minimum, the following domain-level accounts to isolate privilege per role:

- SQL Server Service account
- Setup User account
- Server Farm account
- Search Service account
- Content Access account
- Web App Pool accounts
- Service App Pool accounts
- Cache Super User account
- Cache Super Reader account

To meet the support requirement for disk throughput of 200 MB per second minimum, make sure to plan the Search architecture. See [Plan enterprise search architecture in SharePoint Server 2013][sharepoint-search]. Also, follow the guidelines in [Best practices for crawling in SharePoint Server 2016][sharepoint-crawling].

In addition, store the search component data on a separate storage volume or partition with high performance. To reduce load and improve throughput, configure the object cache user accounts, which are required in this architecture. Split the Windows Server operating system files, the SharePoint Server 2016 program files, and diagnostics logs across three separate storage volumes or partitions with normal performance.

For more information about these recommendations, see [Initial deployment administrative and service accounts in SharePoint Server 2016][sharepoint-accounts].

### Hybrid workloads

This reference architecture deploys a SharePoint Server 2016 farm that can be used as a [SharePoint hybrid environment][sharepoint-hybrid] &mdash; that is, extending SharePoint Server 2016 to SharePoint Online. If you have Office Online Server, see [Office Web Apps and Office Online Server supportability in Azure][office-web-apps].

The default service applications in this solution are designed to support hybrid workloads. All SharePoint Server 2016 and Microsoft 365 hybrid workloads can be deployed to this farm without changes to the SharePoint infrastructure, with one exception: The Cloud Hybrid Search Service Application must not be deployed onto servers hosting an existing search topology. Therefore, one or more search-role-based VMs must be added to the farm to support this hybrid scenario.

### SQL Server Always On availability groups

This architecture uses SQL Server virtual machines because SharePoint Server 2016 cannot use Azure SQL Database. To support high availability in SQL Server, we recommend using Always On availability groups, which specify a set of databases that failover together, making them highly available and recoverable. For more information, see [Create the availability group and add the SharePoint databases][create-availability-group].

We also recommend adding a listener IP address to the cluster, which is the private IP address of the internal load balancer for the SQL Server virtual machines.

For recommended VM sizes and other performance recommendations for SQL Server running in Azure, see [Performance best practices for SQL Server in Azure Virtual Machines][sql-performance]. Also follow the recommendations in [Best practices for SQL Server in a SharePoint Server 2016 farm][sql-sharepoint-best-practices].

We recommend that the majority node server reside on a separate computer from the replication partners. The server enables the secondary replication partner server in a high-safety mode session to recognize whether to initiate an automatic failover. Unlike the two partners, the majority node server doesn't serve the database but rather supports automatic failover.

## Scalability considerations

To scale up the existing servers, simply change the VM size.

With the [MinRoles][minroles] capability in SharePoint Server 2016, you can scale out servers based on the server's role and also remove servers from a role. When you add servers to a role, you can specify any of the single roles or one of the combined roles. If you add servers to the Search role, however, you must also reconfigure the search topology using PowerShell. You can also convert roles using MinRoles. For more information, see [Managing a MinRole Server Farm in SharePoint Server 2016][sharepoint-minrole].

Note that SharePoint Server 2016 doesn't support using virtual machine scale sets for autoscaling.

## Availability considerations

This reference architecture supports high availability within an Azure region because each role has at least two VMs deployed in an availability set.

To protect against a regional failure, create a separate disaster recovery farm in a different Azure region. Your recovery time objectives (RTOs) and recovery point objectives (RPOs) will determine the setup requirements. For details, see [Choose a disaster recovery strategy for SharePoint 2016][sharepoint-dr]. The secondary region should be a *paired region* with the primary region. In the event of a broad outage, recovery of one region is prioritized out of every pair. For more information, see [Business continuity and disaster recovery (BCDR): Azure Paired Regions][paired-regions].

## Manageability considerations

To operate and maintain servers, server farms, and sites, follow the recommended practices for SharePoint operations. For more information, see [Operations for SharePoint Server 2016][sharepoint-ops].

The tasks to consider when managing SQL Server in a SharePoint environment may differ from the ones typically considered for a database application. A best practice is to fully back up all SQL databases weekly with incremental nightly backups. Back up transaction logs every 15 minutes. Another practice is to implement SQL Server maintenance tasks on the databases while disabling the built-in SharePoint ones. For more information, see [Storage and SQL Server capacity planning and configuration][sql-server-capacity-planning].

## Security considerations

The domain-level service accounts used to run SharePoint Server 2016 require Windows Server AD domain controllers or Azure Active Directory Domain Services for domain-join and authentication processes. However, to extend the Windows Server AD identity infrastructure already in place in the intranet, this particular architecture uses two VMs as Windows Server AD replica domain controllers of an existing on-premises Windows Server AD forest.

In addition, it's always wise to plan for security hardening. Other recommendations include:

- Add rules to NSGs to isolate subnets and roles.
- Don't assign public IP addresses to VMs.
- For intrusion detection and analysis of payloads, consider using a network virtual appliance in front of the front-end web servers instead of an internal Azure load balancer.
- As an option, use IPsec policies for encryption of cleartext traffic between servers. If you are also doing subnet isolation, update your network security group rules to allow IPsec traffic.
- Install anti-malware agents for the VMs.

## Cost considerations

Use the [Azure pricing calculator][azure-pricing-calculator] to estimate costs. Here are some factors for optimizing the cost for this architecture.

### Active Directory Domain Services

Consider having Active Directory Domain Services as a shared service that is consumed by multiple workloads to lower costs. See [Active Directory Domain Services pricing][ADDS-pricing] for more information.

### VPN Gateway

The billing model is based on the amount of time the gateway is provisioned and available. See [VPN Gateway Pricing][azure-gateway-pricing].

All inbound traffic is free. All outbound traffic is billed. Internet bandwidth costs are applied to VPN outbound traffic.

### Virtual Network

Azure Virtual Network is free. Every subscription is allowed to create up to 50 virtual networks across all regions. All traffic that originates within the boundaries of a virtual network is free. So, communication between two VMs in the same virtual network is free.

This architecture builds on the architecture deployed in [Run Windows VMs for an N-tier application][windows-n-tier]. See [Cost considerations](../../reference-architectures/n-tier/n-tier-sql-server.yml#cost-considerations) for more information.

For more information, see the cost section in [Microsoft Azure Well-Architected Framework][aaf-cost].

## DevOps considerations

Consider using separate resource groups for production, development, and test environments. Separate resource groups make it easier to manage deployments, delete test deployments, and assign access rights. In general, put resources that have the same lifecycle in the same resource group. Use the Developer tier for development and test environments. To minimize costs during preproduction, deploy a replica of your production environment, run your tests, and then shut down.

Use Azure [Azure Resource Manager templates][arm-template] or Azure Bicep templates for defining the infrastructure. In both cases, you follow the infrastructure as code (IaC) practice for deploying the resources. To automate infrastructure deployment, you can use Azure DevOps Services or other CI/CD solutions. The deployment process is also idempotent - that is, repeatable to produce the same results. Azure [Pipelines][pipelines] is part of [Azure DevOps Services][az-devops] and runs automated builds, tests, and deployments.

Structure your deployment templates following the workload criteria, identify single units of works, and include them in their own template. In this scenario, at least seven workloads are identified and isolated in their own templates: the Azure VNet and the VPN gateway, the management jump box, AD domain controllers, and SQL Server VMs, the Failover cluster and the availability group, and the Remaining VMs, Sharepoint primary node, Sharepoint cache, and NSG rules. Workload isolation makes it easier to associate the workload's specific resources to a team, so that the team can independently manage all aspects of those resources. This isolation enables DevOps to perform continuous integration and continuous delivery (CI/CD). This configuration also allows the staging of your workloads, which means deploying to various stages and running validations at each stage before moving on to the next one. This way, you can push updates to your production environments in a highly controlled way and minimize unanticipated deployment issues.

Consider using the [Azure Monitor][az-monitor] to Analyze and optimize the performance of your infrastructure, Monitor and diagnose networking issues without logging into your virtual machines.

For more information, see the DevOps section in [Azure Well-Architected Framework][AAF-devops].

## Next steps

For more information about the individual pieces of the solution architecture, see the following topics:

- [Availability Sets](/azure/virtual-machines/windows/manage-availability)
- [Azure VPN Gateway](/azure/vpn-gateway/vpn-gateway-about-vpngateways)
- [Azure Load Balancer](/azure/load-balancer/load-balancer-internal-overview)
- [Hardware and software requirements for SharePoint Server 2016](/sharepoint/install/hardware-and-software-requirements)
- [Overview of MinRole Server Roles in SharePoint Servers 2016 and 2019](/sharepoint/install/overview-of-minrole-server-roles-in-sharepoint-server)
- [Always On availability groups](/sql/database-engine/availability-groups/windows/always-on-availability-groups-sql-server)
- [Best practices for SQL Server in a SharePoint Server farm](/sharepoint/administration/best-practices-for-sql-server-in-a-sharepoint-server-farm)
- [SharePoint Server 2016 in Microsoft Azure](/sharepoint/administration/sharepoint-server-2016-in-microsoft-azure)

## Related resources

- [windows-n-tier](/azure/architecture/reference-architectures/n-tier/n-tier-sql-server)
- [Highly available SharePoint farm - Azure Solution Ideas](/azure/architecture/solution-ideas/articles/highly-available-sharepoint-farm)
- [Hybrid SharePoint farm with Microsoft 365](/azure/architecture/solution-ideas/articles/sharepoint-farm-microsoft-365)

<!-- links -->

[AAF-cost]: ../../framework/cost/overview.md
[AAF-devops]: ../../framework/devops/overview.md
[arm-template]: /azure/azure-resource-manager/management/overview
[ADDS-pricing]: https://azure.microsoft.com/pricing/details/active-directory-ds/
[availability-set]: /azure/virtual-machines/windows/manage-availability
[az-devops]: /azure/devops/index?view=azure-devops
[az-monitor]: https://azure.microsoft.com/services/monitor/
[azure-gateway-pricing]: https://azure.microsoft.com/pricing/details/vpn-gateway/
[azure-pricing-calculator]: https://azure.microsoft.com/pricing/calculator
[bastion-host]: https://en.wikipedia.org/wiki/Bastion_host
[create-availability-group]: /sharepoint/administration/sharepoint-intranet-farm-in-azure-phase-5-create-the-availability-group-and-add
[hybrid-ra]: ../hybrid-networking/index.yml
[hybrid-vpn-ra]: ../hybrid-networking/vpn.yml
[load-balancer]: /azure/load-balancer/load-balancer-internal-overview
[managed-disks]: /azure/storage/storage-managed-disks-overview
[minroles]: /SharePoint/install/overview-of-minrole-server-roles-in-sharepoint-server
[nsg]: /azure/virtual-network/virtual-networks-nsg
[office-web-apps]: https://support.microsoft.com/help/3199955/office-web-apps-and-office-online-server-supportability-in-azure
[paired-regions]: /azure/best-practices-availability-paired-regions
[pipelines]: /azure/devops/pipelines/?view=azure-devops&preserve-view=true
[resource-group]: /azure/azure-resource-manager/resource-group-overview
[sharepoint-accounts]: /SharePoint/install/initial-deployment-administrative-and-service-accounts-in-sharepoint-server
[sharepoint-crawling]: /SharePoint/search/best-practices-for-crawling
[sharepoint-dr]: /SharePoint/administration/plan-for-disaster-recovery
[sharepoint-hybrid]: /sharepoint/hybrid/hybrid
[sharepoint-minrole]: /SharePoint/administration/managing-a-minrole-server-farm-in-sharepoint-server-2016
[sharepoint-ops]: /SharePoint/administration/administration
[sharepoint-reqs]: /SharePoint/install/hardware-and-software-requirements
[sharepoint-search]: /SharePoint/search/plan-enterprise-search-architecture
[sql-always-on]: /sql/database-engine/availability-groups/windows/always-on-availability-groups-sql-server
[sql-performance]: /azure/virtual-machines/windows/sql/virtual-machines-windows-sql-performance
[sql-server-capacity-planning]: /SharePoint/administration/storage-and-sql-server-capacity-planning-and-configuration
[sql-quorum]: /previous-versions/windows/it-pro/windows-server-2008-R2-and-2008/cc731739(v=ws.11)
[sql-sharepoint-best-practices]: /SharePoint/administration/best-practices-for-sql-server-in-a-sharepoint-server-farm
[tempdb]: /sql/relational-databases/databases/tempdb-database
[virtual-networks-nsg]: /azure/virtual-network/virtual-networks-nsg
[visio-download]: https://arch-center.azureedge.net/Sharepoint-2016.vsdx
[vm-sizes-general]: /azure/virtual-machines/windows/sizes-general
[vm-sizes-memory]: /azure/virtual-machines/windows/sizes-memory
[windows-n-tier]: ../n-tier/n-tier-sql-server.yml

This article presents a solution that can benefit organizations that rely on SQL Server 2008 R2 failover clusters to manage their data. The solution uses the Azure shared disks feature and a Windows Server 2008 R2 failover cluster to replicate on-premises deployment in Azure.

## Architecture

:::image type="complex" source="./windows-server-2008-r2-failover-cluster-with-azure-shared-disk.svg" alt-text="Architecture diagram showing a Windows Server 2008 R2 failover cluster that uses an Azure shared disk to manage shared storage." border="false":::
A dotted line surrounds most components, including an Azure Load Balancer, two virtual machines, and a file share witness. The line indicates that these components are part of a virtual network. Inside that network, a horizontal, blue rectangle represents an availability set. It contains the two virtual machines and their disks. Lines run between each virtual machine and an SMB file share witness. A black, vertical rectangle contains the file share witness and runs through the availability set. On the top border of that rectangle is the Load Balancer. A line extends from the Load Balancer to the outside of the virtual network rectangle. Outside the virtual network rectangle on the bottom is an Azure shared disk. A line connects that disk to the components in the network.
:::image-end:::

*Download a [Visio file][Visio version of architecture diagram] of this architecture.*

### Dataflow

- As part of a virtual network, Azure Load Balancer redirects clients by associating a routable, private IP address with the cluster.

- Two Azure virtual machines (VMs) run SQL Server 2008 R2 on Windows Server 2008 R2.

- An availability set that includes the VMs guarantees the solution's redundancy and availability.

- A server message block (SMB) file share witness provides an extra quorum vote to keep the cluster running after site outages.

- An Azure shared disk makes it possible to attach a managed disk to both VMs simultaneously.

### Components

- [Azure Load Balancer](https://azure.microsoft.com/products/load-balancer) balances traffic inside virtual networks. This solution uses an internal load balancer. This type uses a private IP address and distributes inbound traffic to back-end pool instances. The load balancer directs traffic according to configured load-balancing rules and health probes. The back-end pool instances can be Azure VMs.

- [Azure Virtual Machines](https://azure.microsoft.com/products/virtual-machines) is an on-demand, scalable computing resource. An Azure VM provides the flexibility of virtualization, but it eliminates the maintenance demands of physical hardware. Azure VMs offer a choice of operating systems, including Windows and Linux.

- [SMB file share witnesses][Deploy a file share witness] are servers that support the SMB protocol and host a file share. Failover clusters use these servers to provide high availability. When a site outage occurs, a file share witness provides an extra quorum vote that keeps the cluster running.

- [Azure shared disk][Azure shared disks] is a feature of [Azure managed disks](https://azure.microsoft.com/products/storage/disks). These shared disks offer shared block storage that multiple VMs can access. You can use this feature to attach a managed disk to multiple VMs simultaneously.

### Alternatives

A few alternatives to this architecture exist:

- [Upgrade to a newer version of SQL Server][Upgrade SQL Server].

- Migrate your workload to an [Azure SQL Database service](https://azure.microsoft.com/products/azure-sql/database).

- Purchase [Extended Security Updates][Extended Security Updates frequently asked questions] to use with your current implementation.

- Move SQL Server 2008 R2 deployments to Azure VMs, and use third-party software to manage shared storage.

## Scenario details

Many businesses rely on SQL Server 2008 R2 failover clusters to manage their data. However, [support for SQL Server 2008 R2][Microsoft SQL Server 2008 R2 lifecycle] and [for Windows Server 2008 R2][Windows Server 2008 R2 lifecycle] has ended. Regular security updates are no longer available.

> [!TIP]
> For those customers who need some more time to upgrade and modernize their SQL Server and Windows Server 2008/2008 R2 on Azure, we provide one additional year of free extended security updates, only on Azure. For more information, see [Extended Security Updates for SQL Server and Windows Server 2008 and 2008 R2][Extended Security Updates frequently asked questions].

Customers who would like to migrate to Azure often can't change their infrastructure. The [Azure shared disks][Azure shared disks] feature makes migration possible in this situation. With this feature and a Windows Server 2008 R2 failover cluster, users can replicate their on-premises deployment in Azure. There's no need for third-party software to manage shared storage.

With this solution, users can:

- Keep their current infrastructure.
- Rehost workloads in Azure with no application code changes.
- Get [free extended security updates for 2008 R2 versions of SQL Server and Windows Server][Extended Security Updates frequently asked questions].

## Potential use cases

This architecture benefits organizations that rely on SQL Server 2008 R2 failover clusters to provide fault-tolerant data management. Examples include businesses in reservations, e-commerce, and logistics.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Security

This solution provides [extended security updates for SQL Server and Windows Server 2008 and 2008 R2][Extended Security Updates frequently asked questions] for one extra year of free extended security updates, up to July 2023. Without extended support beyond that point, security breaches or data loss can result.

### Scalability

Windows Server 2008 R2 limits the number of *nodes*, or servers in the failover cluster, to 16.

### Other considerations

- The [Azure shared disk feature only works with ultra disks and premium SSDs][Azure shared disk limits disk types]. Among those disk types, [only certain disk sizes support sharing][Azure shared disk limits disk size].

- Use the [Azure pricing calculator][Azure pricing calculator] to explore the cost of running this scenario.

## Deploy this scenario

Follow these steps to implement this architecture.

### Prerequisites

- A two-node SQL Server 2008 R2 failover cluster on-premises, available for migration. The cluster nodes must be connected to an on-premises domain.
- An [Azure virtual network][What is Azure Virtual Network?] that's connected to an on-premises network.
  - An [Active Directory domain controller][Domain Controller Roles] that can communicate with the virtual network. This server can either be on-premises or in a separate virtual network.
  - A subnet on which the host cluster is available.
- A server that can host an SMB file share witness for [cluster quorum][Failover cluster quorum]. This server must be connected to the on-premises domain.

### Build a Windows Server 2008 R2 failover cluster on Azure

Follow these steps to set up the cluster.

#### Deploy the VMs on Azure

1. Create two Azure VMs that run Windows Server 2008 R2.

   - When you deploy a VM, [Azure Hybrid Benefit for Windows Server][Azure Hybrid Benefit for Windows Server] is activated by default. With this benefit and [Software Assurance][Software Assurance], you can use your on-premises Windows Server licenses. However, if you'd like to use a different license and turn off Azure Hybrid Benefit for Windows Server, follow the [official guidelines][Azure Hybrid Benefit for Windows Server configuration guidelines].

   - Windows Server 2008 R2 is no longer available on [Azure Marketplace][Azure Marketplace], but two other deployment options exist:

     - Run a [PowerShell script][PowerShell script to deploy VMs on Azure].
     - [Upload a generalized Virtual Hard Disk (VHD) to Azure][Upload a generalized VHD and use it to create new VMs in Azure]. From the image of the VHD, you can create a new VM with the required operating system.

     > [!NOTE]
     > Don't use the [SQL Server 2008 R2 SP3 on Windows Server 2008 R2][SQL Server 2008 R2 SP3 on Windows Server 2008 R2] image that is available in [Azure Marketplace][Azure Marketplace]. This image pre-configures SQL Server as a standalone instance. However, the solution architecture requires a cluster configuration, making the Azure Marketplace image unsuitable.

1. Configure an [availability set][Configure multiple virtual machines in an availability set for redundancy] to guarantee VM redundancy and availability.

#### Configure the VMs

1. Check that the correct [name resolution for resources in Azure virtual networks][Name resolution that uses your own DNS server] is in place.

1. Take these steps with each VM:

   1. Join the VM to the domain. The PowerShell script that deploys VMs assigns them private IP addresses. Classic, on-premises database cluster configurations that have no direct exposure to the internet use this type of assignment. To manage the cluster nodes deployed into the Azure virtual network from the on-premises network, you have two options:

      - Establish a route path from your on-premises system that supports the relevant protocols.
      - Use [Azure Bastion] to connect to the VMs.

   1. Add a domain administrator to the machine.

   1. Install the [KB3125574][KB3125574] rollup update. This update extends the failover cluster so that it supports the custom probe that Azure Load Balancer uses.

#### Deploy the Azure shared disk

1. Use an [Azure Resource Manager template (ARM template)][ARM templates], such as the [template][ARM Template to create a shared disk] in [Reference code][Reference Code], to deploy an Azure shared disk. Currently you can't use the Azure portal for this purpose.

1. Use the Azure portal to connect the Azure shared disk to both VMs. For this operation, use the **Attach existing disks** function on the **Disks** page of each VM. Currently ReadOnly host caching isn't available for premium SSDs Azure shared disks.

1. Sign in to one of the VMs and take these steps:

   1. Initialize the Azure shared disk. Select **MBR** for the partition style.
   1. Create a new simple volume on the disk.
   1. Format the disk. This operation can take several minutes and might require you to restart the VM.

1. Reboot the second VM to give it access to the disk.

1. Check that the disk is visible on both VMs. But note that this visibility is only temporary. Later, the cluster will take over disk management.

#### Configure the cluster

Follow [standard procedures to configure the Windows Server 2008 R2 cluster][Overview of Failover Clusters]. This section outlines the high-level steps.

You have two options for completing the configuration:

- The command line: This procedure is straightforward and error-free.
- The management console: Because of Windows 2008 R2 cluster limitations, this procedure generates some errors related to the cluster IP configuration. You need to take some extra recovery steps with this approach.

##### Use the command line

In each VM, sign in as a domain administrator, open a command line as an administrator, and take the following steps:

1. Add the failover clustering feature:

   ```powershell
   servermanagercmd -install Failover-Clustering
   ```

1. Create the failover clustering:

   ```powershell
   cluster /cluster:"<cluster name>" /create /nodes:"<node 1> <node 2> /ipaddr:<cluster ip address>/255.255.255.0
   ```

1. Open the failover cluster management console.
   1. Add the disks in the available storage.
   1. Run the cluster validation to check the configuration.

1. Configure the inbound ports firewall to use these values for the SQL Server Default instance:

   1. SQL Server: **1433**
   1. Load Balancer Health Probe: **59999**

  For complete guidelines, refer to [Configure the Windows Firewall to Allow SQL Server Access][Configure the Windows Firewall to Allow SQL Server Access].

##### Use the management console

1. In each VM, take the following steps:

   1. From the **Server Manager** administrative tool, add the **Failover Clustering** feature. If you run a configuration validation, you'll see a warning message because there's only a network interface in each node.

   1. Configure the inbound ports firewall to use these values for the SQL Server Default instance:

      - SQL Server: **1433**
      - Load Balancer Health Probe: **59999**

      For complete guidelines, refer to [Configure the Windows Firewall to Allow SQL Server Access][Configure the Windows Firewall to Allow SQL Server Access].

1. Sign in to one VM and use the **Create Cluster** wizard to create a cluster.

   - This operation creates a [Cluster Name Object (CNO)][Cluster Name Object] and adds it to the domain.
   - By default, the operation uses [Dynamic Host Configuration Protocol (DHCP)][Dynamic Host Configuration Protocol] to set the cluster IP address.

   > [!NOTE]
   > If the process of creating a cluster generates a critical error at the end, you can ignore it.

1. Assign the cluster a valid IP address by following these steps:

   1. From one of the two nodes, run this command:

      ```powershell
      Net start clussvc /fq
      ```

   1. From the **Failover Cluster Manager** administrative tool, open the properties of the cluster IP address.

   1. Change the address from **DHCP** to **Static**.

   1. Assign the address an unused Azure virtual network IP address. This IP address can't be used to communicate with the cluster. Since this address isn't associated with an Azure object, it's not visible in the virtual network, and traffic can't flow to it. An [internal load balancer][Azure Load Balancer] that you deploy in a later step will solve this problem.

#### Add a cluster witness

Follow these steps to add a file share witness to provide [cluster quorum][Failover cluster quorum]:

1. On the server that can host an SMB file share, take these actions:

   1. Create a folder and share it.
   1. Give the CNO change and read permissions.

1. Sign in to one of the VMs and take these actions:

   1. Open the **Configure Cluster Quorum** wizard.
   1. In **Select Quorum Configuration**, select **Node and File Share Majority**.
   1. In **Configure File Share Witness**, enter the shared folder.

Alternatively, you can configure the quorum through a command line:

1. Open a command line as an administrator.
1. Run the following command:

   ```powershell
   cluster /cluster:"<cluster name>" res "File Share Witness" /create /group:"Cluster Group" /type:"File Share Witness" /priv SharePath="<witness share>"
   cluster /cluster:"<cluster name>" res "File Share Witness" /online
   cluster "<cluster name>" /quorum:"File Share Witness"
   ```

#### Deploy the SQL Server 2008 R2 failover cluster

Follow these steps to bring the cluster online:

1. To speed up the deployment procedure, [slipstream SQL Server 2008 R2 and SQL Server 2008 R2 SP3][How to update or slipstream an installation of SQL Server 2008].

1. Sign in to one of the VMs and take these steps:

   1. From the **Server Manager** administrative tool, add the .NET Framework 3.5.1 feature.
   1. Open the **New SQL Server failover cluster installation** administrative tool.
      1. In the network configuration, disable **DHCP** and enter an unused virtual network IP address.
      1. In the database engine configuration, check that the Azure shared disk is selected in **Data Directories**.

1. Sign in to the other VM and take these steps:

   1. From the **Server Manager** administrative tool, add the .NET Framework 3.5.1 feature.
   1. In the installation software, select **Add node to a SQL Server failover cluster**.

#### Add an internal load balancer

Follow these steps to assign a routable, private IP address to the SQL cluster:

1. Use a [PowerShell script][PowerShell script to deploy an Azure internal load balancer] to add an [Azure Load Balancer][Quickstart: Create an internal load balancer to load balance VMs using the Azure portal]. For the private IP address, use an address that you haven't already used during cluster configuration.

1. Configure the SQL Server 2008 R2 failover cluster to accept probe requests by running these commands from one of the VMs:

   ```powershell
   $IPResourceName = "<Name of the SQL Server IP resource e.g. 'SQL IP Address 1 (sqldbcluster)'>"
   $AILBIP = "<Azure Internal Load Balancer IP>"
   cluster res $IPResourceName /priv enabledhcp=0 address=$AILBIP probeport=59999 subnetmask=255.255.255.255
   ```

   These commands configure a Transmission Control Protocol (TCP) listener for the SQL failover cluster IP address. The `cluster` command provides a TCP port, or a probe port.

1. Take the SQL Server offline and then restart it to apply these changes.

1. Test the new configuration by checking that the subnet mask in the SQL Server IP configuration has the value **255.255.255.255**.

> [!NOTE]
> If you don't install the [KB3125574 rollup update][KB3125574], the `cluster` command fails. By default, you can't configure the subnet mask **255.255.255.255** for a Windows Server 2008 R2 cluster.

### Reference code

- [PowerShell script to deploy VMs on Azure][PowerShell script to deploy VMs on Azure]
- [ARM Template to create a shared disk][ARM Template to create a shared disk]
- [PowerShell script to deploy an Azure internal load balancer][PowerShell script to deploy an Azure internal load balancer]

## Next steps

To transfer data from your on-premises database to the newly created cluster, consider these migration strategies:

- [Restore a database backup][Restore a database backup] on the new installation.
- Use [SQL Log Shipping][SQL Log Shipping] to replicate the databases on the new server.

To learn more about solution components, see these resources:

- [Virtual machines in Azure][Azure virtual machines]
- [Availability options for Azure Virtual Machines][Configure multiple virtual machines in an availability set for redundancy]
- [What is Azure Load Balancer?][Azure Load Balancer]
- [Introduction to Azure managed disks][Introduction to Azure managed disks]
- [Share an Azure managed disk][Azure shared disks]
- [Server Message Block Overview][Server Message Block overview]
- [What is Azure SQL?][What is Azure SQL?]

## Related resources

- [Extend support for SQL Server 2008 and SQL Server 2008 R2 with Azure][Extend support for SQL Server 2008 and SQL Server 2008 R2 with Azure]
- [Frequently asked questions for SQL Server on Azure VMs][Frequently asked questions for SQL Server on Azure VMs]
- [How to use Azure PowerShell to provision SQL Server on Azure Virtual Machines][How to use Azure PowerShell to provision SQL Server on Azure Virtual Machines]
- [Migrate a SQL Server database to SQL Server on an Azure virtual machine][Migrate a SQL Server database to SQL Server on an Azure virtual machine]

[ARM Template to create a shared disk]: ./shared-disk.json
[ARM templates]: /azure/azure-resource-manager/templates/overview
[Azure Bastion]: /azure/bastion/bastion-connect-vm-rdp
[Azure Hybrid Benefit for Windows Server]: /azure/virtual-machines/windows/hybrid-use-benefit-licensing
[Azure Hybrid Benefit for Windows Server configuration guidelines]: /azure/virtual-machines/windows/hybrid-use-benefit-licensing#convert-an-existing-vm-using-azure-hybrid-benefit-for-windows-server
[Azure Load Balancer]: /azure/load-balancer/load-balancer-overview
[Azure Marketplace]: https://azuremarketplace.microsoft.com
[Azure pricing calculator]: https://azure.microsoft.com/pricing/calculator
[Azure shared disks]: /azure/virtual-machines/windows/disks-shared
[Azure shared disk limits disk types]: /azure/virtual-machines/windows/disks-shared#limitations
[Azure shared disk limits disk size]: /azure/virtual-machines/windows/disks-shared#disk-sizes
[Azure virtual machines]: https://azure.microsoft.com/overview/what-is-a-virtual-machine
[Cluster Name Object]: /windows-server/failover-clustering/configure-ad-accounts#overview-of-active-directory-accounts-needed-by-a-failover-cluster
[Configure multiple virtual machines in an availability set for redundancy]: /azure/virtual-machines/manage-availability#configure-multiple-virtual-machines-in-an-availability-set-for-redundancy
[Configure the Windows Firewall to Allow SQL Server Access]: /sql/sql-server/install/configure-the-windows-firewall-to-allow-sql-server-access
[Deploy a file share witness]: /windows-server/failover-clustering/file-share-witness
[Domain Controller Roles]: /previous-versions/windows/it-pro/windows-server-2003/cc786438(v=ws.10)
[Dynamic Host Configuration Protocol]: /windows-server/networking/technologies/dhcp/dhcp-top
[Extend support for SQL Server 2008 and SQL Server 2008 R2 with Azure]: /azure/azure-sql/virtual-machines/windows/sql-server-2008-extend-end-of-support
[Extended Security Updates frequently asked questions]: https://www.microsoft.com/windows-server/extended-security-updates
[Failover cluster quorum]: /windows-server/storage/storage-spaces/understand-quorum
[Frequently asked questions for SQL Server on Azure VMs]: /azure/azure-sql/virtual-machines/windows/frequently-asked-questions-faq
[How to update or slipstream an installation of SQL Server 2008]: https://support.microsoft.com/help/955392/how-to-update-or-slipstream-an-installation-of-sql-server-2008
[How to use Azure PowerShell to provision SQL Server on Azure Virtual Machines]: /azure/azure-sql/virtual-machines/windows/create-sql-vm-powershell
[Introduction to Azure managed disks]: /azure/virtual-machines/managed-disks-overview
[KB3125574]: https://support.microsoft.com/help/3125574/convenience-rollup-update-for-windows-7-sp1-and-windows-server-2008-r2
[Microsoft SQL Server 2008 R2 lifecycle]: /lifecycle/products/microsoft-sql-server-2008-r2
[Migrate a SQL Server database to SQL Server on an Azure virtual machine]: /azure/azure-sql/virtual-machines/windows/migrate-to-vm-from-sql-server
[Name resolution that uses your own DNS server]: /azure/virtual-network/virtual-networks-name-resolution-for-vms-and-role-instances#name-resolution-that-uses-your-own-dns-server
[Overview of Failover Clusters]: /previous-versions/windows/it-pro/windows-server-2008-r2-and-2008/cc730692(v=ws.10)
[PowerShell script to deploy an Azure internal load balancer]: https://github.com/mspnp/samples/tree/master/Reliability/SQLServer2008R2FailoverClusterInAzureSample/LB-Deploy.ps1
[PowerShell script to deploy VMs on Azure]: https://github.com/mspnp/samples/tree/master/Reliability/SQLServer2008R2FailoverClusterInAzureSample/VM-Deploy.ps1
[Quickstart: Create an internal load balancer to load balance VMs using the Azure portal]: /azure/load-balancer/tutorial-load-balancer-standard-internal-portal
[Reference Code]: #reference-code
[Restore a database backup]: /sql/relational-databases/backup-restore/restore-a-database-backup-using-ssms
[Server Message Block overview]: /previous-versions/windows/it-pro/windows-server-2012-R2-and-2012/hh831795(v=ws.11)
[Software Assurance]: https://www.microsoft.com/licensing/licensing-programs/software-assurance-default?activetab=software-assurance-default-pivot%3aprimaryr3
[SQL Log Shipping]: /sql/database-engine/log-shipping/configure-log-shipping-sql-server
[SQL Server 2008 R2 SP3 on Windows Server 2008 R2]: https://azuremarketplace.microsoft.com/marketplace/apps/microsoftsqlserver.sql2008r2sp3-ws2008r2sp1-byol?tab=Overview
[Upgrade SQL Server]: /sql/sql-server/end-of-support/sql-server-end-of-life-overview#upgrade-sql-server
[Upload a generalized VHD and use it to create new VMs in Azure]: /azure/virtual-machines/windows/upload-generalized-managed
[Visio version of architecture diagram]: https://arch-center.azureedge.net/windows-server-2008-r2-failover-cluster-with-azure-shared-disk.vsdx
[What is Azure SQL?]: /azure/azure-sql/azure-sql-iaas-vs-paas-what-is-overview
[What is Azure Virtual Network?]: /azure/virtual-network/virtual-networks-overview
[Windows Server 2008 R2 lifecycle]: /lifecycle/products/windows-server-2008-r2

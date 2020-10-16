---
title: SQL Server 2008 R2 failover cluster in Azure
titleSuffix: Azure Example Scenarios
description: Learn how to rehost SQL Server 2008 R2 failover clusters on Azure virtual machines. See how to use an Azure shared disk to manage shared storage.
author: GitHubAlias
ms.date: 10/16/2020
ms.topic: example-scenario
ms.service: architecture-center
ms.subservice: example-scenario
ms.custom:
- fcp
---

# SQL Server 2008 R2 failover cluster in Azure

Some businesses rely on SQL Server 2008 R2 failover clusters to manage their data. However, support for this product and for Windows Server 2008 R2 has ended. Regular security updates are no longer available.

Many of these customers would like to migrate to Azure but cannot change their infrastructure. The [Azure shared disks][Azure shared disks] feature makes migration possible in this situation. With this feature and a Windows Server 2008 R2 failover cluster, users can replicate their on-premises deployment in Azure. There's no need for third-party software to manage shared storage.

With this solution, users can:

- Keep their current infrastructure.
- Rehost workloads in Azure with no application code changes.
- Get [free extended security updates for 2008 R2 versions of SQL Server and Windows Server][Microsoft blog post on free security updates].

## Potential use cases

This architecture benefits organizations that rely on SQL Server 2008 R2 failover clusters to provide fault-tolerant data management. Examples include businesses in these areas:

- Reservations
- E-commerce
- Logistics

## Architecture

:::image type="complex" source="./Architecture.png" alt-text="Architecture diagram showing a Windows Server 2008 R2 failover cluster that uses an Azure shared disk to manage shared storage." border="false":::
A dotted line surrounds most components, including a load balancer, two clusters, and a file share witness. The line indicates that these components are part of a virtual network. Inside that network, a horizontal, blue rectangle represents an availability set. It contains two clusters, each with a virtual machine and a disk. Lines run between each cluster and an S M B file share witness. A black, vertical rectangle contains the file share witness and runs through the availability set. On the top border of that rectangle is the internal load balancer. A line extends from the load balancer to the outside of the virtual network rectangle. Outside the virtual network rectangle on the bottom is an Azure shared disk. A line connects that disk to the components in the network.
:::image-end:::

## Components

- As part of a virtual network, an [internal load balancer][Azure Load Balancer] redirects clients by associating a routable, private IP address with the cluster.

- Two [Azure virtual machines (VMs)][Azure virtual machines] run SQL Server 2008 R2 on Windows Server 2008 R2.

- An [availability set][Configure multiple virtual machines in an availability set for redundancy] guarantees the redundancy and availability of the VMs.

- A [server message block][Server Message Block overview] (SMB) [file share witness][Deploy a file share witness] provides an additional quorum vote to keep the cluster running after site outages.

- An [Azure shared disk][Azure shared disks] makes it possible to attach a [managed disk][Introduction to Azure managed disks] to both VMs simultaneously.

## Alternatives

A few alternatives to this architecture exist:

- [Upgrade to a newer version of SQL Server][Upgrade SQL Server].

- Migrate your workload to an [Azure SQL Database service][What is Azure SQL?].

- Purchase [Extended Security Updates][Extended Security Updates frequently asked questions] to use with your current implementation.

- Move SQL Server 2008 R2 deployments to Azure VMs, and use third-party software to manage shared storage.

## Considerations

Keep the following points in mind when implementing this architecture:

### Security considerations

This solution provides [extended security updates for 2008 R2 versions of SQL Server and Windows Server][Microsoft blog post on free security updates] for three years. Without extended support beyond that point, security breaches or data loss may result.

### Scalability considerations

Windows Server 2008 R2 limits the number of *nodes*, or servers in the failover cluster, to 16.

### Other considerations

The [Azure shared disk feature only works with ultra disks and premium SSDs][Azure shared disk limits disk types]. Among those disk types, [only certain disk sizes support sharing][Azure shared disk limits disk size].

## Deploy the solution

Follow these steps to implement this architecture.

### Prerequisites

* A two-node SQL Server 2008 R2 failover cluster on-premises, available for migration. The cluster nodes must be connected to an on-premises domain.
* An [Azure virtual network][What is Azure Virtual Network?] that is connected to an on-premises network.
  * An [Active Directory domain controller][Domain Controller Roles] that can communicate with the virtual network. This server can either be on-premises or in a separate virtual network.
  * A subnet on which the host cluster is available.
* A server that can host an SMB file share witness for [cluster quorum][Failover cluster quorum]. This server must be connected to the on-premises domain.

### Build a Windows Server 2008 R2 failover cluster on Azure

Follow these steps to set up the cluster.

#### Deploy the VMs on Azure

- Create two Azure VMs that run Windows Server 2008 R2.

  > [!NOTE]
  > When you deploy a VM, [Azure Hybrid Benefit for Windows Server][Azure Hybrid Benefit for Windows Server] is activated by default. With this benefit and [Software Assurance][Software Assurance], you can use your on-premises Windows Server licenses.

  Windows Server 2008 R2 is no longer available on [Azure Marketplace][Azure Marketplace]. However, two other deployment options exist:

  - Run a [PowerShell script][PowerShell script to deploy Virtual Machines on Azure].
  - [Upload a generalized VHD to Azure][Upload a generalized VHD and use it to create new VMs in Azure]. From the image of the VHD, you can create a new VM with the required operating system.

  > [!NOTE]
  > [SQL Server 2008 R2 SP3 on Windows Server 2008 R2][SQL Server 2008 R2 SP3 on Windows Server 2008 R2] is available in [Azure Marketplace][Azure Marketplace]. However, this image pre-configures SQL Server as a standalone instance. Since the solution architecture requires a cluster configuration, avoid using the Azure Marketplace image.

- Configure an [availability set][Configure multiple virtual machines in an availability set for redundancy] to guarantee VM redundancy and availability.



#### Configure the VMs

- Check that the correct [name resolution for resources in Azure virtual networks][Name resolution that uses your own DNS server] is in place.

- Take these steps with each virtual machine:

  - Join the virtual machine to the domain.
  
  > [!NOTE]
  > The PowerShell script that deploys VMs assigns them private IP addresses. Classic, on-premises database cluster configurations that have no direct exposure to the internet use this type of assignment. To manage the cluster nodes deployed into the Azure virtual network from the on-premises network, you have two options:
  >
  > - Establish a route path from your on-premises system that supports the relevant protocols.
  > - Use [Azure Bastion] to connect to the VMs.

  - Add a domain administrator to the machine.

  - Install the [KB3125574][KB3125574] rollup update. This update extends the failover cluster so that it supports the custom probe that Azure internal load balancer uses.

#### Deploy the Azure shared disk

- Use an [ARM template][ARM templates], such as the one in [Reference Code][Reference Code], to deploy an Azure shared disk. Currently you cannot use the Azure portal for this purpose.

- Use the Azure portal to connect the Azure shared disk to both VMs. For this operation, use the `Attach existing disks` function on the Disks blade of each VM.

  > [!NOTE]
  > Currently ReadOnly host caching is not available for premium SSDs Azure shared disks.

- Sign in to one of the VMs and take these steps:

  - Initialize the Azure shared disk. Select [Master Boot Record (MBR)][Master Boot Record] for the partition style.
  - Create a new simple volume on the disk.
  - Format the disk.

  > [!NOTE]
  > This operation can take several minutes and might require the VM to restart.

- Reboot the second VM to give it access to the disk.

- Check that the disk is visible on both VMs.

  > [!IMPORTANT]
  > The disk is only temporarily visible on both VMs. Later on, the cluster will take over disk management.

#### Configure the cluster

Follow [standard procedures to configure the Windows Server 2008 R2 cluster][Overview of Failover Clusters]. This section outlines the high-level steps.

You have two options for completing the configuration:

- The command line: This procedure is straightforward and error-free.
- The management console: Due to Windows 2008 R2 cluster limitations, this procedure generates some errors related to the cluster IP configuration. You'll need to take some additional recovery steps with this approach.

##### Use the command line

In each VM, sign in as a domain administrator, open a command line as an administrator, and take the following steps:

- Add the failover clustering feature:

  ```powershell
  servermanagercmd -install Failover-Clustering
  ```

- Create the failover clustering:

  ```powershell
  cluster /cluster:"<cluster name>" /create /nodes:"<node 1> <node 2> /ipaddr:<cluster ip address>/255.255.255.0
  ```

- Open the failover cluster management console.
  - Add the disks in the available storage.
  - Run the cluster validation to check the configuration.

- Configure the inbound ports firewall to use these values for the SQL Server Default instance:

  - SQL Server: 1433
  - Load Balancer Health Probe: 59999
  
  For complete guidelines, refer to [Configure the Windows Firewall to Allow SQL Server Access][Configure the Windows Firewall to Allow SQL Server Access].

##### Use the management console

In each VM, take the following steps:

- From the Server Manager administrative tool, add the Failover Clustering feature. If you run a configuration validation, you'll see a warning message because there's only a network interface in each node.

- Configure the inbound ports firewall to use these values for the SQL Server Default instance:

  - SQL Server: 1433
  - Load Balancer Health Probe: 59999
  
  For complete guidelines, refer to [Configure the Windows Firewall to Allow SQL Server Access][Configure the Windows Firewall to Allow SQL Server Access].

Sign in to one VM and use the Create Cluster wizard to create a cluster.
  
  - This operation creates a Cluster Name Object (CNO) and adds it to the domain.
  - By default, the operation uses DHCP to set the cluster IP address.

  > [!NOTE]
  > If the process of creating a cluster generates a critical error at the end, ignore it.

#### Fix the IP configuration

Assign the cluster a valid IP address by following these steps:

- From one of the two nodes, run this command:

  ```powershell
  Net start clussvc /fq
  ```

- From the Failover Cluster Manager administrative tool, open the properties of the cluster IP address.

- Change the address from DHCP to Static

- Assign the address an unused Azure virtual network IP address.

> [!NOTE]
> This IP address cannot be used to communicate with the cluster. Since this address isn't associated with an Azure object, it's not visible in the virtual network, and traffic cannot flow to it. An [Azure internal load balancer][Azure internal load balancer] that you deploy in a later step will solve this problem.

#### Add a cluster witness

Follow these steps to add a file share witness to provide [cluster quorum][Failover cluster quorum]:

- Take these actions on the server that can host an SMB file share:

  - Create a folder and share it.
  - Give the CNO change and read permissions.

- Sign in to one of the VMs and take these actions:

  - Open the Configure Cluster Quorum wizard.
  - In **Select Quorum Configuration**, select **Node and File Share Majority**.
  - In **Configure File Share Witness**, enter the shared folder.

Alternatively, you can configure the quorum through a command line:

- Open a command line as an administrator.
- Run the following command:

  ```powershell
  cluster /cluster:"<cluster name>" res "File Share Witness" /create /group:"Cluster Group" /type:"File Share Witness" /priv SharePath="<witness share>"
  cluster /cluster:"<cluster name>" res "File Share Witness" /online
  cluster "<cluster name>" /quorum:"File Share Witness"
  ```

#### Deploy the SQL Server 2008 R2 failover cluster

Follow these steps to bring the cluster online:

- To speed up the deployment procedure, [slipstream SQL Server 2008 R2 and SQL Server 2008 R2 SP3][How to update or slipstream an installation of SQL Server 2008].

- Sign in to one of the VMs and take these steps:

  - From the Server Manager administrative tool, add the .NET Framework 3.5.1 feature.
  - Open the New SQL Server failover cluster installation administrative tool.
    - In the network configuration, disable DHCP and enter an unused virtual network IP address.
    - In the database engine configuration, check that the Azure shared disk is selected in **Data Directories**.

- Sign in to the other VM and take these steps:

  - From the Server Manager administrative tool, add the .NET Framework 3.5.1 feature.
  - In the installation software, select **Add node to a SQL Server failover cluster**.

#### Add an Azure internal load balancer

Follow these steps to assign a routable, private IP address to the SQL cluster:

- Use the [reference code][Reference Code] to add an [Azure internal load balancer][Quickstart: Create an internal load balancer to load balance VMs using the Azure portal].

  > [!NOTE]
  > For the private IP address, use an address that you haven't already used during cluster configuration.

- Configure the SQL Server 2008 R2 failover cluster to accept probe requests by running these commands from one of the VMs:

  ```powershell
  $IPResourceName = "<Name of the SQL Server IP resource e.g. 'SQL IP Address 1 (sqldbcluster)'>"
  $AILBIP = "<Azure Internal Load Balancer IP>"
  cluster res $IPResourceName /priv enabledhcp=0 address=$AILBIP probeport=59999 subnetmask=255.255.255.255
  ```

  These commands configure a TCP listener for the SQL failover cluster IP address. The `cluster` command provides a TCP port, or a probe port.

- Take the SQL Server offline and then restart it to apply these changes.

- Test the new configuration by checking that the subnet mask in the SQL Server IP configuration has the value `255.255.255.255`.

> [!NOTE]
> If you didn't install the [KB3125574 rollup update][KB3125574], the `cluster` command will fail. By default, you cannot configure the subnet mask `255.255.255.255` for a Windows Server 2008 R2 cluster.

### Licensing

For customers with Software Assurance, [Azure Hybrid Benefit](https://docs.microsoft.com/azure/virtual-machines/windows/hybrid-use-benefit-licensing) for Windows Server allows to use on-premises Windows Server licenses.

The deployed Virtual Machines have the Azure Hybrid Benefit already activated. If you want to revert this configuration follow the [official guideline](https://docs.microsoft.com/azure/virtual-machines/windows/hybrid-use-benefit-licensing#powershell-1).

### Reference Code

* [PowerShell script to deploy Virtual Machines on Azure](VM-Deploy.ps1)
* [ARM Template to create shared disk](shared-disk.json)
* [PowerShell script to deploy Azure Internal Load Balancer](LB-Deploy.ps1)

## Next steps

To transfer data from your on-premises database to the newly created cluster, consider these migration strategies:

* [Restore a database backup](https://docs.microsoft.com/sql/relational-databases/backup-restore/restore-a-database-backup-using-ssms?view=sql-server-ver15) on the new installation.
* Use the [SQL Log Shipping](https://docs.microsoft.com/it-it/sql/database-engine/log-shipping/configure-log-shipping-sql-server?view=sql-server-ver15) to replicate the databases from the old server to the new one.

## Related resources

- [Extend support for SQL Server 2008 and SQL Server 2008 R2 with Azure][Extend support for SQL Server 2008 and SQL Server 2008 R2 with Azure]
- [Frequently asked questions for SQL Server on Azure VMs][Frequently asked questions for SQL Server on Azure VMs]
- [How to use Azure PowerShell to provision SQL Server on Azure Virtual Machines][How to use Azure PowerShell to provision SQL Server on Azure Virtual Machines]
- [Migrate a SQL Server database to SQL Server on an Azure virtual machine][Migrate a SQL Server database to SQL Server on an Azure virtual machine]

[ARM templates]: https://docs.microsoft.com/azure/azure-resource-manager/templates/overview
[Azure Bastion]: https://docs.microsoft.com/azure/bastion/bastion-connect-vm-rdp
[Azure Hybrid Benefit for Windows Server]: https://docs.microsoft.com/azure/virtual-machines/windows/hybrid-use-benefit-licensing
[Azure internal load balancer]: /clusterwin2008sql.md#Azure-Internal-Load-Balancer
[Azure Load Balancer]: https://docs.microsoft.com/azure/load-balancer/load-balancer-overview
[Azure Marketplace]: (https://azuremarketplace.microsoft.com/)
[Azure shared disks]: https://docs.microsoft.com/azure/virtual-machines/windows/disks-shared
[Azure shared disk limits disk types]: https://docs.microsoft.com/azure/virtual-machines/windows/disks-shared#limitations
[Azure shared disk limits disk size]: https://docs.microsoft.com/azure/virtual-machines/windows/disks-shared#disk-sizes
[Azure virtual machines]: https://azure.microsoft.com/overview/what-is-a-virtual-machine/
[Configure multiple virtual machines in an availability set for redundancy]: https://docs.microsoft.com/azure/virtual-machines/manage-availability#configure-multiple-virtual-machines-in-an-availability-set-for-redundancy
[Configure the Windows Firewall to Allow SQL Server Access]: https://docs.microsoft.com/sql/sql-server/install/configure-the-windows-firewall-to-allow-sql-server-access?view=sql-server-ver15
[Deploy a file share witness]: https://docs.microsoft.com/windows-server/failover-clustering/file-share-witness
[Domain Controller Roles]: https://docs.microsoft.com/previous-versions/windows/it-pro/windows-server-2003/cc786438(v=ws.10)
[Extend support for SQL Server 2008 and SQL Server 2008 R2 with Azure]: https://docs.microsoft.com/azure/azure-sql/virtual-machines/windows/sql-server-2008-extend-end-of-support
[Extended Security Updates frequently asked questions]: https://www.microsoft.com/windows-server/extended-security-updates
[Failover cluster quorum]: https://docs.microsoft.com/windows-server/storage/storage-spaces/understand-quorum
[Frequently asked questions for SQL Server on Azure VMs]: https://docs.microsoft.com/azure/azure-sql/virtual-machines/windows/frequently-asked-questions-faq
[How to update or slipstream an installation of SQL Server 2008]: https://support.microsoft.com/help/955392/how-to-update-or-slipstream-an-installation-of-sql-server-2008
[How to use Azure PowerShell to provision SQL Server on Azure Virtual Machines]: https://docs.microsoft.com/azure/azure-sql/virtual-machines/windows/create-sql-vm-powershell
[Introduction to Azure managed disks]: https://docs.microsoft.com/azure/virtual-machines/managed-disks-overview
[KB3125574]: https://support.microsoft.com/help/3125574/convenience-rollup-update-for-windows-7-sp1-and-windows-server-2008-r2
[Master Boot Record]: https://docs.microsoft.com/windows-server/storage/disk-management/initialize-new-disks#about-partition-styles---gpt-and-mbr
[Microsoft blog post on free security updates]: https://azure.microsoft.com/blog/announcing-new-options-for-sql-server-2008-and-windows-server-2008-end-of-support
[Migrate a SQL Server database to SQL Server on an Azure virtual machine]: https://docs.microsoft.com/azure/azure-sql/virtual-machines/windows/migrate-to-vm-from-sql-server
[Name resolution that uses your own DNS server]: https://docs.microsoft.com/azure/virtual-network/virtual-networks-name-resolution-for-vms-and-role-instances#name-resolution-that-uses-your-own-dns-server
[Overview of Failover Clusters]: https://docs.microsoft.com/previous-versions/windows/it-pro/windows-server-2008-r2-and-2008/cc730692(v=ws.10)
[PowerShell script to deploy Virtual Machines on Azure]: ./VM-Deploy.ps1
[Quickstart: Create an internal load balancer to load balance VMs using the Azure portal]: https://docs.microsoft.com/azure/load-balancer/tutorial-load-balancer-standard-internal-portal
[Reference Code]: ./clusterwin2008sql.md#Reference-Code
[Server Message Block overview]: https://docs.microsoft.com/previous-versions/windows/it-pro/windows-server-2012-R2-and-2012/hh831795(v=ws.11)
[Software Assurance]: https://www.microsoft.com/licensing/licensing-programs/software-assurance-default?activetab=software-assurance-default-pivot%3aprimaryr3
[SQL Server 2008 R2 SP3 on Windows Server 2008 R2]: https://azuremarketplace.microsoft.com/marketplace/apps/microsoftsqlserver.sql2008r2sp3-ws2008r2sp1-byol?tab=Overview
[Upgrade SQL Server]: https://docs.microsoft.com/sql/sql-server/end-of-support/sql-server-end-of-life-overview?view=sql-server-ver15#upgrade-sql-server
[Upgrading from Windows Server 2008 R2 or Windows Server 2008]: https://docs.microsoft.com/windows-server/get-started/installation-and-upgrade#upgrading-from-windows-server-2008-r2-or-windows-server-2008
[Upload a generalized VHD and use it to create new VMs in Azure]: https://docs.microsoft.com/azure/virtual-machines/windows/upload-generalized-managed
[What is Azure SQL?]: https://docs.microsoft.com/azure/azure-sql/azure-sql-iaas-vs-paas-what-is-overview
[What is Azure Virtual Network?]: https://docs.microsoft.com/azure/virtual-network/virtual-networks-overview
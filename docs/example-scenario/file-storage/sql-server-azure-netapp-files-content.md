This article provides guidance about how to migrate SQL Server workloads to Azure Virtual Machines by using Azure NetApp Files. Azure NetApp Files is an enterprise-class file storage service that delivers high-performance, low-latency, and scalable storage via the Server Message Block (SMB) protocol. These capabilities make it well-suited for online transaction processing (OLTP) applications. This migration strategy enables cost-effective deployment while preserving enterprise-grade performance and availability.

## Architecture

:::image type="complex" border="false" source="./media/continuous-availability.svg" alt-text="Architecture diagram that displays a SQL Server deployment with Azure NetApp Files." lightbox="./media/continuous-availability.svg":::
   A large rectangle that represents an Azure region surrounds the whole diagram. Inside the region, there's another rectangle that represents availability zone one. Availability zone one contains the Azure NetApp Files delegated subnet and the virtual machine (VM) subnet. The VM subnet contains the SQL Server VM. The SQL Server VM connects to the Azure NetApp Files capacity pool that contains four volumes: SQL data 1, SQL data 2, SQL log, and SQL backup.
:::image-end:::

### Workflow

Beginning with SQL Server 2012 (11.x), Database Engine user databases can be installed by using an SMB file server as the storage option. This capability also supports system databases (master, model, msdb, and tempdb), but their placement on SMB shares might be subject to performance and configuration considerations. This option applies to both standalone SQL Server and SQL Server failover cluster instance (FCI) installations. For more information, see [Install SQL Server with SMB fileshare storage](/sql/database-engine/install-windows/install-sql-server-with-smb-fileshare-as-a-storage-option?view=sql-server-2017).

You can deploy SQL Server on Azure virtual machines (VMs) and use Azure NetApp Files to store the database and log files via SMB. We recommend that you enable [SMB continuous availability shares](/azure/azure-netapp-files/enable-continuous-availability-existing-smb) for Azure NetApp Files to ensure SMB transparent failover. This failover allows for nondisruptive maintenance on the Azure NetApp Files service. You can [enable existing SMB volumes to use continuous availability](/azure/azure-netapp-files/enable-continuous-availability-existing-smb#steps).

You can also deploy a high availability workflow.

:::image type="complex" border="false" source="./media/high-availability.svg" alt-text="Architecture diagram that displays a SQL Server deployment with Azure NetApp Files." lightbox="./media/high-availability.svg":::
   A large rectangle that represents an Azure region surrounds the whole diagram. There are two availability zones. The VM subnet and Azure NetApp Files delegated subnet both span these zones.
:::image-end:::

High availability and disaster recovery for SQL Server can be achieved on Azure by using [Always On failover clusters](/azure/azure-netapp-files/azure-netapp-files-solution-architectures#sql-server), with two databases on two separate VMs. Both VMs should be in the same virtual network to ensure that they can access each other over the private persistent IP address. You should place the VMs in the same [availability set](/azure/virtual-machines/availability-set-overview) to allow Azure to place them into separate fault and upgrade domains. For geo-redundancy, set up the two databases to replicate between two different regions and configure [Always On availability groups](/sql/database-engine/availability-groups/windows/getting-started-with-always-on-availability-groups-sql-server).

### Components

- An [Azure Windows-based VM](/azure/azure-sql/virtual-machines/windows/sql-server-on-azure-vm-iaas-what-is-overview) is a cloud-hosted infrastructure solution that provides the flexibility of virtualization and eliminates the maintenance demands of physical hardware. In this architecture, it serves as the compute layer.

- [Azure NetApp Files](/azure/azure-netapp-files/azure-netapp-files-introduction) is a high performance, Azure-native storage system. In this architecture, it stores database and log files.

- [SnapCenter](https://docs.netapp.com/us-en/snapcenter/get-started/concept_snapcenter_overview.html) is a scalable platform that provides application-consistent data protection for both applications and databases. In this architecture, it's used for backup and recovery operations by creating space-efficient snapshots of the Azure NetApp Files volumes.

### Alternatives

Other Azure solutions exist for providing storage for SQL Server on Azure VMs. When you evaluate alternatives, consider the benefits of space-efficient snapshots for primary data protection. These snapshots can be backed up to an Azure storage account by using [SnapCenter](https://docs.netapp.com/us-en/snapcenter/protect-azure/protect-applications-azure-netapp-files.html), which is included at no extra cost when used with Azure NetApp Files. This approach completes a comprehensive data protection and availability strategy.

## Scenario details

The most demanding SQL Server database workloads require high input/output (I/O) performance and low-latency access to storage. Azure provides low-latency, high-bandwidth shared file access via SMB through Azure NetApp Files. Azure VMs impose limits on I/O and bandwidth for managed disks. In contrast, Azure NetApp Files is subject only to egress network bandwidth limits. In other words, no VM-level storage I/O constraints apply to Azure NetApp Files.

Without I/O limits, SQL Server on smaller VMs that use Azure NetApp Files can perform as well or even better than SQL Server on larger VMs with disk storage. Azure NetApp Files provides flexibility that lets teams grow or shrink deployments on demand. This capability is unlike traditional on-premises configurations, which are sized for the maximum workload requirement and are most cost effective only at maximum utilization. In Azure with Azure NetApp Files, the configuration can be adjusted continually to the momentary workload requirement.

Azure NetApp Files is designed to meet the core requirements of running high-performance workloads like databases in the cloud. It provides the following advantages:

- Lower the total cost of ownership (TCO) compared to disk configurations
- Provide enterprise performance with low latency
- Maintain high availability
- Provide advanced data management

:::image type="complex" border="false" source="./media/value-proposition.svg" alt-text="Diagram that outlines the benefits of using SQL Server with Azure NetApp Files." lightbox="./media/value-proposition.svg":::
   The image shows sections that describe the benefits of using SQL Server with Azure NetApp Files. They're labeled Simple to manage, Enterprise data management, Highly performant, Hybrid and disaster recovery, Production, and Test and dev. A section labeled Azure NetApp Files storage layer has a map key labeled Performance requirement.
:::image-end:::

All components (database and log files) can initially be deployed into a single volume. This simplified configuration is easy to manage and well suited for smaller databases with low transaction activity.

For larger and more demanding databases, it's more efficient to configure multiple volumes and use a [manual quality of service (QoS) capacity pool](/azure/azure-netapp-files/azure-netapp-files-understand-storage-hierarchy#manual-qos-type), which allows for [more granular control over performance requirements](/azure/azure-sql/virtual-machines/windows/sql-vm-create-portal-quickstart).

### Potential use cases

This solution applies to many use cases that include but aren't limited to the following scenarios:

- Migrate existing SQL Server instances that require high performance and high availability from on-premises to Azure on Azure VMs without rearchitecting.

- Deploy SQL Server Always On failover cluster high availability architectures by using availability sets and [Azure NetApp Files continuous availability volume support](/azure/azure-netapp-files/enable-continuous-availability-existing-smb).

- Deploy enterprise-scale, hybrid or Azure-based disaster recovery architectures by using SQL Server Always On availability groups.

- Enhance enterprise SQL Server environments that require advanced data management like fast cloning for test and development and stringent data protection service-level agreements (SLAs).

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability helps ensure that your application can meet the commitments that you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

#### High availability

Azure NetApp Files provides an SLA of 99.99% and is designed to handle hardware failures effectively. The 99.99% SLA can be improved for the highest levels of availability by using cross-zone replication in combination with [Always On availability groups](/sql/database-engine/availability-groups/windows/overview-of-always-on-availability-groups-sql-server?view=sql-server-ver16).

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

#### Role-based access and data encryption

You can rely on [secure data plane concepts](/azure/azure-netapp-files/data-plane-security) with configurable role-based permissions at both the share and file levels. Data is encrypted in transit and at rest.

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

#### Smaller VM size

Network-attached storage can outperform disk-based storage because it relies on network bandwidth instead of disk I/O. Cloud resource constraints and the higher network limits of most VM SKUs contribute to this performance advantage. This solution supports smaller VM sizes with better performance. Smaller VMs are less costly and incur lower SQL Service license costs, while network-attached storage doesn't have an I/O cost factor.

### Performance Efficiency

Performance Efficiency refers to your workload's ability to scale to meet user demands efficiently. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

#### Scalability

Azure NetApp Files volumes can be expanded or contracted without interruption to the database. This flexibility supports both growth and cost reduction, without having to shut down and restart the database.

## Deploy this scenario

For more information about how to deploy and access Azure NetApp Files volumes, see [Azure NetApp Files documentation](/azure/azure-netapp-files/azure-netapp-files-create-volumes-smb).

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [Arnt de Gier](https://www.linkedin.com/in/arntdegier) | Technical Marketing Engineer

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Azure NetApp Files quickstart](/azure/azure-netapp-files/azure-netapp-files-quickstart-set-up-account-create-volumes)
- [Create an SMB volume for Azure NetApp Files](/azure/azure-netapp-files/azure-netapp-files-create-volumes-smb)
- [Benefits of using Azure NetApp Files for SQL Server deployment](/azure/azure-netapp-files/solutions-benefits-azure-netapp-files-sql-server)
- [Windows Server failover cluster with SQL Server on Azure VMs](/azure/azure-sql/virtual-machines/windows/hadr-windows-server-failover-cluster-overview?view=azuresql)
- [Solution architectures that use Azure NetApp Files - SQL Server](/azure/azure-netapp-files/azure-netapp-files-solution-architectures#sql-server)

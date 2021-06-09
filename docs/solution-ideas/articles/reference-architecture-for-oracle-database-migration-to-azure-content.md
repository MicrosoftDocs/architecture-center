


[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

Oracle DB migrations can be accomplished in multiple ways. This architecture covers one of these options wherein Oracle Active Data Guard is used to migrate the Database. It is assumed that Oracle Data Guard (or Active Data Guard) is used for HA/DR purposes. The database migration is performed in multiple steps. As a first step, Oracle Data Guard is used to set up a Secondary/Standby Database in Azure. This allows you to migrate your data to Azure. Once the secondary in Azure is in-sync with the primary, you can flip the database in Azure to be your primary database while maintaining your secondary on-premises. As a next step, you may set up a secondary database in a different Availability Zone (or region) for HA/DR purposes. At this point, you can decommission your on-premises environment. All data traffic between on-premises and Azure flows over Azure ExpressRoute or Site-to-Site VPN connectivity.

## Architecture

![Architecture Diagram](../media/reference-architecture-for-oracle-database-migration-to-azure.png)
*Download an [SVG](../media/reference-architecture-for-oracle-database-migration-to-azure.svg) of this architecture.*

## Data Flow

1. Connect your Azure environment with your on-premises network via site-to-site VPN or ExpressRoute.
2. Use DataGuard to mark your OracleDB1 in Azure as your active stand-by.
3. Switch your OracleDB1 in Azure as primary and set up your OracleDB2 in Azure as your standby to finish your migration. NOTE: This method only works when migrating to and from the same OS version and DB version.  Assumption: customer is using DataGuard on-premises. 

## Components
* [Azure Virtual Network](https://azure.microsoft.com/services/virtual-network/)
* [Azure VPN Gateway](https://azure.microsoft.com/services/vpn-gateway/)
* [Azure ExpressRoute](https://azure.microsoft.com/services/expressroute/)
* [Azure Virtual Machines](https://azure.microsoft.com/services/virtual-machines/)
* [Azure Managed Disks](https://docs.microsoft.com/en-gb/azure/virtual-machines/disks-types)

## Migration consideration

Database over 2TB, you can use Oracle Data Guard with Oracle Recovery Manager (RMAN) or Data Pump to replicate changes after initial “bulk” data transfer, providing a minimal downtime migration.

You can migrate your entire Oracle database from on-premises to Azure VM with minimal downtime by using Oracle Recovery Manager (RMAN) and Oracle Data Guard. Use RMAN to restore your database to the target standby Azure VM, using either backup/restore or the duplicate database method. You then configure the target database as a physical standby database with Oracle Data Guard, allowing all the transaction/redo data changes from the primary on-premises database to the standby database. When the primary on-premises Oracle database is in sync with the target standby database on the Azure VM instance, you can switch over to the target database, which will convert it to a read-write database. You can then point your application connections to the new primary database. This option provides a minimum downtime while migrating your database to Azure.

The Oracle Data Pump utility is used to export and import data and metadata from or to Oracle databases. You can run Data Pump export/import on an entire database, selective schemas, tablespaces, or database objects. Data Pump is the recommended tool for migrating data to Azure, for large databases that range from 10GB to 20TB in size. It allows a high degree of parallelism, flexible data extraction options, and scalable operations, which enable highspeed movement of data and metadata from source database to target database. Oracle Data Pump also supports encryption and compression when exporting your data to data dump files. You can use Oracle Data Pump with Oracle Data Guard or Golden Gate to handle the initial data transfer for large databases. Note: Data Pump is available only on Oracle Database 10g Release 1 (10.1) and later.

## Design considerations

## VM sizing
Consider using hyperthreaded memory optimized virtual machine with constrained core vCPUs for your Oracle Database VM to save on licensing costs and maximize performance. Oracle has guaranteed license mobility from on-premises to Azure. See the Oracle-Azure FAQ.

## Storage
Use multiple premium or ultra disks (managed disks) for performance and availability on your Oracle database. When using managed disks, the disk/device name may change on reboots. It's recommended that you use the device UUID instead of the name to ensure your mounts persist across reboots. More information can be found here.
Consider using Oracle Automatic Storage Management (ASM) for streamlined storage management for your database.

## Test and tunes
We recommend the following tests to validate your application against your new Oracle database:
* Run performance tests to ensure that they meet your business expectations. 
* Test database failover, recovery, and restoration to make sure that you’re meeting RPO and RTO requirements. 
* List all critical jobs and reports, and run them on new Oracle instance to evaluate their performance against your service-level agreements (SLAs).
* Finally, when migrating or creating applications for the cloud, it's important to tweak your application code to add cloud-native patterns such as retry pattern and circuit breaker pattern. Additional patterns defined in the Cloud Design Patterns guide could help your application be more resilient. 

## Oracle licensing
If you are using hyper-threading enabled technology in your Azure VMs, count two vCPUs as equivalent to one Oracle Processor license. See Licensing Oracle Software in the Cloud Computing Environment for details.


## Backup strategy
One backup strategy is to use Oracle Recovery Manager (RMAN) and Azure Backup for application-consistent backups.  You can also use the Azure backup method.

Optionally use Azure Blob Fuse to mount a highly redundant Azure Blob Storage account and write your RMAN backups to it for added resiliency.


## Business continuity and disaster recovery
For business continuity and disaster recovery, consider deploying the following software:
* Oracle Data Guard Fast-Start Failover (FSFO) for database availability
* Oracle Data Guard Far Sync for zero data loss protection.
* Oracle GoldenGate for multi-primary or active-active mode on Azure availability set or availability zone depends on SLA requirements.

Use Availability Zones to achieve high availability in-region. More information can be found Reference architectures for Oracle databases on Azure - Azure Virtual Machines | Microsoft Docs
An uptime availability of 99.99% for your database tier can be achieved using a combination of Azure Availability Zones and Oracle Active DataGuard with FSFO

Consider using proximity placement groups to reduce the latency between your application and database tier.

Set up Oracle Enterprise Manager for management, monitoring, and logging.
Refer to these articles for supporting info:
* Implement Oracle Data Guard on an Azure Linux virtual machine
* Implement Oracle Golden Gate on an Azure Linux VM
* Reference architectures for Oracle Database Enterprise Edition on Azure


## Next step
* [Design and implement an Oracle database on Azure - Azure Virtual Machines | Microsoft Docs](https://docs.microsoft.com/en-us/azure/virtual-machines/workloads/oracle/oracle-design)
* [Introduction to Oracle Data Guard](https://docs.oracle.com/en/database/oracle/oracle-database/18/sbydb/introduction-to-oracle-data-guard-concepts.html#GUID-5E73667D-4A56-445E-911F-1E99092DD8D7)
* [Oracle Data Guard Broker Concepts](https://docs.oracle.com/en/database/oracle/oracle-database/12.2/dgbkr/oracle-data-guard-broker-concepts.html)
* [Configuring Oracle GoldenGate for Active-Active High Availability](https://docs.oracle.com/goldengate/1212/gg-winux/GWUAD/wu_bidirectional.htm#GWUAD282)
* [Oracle Active Data Guard Far Sync Zero Data Loss at Any Distance](https://www.oracle.com/technetwork/database/availability/farsync-2267608.pdf)


## Feedback
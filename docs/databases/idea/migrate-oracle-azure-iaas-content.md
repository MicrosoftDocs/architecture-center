This article describes how to use Oracle Data Guard to migrate an on-premises Oracle Database to an Azure virtual machine (VM). This article assumes that you have a basic understanding of Oracle Database technologies, Azure compute, and Azure networking. This scenario builds on the scenario in [Migrate Oracle database workloads to Azure](topic-migrate-oracle-azure.yml).

## Architecture

The following diagram shows an example of this scenario.

:::image type="content" source="_images/migrate-oracle-azure-iaas/oracle-migration-iaas.svg" alt-text="Diagram that shows an architecture to migrate a database to an Azure virtual machine." border="false" lightbox="_images/migrate-oracle-azure-iaas/oracle-migration-iaas.svg":::

*Download a [Visio file](https://arch-center.azureedge.net/oracle-migration-iaas.vsdx) of this architecture.*

## Scenario

Consider the following scenario details:

- In your on-premises network, you have an existing Oracle Database instance, and you want to migrate a database from that instance to an Azure VM.

- The database is 20 TB and runs on Oracle Enterprise Linux (x86). The database version is Oracle Database 19c, Enterprise Edition.
- The database is Real Application Clusters (RAC)-enabled, which includes two nodes. For disaster recovery, you replicate the database via Oracle Data Guard to another datacenter that's geographically distant from the primary database location.
- You [conducted an assessment](/azure/cloud-adoption-framework/scenarios/oracle-iaas/oracle-capacity-planning#overall-performance-considerations) of your on-premises Oracle Database and application services and deployed a VM in Azure that has the required compute size and storage configuration.
- You place the VM in the database subnet that's in the Oracle virtual network, which peers to the hub virtual network. The IP address range of the database subnet is 10.42.1.0/24.
- In the hub virtual network, the traffic has to traverse, a network virtual appliance (NVA), such as Azure Firewall or a non-Microsoft network virtual appliance. The NVA functions as a routing device, which helps ensure that connectivity between the VM and the on-premises Oracle Database implementation is fully routable. You configure the NVA to inspect all traffic that goes to and from on-premises. The IP address of the hub NVA is 10.0.0.5.
- You configure hybrid connectivity in the hub virtual network via an Azure ExpressRoute connection to your on-premises network.
- You need to migrate the on-premises database to the Azure VM with the minimum amount of downtime possible. You decide to use Oracle Data Guard and Oracle Recovery Manager (RMAN) for the migration.

## Establish network connectivity

To use Oracle Data Guard for migration, you need to ensure that the source and target databases can communicate with each other.

1. Create an Azure route table and associate it with the database subnet.
1. Point the Azure route table to the IP address of the hub NVA to route to the on-premises environment.
1. Configure the hub NVA to route traffic between the on-premises environment and the database subnet.

### Configure the route table

Use the following configuration to create an Azure route table, and associate it with the database subnet:
  - Address prefix: 192.168.0.0/16
  - Next hop type: Virtual appliance
  - Next hop IP address: 10.0.0.5
  - Name: \<Route table name\>

The following diagram shows an example of the updated network configuration.

:::image type="content" source="_images/migrate-oracle-azure-iaas/oracle-migration-iaas-destination.svg" alt-text="Diagram that shows an architecture to migrate a database to an Azure virtual machine and includes the destination." border="false" lightbox="_images/migrate-oracle-azure-iaas/oracle-migration-iaas-destination.svg":::

Do the following steps to verify connectivity.

- Sign in to the Azure VM. Verify that you can use the Secure Shell (SSH) protocol to establish a connection to the on-premises database server.
- Sign in to the on-premises database server. Verify that you can use the SSH protocol to establish a connection to the Azure VM.

## Do migration activities

1. Use RMAN to back up the database from the on-premises database server and restore it onto the target system. For more information, see [Restore a database on a new host](https://docs.oracle.com/en/database/oracle/oracle-database/19/bradv/rman-recovery-advanced.html#GUID-6B71E7DF-A2B6-44F5-A8D5-B184BB41A768).

   Depending on the database backup file size and network bandwidth, you might be able to copy the backup files directly to the Azure VM on a staging area set of disks that you specifically create for that purpose. If you can't use that method because of network bandwidth constraints, you can use [Azure Data Box](/azure/databox/data-box-overview) to copy the backup files to Azure. After the files are in Azure blob storage, you should copy them to the Azure VM staging area set of disks for the restore operation.

1. Configure Oracle Data Guard between the on-premises database server (primary replica) and the Azure VM database server (secondary replica). For more information, see [Create a physical standby database](https://docs.oracle.com/en/database/oracle/oracle-database/19/sbydb/creating-oracle-data-guard-physical-standby.html#GUID-B511FB6E-E3E7-436D-94B5-071C37550170).
1. After the Oracle Data Guard replication finishes and the databases sync, perform a switchover to the Azure VM. For more information, see [Role transitions](https://docs.oracle.com/en/database/oracle/oracle-database/19/sbydb/managing-oracle-data-guard-role-transitions.html#GUID-66282DCD-5E7B-43C2-ADA1-03342E2750A0). Coordinate this step with the application team to ensure that they update application services to point to the new database.
1. Do the following application migration activities in parallel with the database migration to help ensure the least amount of downtime.
    - Migrate application services in accordance with your plans and discussions.
    - Update the application services to point to the new database, including the connection string, Transparent Network Substrate (TNS) entries, and other required configurations.
    - Verify that the application services work as expected.

## Do post-migration activities

- Configure backup for the database on the Azure VM. For more information, see [Backup strategies for Oracle Database on an Azure Linux VM](/azure/virtual-machines/workloads/oracle/oracle-database-backup-strategies).

- Azure VMs don't support Oracle RAC, so consider using Oracle Data Guard for high availability and disaster recovery. For more information, see [Business continuity and disaster recovery for Oracle on Azure VMs](/azure/cloud-adoption-framework/scenarios/oracle-iaas/oracle-disaster-recovery-iaas).
- Run the on-premises database as a secondary Data Guard replica for a period of time to ensure that the migration is successful.
- After you no longer need the on-premises database, decommission the database and the server. Review changes that you made to ports and the firewall to allow communication between the on-premises environment and the Azure VM. Convert any changes that you no longer need.

## Conclusion

Do the preceding configuration changes to migrate your database from an on-premises environment to an Azure VM. The configuration changes help ensure that the source and target databases can communicate with each other and that you can do the migration with minimal downtime.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

- [Jan Faurskov](https://www.linkedin.com/in/jfaurskov) | Cloud Solution Architect
- [Güher Kayali Sarikan](https://www.linkedin.com/in/guherkayali) | Cloud Solution Architect

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

Review the following articles to ensure that your implementation follows recommended practices:

- [Network topology and connectivity for Oracle on an Azure VM](/azure/cloud-adoption-framework/scenarios/oracle-iaas/oracle-network-topology-iaas)
- [Security guidelines for Oracle workloads on an Azure VM](/azure/cloud-adoption-framework/scenarios/oracle-iaas/oracle-security-overview-iaas)
- [Manage and monitor Oracle workloads on an Azure VM](/azure/cloud-adoption-framework/scenarios/oracle-iaas/oracle-manage-monitor-iaas)
- [Business continuity and disaster recovery for Oracle on an Azure VM](/azure/cloud-adoption-framework/scenarios/oracle-iaas/oracle-disaster-recovery-iaas)
- [Oracle Data Guard broker concepts](https://docs.oracle.com/en/database/oracle/oracle-database/12.2/dgbkr/oracle-data-guard-broker-concepts.html)
- [Oracle active Data Guard far sync zero data loss](https://www.oracle.com/docs/tech/database/disaster-recovery.pdf)
- [Implement Oracle Data Guard on an Azure Linux VM](/azure/virtual-machines/workloads/oracle/configure-oracle-dataguard)
- [Implement Oracle Golden Gate on an Azure Linux VM](/azure/virtual-machines/workloads/oracle/configure-oracle-golden-gate)

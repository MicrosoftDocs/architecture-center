This article describes how to use Oracle Zero Downtime Migration (ZDM) to migrate an Oracle database from an on-premises Exadata system to [Oracle Database@Azure](/azure/oracle/oracle-db/database-overview) (ODAA) Exadata Database Service. This article assumes that you have a basic understanding of ODAA and Oracle ZDM. This scenario builds on the scenario in [Migrate Oracle database workloads to Azure](topic-migrate-oracle-azure.yml).

## Architecture

The following diagram shows an example of this scenario.

:::image type="content" source="_images/migrate-oracle-odaa-exadata/oracle-migration-odaa.svg" alt-text="Diagram that shows an architecture to migrate an on-premises database to ODAA." border="false" lightbox="_images/migrate-oracle-odaa-exadata/oracle-migration-odaa.svg":::

*Download a [Visio file](https://arch-center.azureedge.net/oracle-migration-odaa.vsdx) of this architecture.*

## Scenario

Consider the following scenario details:

- You deployed Oracle Exadata Database@Azure into your chosen Azure region and configured a virtual machine (VM) cluster that has two database servers and three storage cell nodes.

- The ODAA delegated subnet is in the database virtual network, which peers to the hub virtual network. The IP address range of the ODAA subnet is 10.42.1.0/24. For more information, see [Plan for IP address space](https://docs.oracle.com/iaas/Content/database-at-azure/oaa_ip.htm).
- In the hub virtual network, the traffic has to traverse a network virtual appliance (NVA), such as Azure Firewall or a non-Microsoft network virtual appliance. The NVA functions as a routing device, which helps ensure that ODAA cluster nodes are fully routable within the infrastructure. You configure the NVA to inspect all traffic that goes to and from on-premises. The IP address of the hub NVA is 10.0.0.5.
- You configure hybrid connectivity in the hub virtual network via an Azure ExpressRoute connection to your on-premises network.
- In your on-premises network, you have an existing Exadata implementation, and you want to migrate one of the databases to Oracle Exadata Database@Azure. The database is 2 TB and runs on Exadata X8M-2. The database version is Oracle Database 19c, Enterprise Edition. Your on-premises IP address range is 192.168.0.0/16.
- You enabled Real Application Clusters (RAC) on the database. For disaster recovery, you replicate the database via Oracle Data Guard to another datacenter that's geographically distant from the primary database location.
- You need to migrate the database to Oracle Exadata Database@Azure with the minimum amount of downtime. You decide to use the Oracle ZDM tool to orchestrate the migration.

## Establish network connectivity

To use ZDM for migration, you need to ensure that the source and target databases can communicate with each other.

1. Create an Azure route table, and associate it with the ODAA subnet.
1. Point the Azure route table to the IP address of the hub NVA to route to on-premises.
1. Configure the hub NVA to route traffic between on-premises and the ODAA subnet.

### Configure the route table

Use the following configuration to create an Azure route table, and associate it with the ODAA subnet:
  - Address prefix: 192.168.0.0/16
  - Next hop type: Virtual appliance
  - Next hop IP address: 10.0.0.5
  - Name: \<Route table name\>

The following diagram shows the updated network configuration.

:::image type="content" source="_images/migrate-oracle-odaa-exadata/oracle-migration-odaa-destination.svg" alt-text="Diagram that shows an architecture to migrate a database to ODAA and includes the destination." border="false" lightbox="_images/migrate-oracle-odaa-exadata/oracle-migration-odaa-destination.svg":::

Do the following steps to verify connectivity:

- Sign in to an Oracle Exadata Database@Azure database node. Verify that you can use the Secure Shell (SSH) protocol to establish a connection to the on-premises database server.
- Sign in to the on-premises database server. Verify that you can use the SSH protocol to establish a connection to the Oracle Exadata Database@Azure database node.

## Do migration activities

1. Prepare for the migration. For more information, see [Prepare for a physical database migration](https://docs.oracle.com/en/database/oracle/zero-downtime-migration/21.3/zdmug/preparing-for-database-migration.html#GUID-25B07C59-8143-41CB-B431-3D9225CCFDD6).

   > [!NOTE]
   > This guidance assumes that you have sufficient bandwidth between the source and target databases to support an online migration. It assumes that you don't need to do an offline migration, or a restore of backup on Oracle Exadata Database@Azure, first.

1. Perform the migration. For more information, see [Migrate your database with ZDM](https://docs.oracle.com/en/database/oracle/zero-downtime-migration/21.3/zdmug/migrating-with-zero-downtime-migration.html#GUID-C20DB7D4-E0CE-4B50-99D0-B16C18DDD34B).

1. Do the following application migration activities in parallel with the database migration to help ensure the least amount of downtime.
    - Migrate application services in accordance with your plans and discussions.
    - Update the application services to point to the new database, including the connection string, Transparent Network Substrate (TNS) entries, and other required configurations.
    - Verify that the application services work as expected.

The following diagram shows the updated configuration, including the ZDM migration node.

:::image type="content" source="_images/migrate-oracle-odaa-exadata/oracle-migration-odaa-zero-downtime.svg" alt-text="Diagram that shows an architecture to migrate a database to ODAA and includes the ZDM migration node." border="false" lightbox="_images/migrate-oracle-odaa-exadata/oracle-migration-odaa-zero-downtime.svg":::

## Do post-migration activities

- [Configure automated backups](https://docs.public.oneportal.content.oci.oraclecloud.com/iaas/exadatacloud/exacs/manage-databases.html#GUID-21EF9E4B-E5D3-4A52-8B1C-609FBADD2A7D) for the ODAA database.

- [Configure automated Data Guard](https://docs.public.oneportal.content.oci.oraclecloud.com/iaas/exadatacloud/exacs/using-data-guard-with-exacc.html#ECSCM-GUID-603988C3-604A-4305-B20A-EA0FF79C0835). This guidance assumes that you already created a separate instance in another availability zone or region.
- Run the on-premises database as a secondary Data Guard replica for a period of time to ensure that the migration is successful.

## Conclusion

Do the preceding configuration changes to migrate your database from on-premises to Oracle Exadata Database@Azure by using Oracle ZDM. The configuration changes help ensure that the source and target databases can communicate with each other and that you perform the migration with minimal downtime.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

- [Jan Faurskov](https://www.linkedin.com/in/jfaurskov) | Cloud Solution Architect
- [Moises Gomez-Cortez](https://www.linkedin.com/in/moisesjgomez) | Cloud Solution Architect
- [Güher Kayali Sarikan](https://www.linkedin.com/in/guherkayali) | Cloud Solution Architect

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

Review the following articles to ensure that your implementation follows recommended practices:

- [Network topology and connectivity for OD@A](/azure/cloud-adoption-framework/scenarios/oracle-iaas/oracle-network-topology-odaa)
- [Identity and access management for OD@A](/azure/cloud-adoption-framework/scenarios/oracle-iaas/oracle-iam-odaa)
- [Security guidelines for OD@A](/azure/cloud-adoption-framework/scenarios/oracle-iaas/oracle-security-overview-odaa)
- [Manage and monitor OD@A](/azure/cloud-adoption-framework/scenarios/oracle-iaas/oracle-manage-monitor-oracle-database-azure)
- [Business continuity and disaster recovery considerations for OD@A](/azure/cloud-adoption-framework/scenarios/oracle-iaas/oracle-disaster-recovery-oracle-database-azure)
- [Introduction to ZDM](https://docs.oracle.com/en/database/oracle/zero-downtime-migration/21.4/zdmug/introduction-to-zero-downtime-migration.html#GUID-A4EC1775-307C-47A6-89FB-E4C3F1FBC4F5)
- [ZDM physical online migration whitepaper](https://www.oracle.com/a/otn/docs/database/zdm-physical-migration-to-oracle-at-azure.pdf)

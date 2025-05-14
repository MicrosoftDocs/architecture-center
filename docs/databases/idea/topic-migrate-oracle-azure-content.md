This article describes considerations and recommendations that you can use to migrate on-premises Oracle Database workloads to Azure. This article assumes that you have a basic understanding of Oracle Database technologies and Azure networking. This guidance covers the following scenarios:

- Physical migration of Oracle databases to Azure Virtual Machines
- Physical migration of Oracle databases to Oracle Database@Azure (ODAA) Exadata Database Service

## Architecture

The following diagram shows an example of this scenario.

:::image type="content" source="_images/topic-migrate-oracle-azure/oracle-database-azure-migration.svg" alt-text="Diagram that shows an architecture to migrate an on-premises database to Azure." border="false" lightbox="_images/topic-migrate-oracle-azure/oracle-database-azure-migration.svg":::

*Download a [Visio file](https://arch-center.azureedge.net/oracle-database-azure-migration.vsdx) of this architecture.*

## Scenario

Consider the following initial scenario details:

- You have one or more Oracle databases that run in your on-premises datacenter. You want to migrate the databases to Azure.

- The databases run on Oracle Database 19c, Enterprise Edition.
- The databases are Oracle Real Application Clusters (RAC)-enabled. For disaster recovery, you replicate the databases via Oracle Data Guard to another datacenter that's geographically distant from the primary database location.
- You need to migrate the databases to Azure with the minimum amount of downtime.
- You also want to migrate application services that depend on the databases.
- You established network connectivity to Azure through Azure ExpressRoute, and you use a hub-and-spoke network topology in Azure.
- In the hub virtual network, the traffic has to traverse a network virtual appliance (NVA), such as Azure Firewall or a non-Microsoft network virtual appliance. The NVA functions as a routing device, which helps ensure that traffic to and from Azure undergoes traffic inspection and is also fully routable.

## Implementation checklist

For more information, see:

- [Migrate Oracle database workloads to Azure virtual machines](migrate-oracle-azure-iaas.yml)
- [Migrate Oracle database workloads to OD@A Exadata Database Service](migrate-oracle-odaa-exadata.yml)

## Next step

[Introduction to Oracle on Azure adoption scenarios](/azure/cloud-adoption-framework/scenarios/oracle-iaas)

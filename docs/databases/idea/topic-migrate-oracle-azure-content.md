This article describes considerations and recommendations that you can use to migrate Oracle database workloads from an on-premises environment to Azure. This article assumes that you have a basic understanding of Oracle Database technologies and Azure networking. This guidance covers the following scenarios:

- Physical migration of Oracle databases to Azure virtual machines
- Physical migration of Oracle databases to Oracle Database@Azure, Exadata Database Service (OD@A)

## Scenario

Consider the following initial scenario details:

- You have one or more Oracle databases that run in your on-premises datacenter. You want to migrate the databases to Azure.
- The databases run on Oracle Database 19c, Enterprise Edition.
- The databases are Oracle Real Application Clusters (RAC)-enabled. For disaster recovery, you replication the databases via Oracle Data Guard to another datacenter that's geographically distant from the primary database location.
- You need to migrate the databases to Azure with the minimum amount of downtime.
- You will also migrate application services that depend on the database.
- You established network connectivity to Azure through Azure ExpressRoute and use a hub-and-spoke network topology in Azure.
- In the hub virtual network, the traffic has to traverse a non-Microsoft network virtual appliance (NVA), such as FortiGate, CheckPoint, or Cisco. The NVA functions as a routing device, which helps ensure that traffic to and from Azure undergoes traffic inspection and is also fully routable.

:::image type="content" source="_images/oracle-database-migration-to-azure.jpg" alt-text="{alt-text}" border="false":::

## Implementation checklist

- If you want to migrate to Azure virtual machines, see [Migrate Oracle database workloads to Azure virtual machines](migrate-oracle-azure-iaas.yml).
- If you want to migrate to Oracle Database@Azure, Exadata Database Service, see [Migrate Oracle database workloads to Oracle Database@Azure, Exadata Database Service](migrate-oracle-odaa-exadata.yml).

## Next steps

- [Introduction to Oracle on Azure adoption scenarios](/azure/cloud-adoption-framework/scenarios/oracle-iaas)
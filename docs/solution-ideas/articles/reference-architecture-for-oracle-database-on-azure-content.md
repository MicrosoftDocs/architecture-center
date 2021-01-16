


[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This solution architecture illustrates a canonical architecture to achieve high availability for your Oracle Database Enterprise Edition in Azure. High availability for your front-end as well as the middle tier can be obtained by using Azure Load Balancers or Application Gateways. An uptime availability of 99.99% for your database tier can be achieved using a combination of Azure Availability Zones and Oracle Active DataGuard with FSFO. For additional availability and/or Disaster Recovery, consider deploying another Database VM in a different Azure region and schedule frequent RMAN backups.

## Architecture

![Architecture diagram](../media/reference-architecture-for-oracle-database-on-azure.png)
*Download an [SVG](../media/reference-architecture-for-oracle-database-on-azure.svg) of this architecture.*

## Data Flow

1. The client system accesses a custom application with Oracle DB backend via the web.
1. Web front end is configured in a load balancer.
1. Web front end makes a call to the appropriate Application Server to handle the work.
1. Application server queries primary Oracle Database.
1. Oracle Database has been configured using a HyperThreaded Virtual Machine with multiple Premium storage-based Managed Disks for performance and availability.
1. Oracle databases are replicated with Oracle DataGuard (or Active DataGuard) or Oracle GoldenGate for HA and DR purposes.
1. Oracle databases are monitored for uptime and performance by Oracle Enterprise Manager. OEM also allows you to generate various performance and usage reports.

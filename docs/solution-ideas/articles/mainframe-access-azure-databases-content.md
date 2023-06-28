[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This solution outlines a way for IBM mainframe and midrange applications to access remote Azure databases. The approach requires zero or minimal changes in application code.

IBM Db2 clients and servers use the Distributed Relational Database Architecture (DRDA) protocol to communicate. In this solution, Microsoft Service for DRDA connects Db2 clients on IBM z/OS and IBM i to SQL Server–based databases by supporting this protocol.

## Potential use cases

Various scenarios can benefit from this solution:

- *Coexistent* environments that have modernized data as part of a [data-first][Five reasons a data-first strategy works] migration but still run mainframe or midrange applications.
- *Hybrid* situations, or environments that combine on-premises and cloud datacenters. This case covers systems with mainframe applications in COBOL, PL/I, or assembly language that need access to an SQL Server database hosted in Azure.
- Mainframe or midrange systems with workloads that need remote access to SQL Server databases.

## Architecture

:::image type="complex" source="../media/mainframe-access-azure-databases-architecture.svg" alt-text="Architecture diagram showing how mainframe applications can access Azure databases." border="false":::
   Vertical lines divide the diagram into two parts, one for mainframe components and one for Azure components. The mainframe part has the label IBM and contains two components. The first component contains two cylinders that represent databases (Db2 for z/OS and Db2 for i). The second component is a rectangle that contains the names of mainframe languages and environments. Arrows point back and forth between the cylinder and the rectangle. The Azure part of the diagram contains two rectangles with arrows pointing back and forth between them. The first rectangle represents software and contains a computer icon. The second rectangle contains two icons. One icon has the label PaaS and shows a database in a cloud. The other icon has the label IaaS and shows a computer. Arrows also point back and forth between the mainframe database cylinder and the rectangle that represents software in the Azure part.
:::image-end:::

*Download a [Visio file][Visio version of architecture diagram] of this architecture.*

1. Host Integration Server (HIS) software runs on an on-premises or Azure virtual machine (VM). HIS connects IBM systems with Azure systems.

1. Mainframe and midrange applications run on the on-premises system. These applications use languages and environments like COBOL, CICS, TSO, PL1, Java, and JCL. The solution involves adjusting the Db2 database configuration. The applications can then access Azure databases in the same way that they access local mainframe or midrange tables.

1. A mainframe or midrange application sends a SQL request to the local Db2 subsystem. Db2 configurations reroute the request to the HIS server.

1. The HIS server receives the request and forwards it to the target database. Microsoft Service for DRDA is a component of HIS that functions as a DRDA Application Server (AS). In this role, Microsoft Service for DRDA converts the Db2 SQL statements and runs them on the Azure database.

1. The target database handles the request. This solution can configure the following target databases:

   - Azure SQL Database, which offers the benefits of a fully managed platform as a service (PaaS).
   - SQL Server on Azure Virtual Machines. As an infrastructure as a service (IaaS) offering, this service provides a customizable database engine.
   - SQL Server, a database engine for structured and unstructured data.

   These database services can also form the core of business intelligence solutions that offer analytics and insights.

### Components

This solution uses the following components. See the [Azure pricing calculator][Azure pricing calculator] to estimate costs for Azure resources.

#### Data stores

- [SQL Database][What is Azure SQL Database?] is a relational database service that's part of the [Azure SQL][What is Azure SQL?] family. As a fully managed service, SQL Database handles database management functions like upgrading, patching, backups, and monitoring. SQL Database also provides AI-powered, automated features that optimize performance and durability. Serverless compute and Hyperscale storage options automatically scale resources on demand.

- [SQL Server on Azure Virtual Machines][What is SQL Server on Azure Virtual Machines (Windows)] provides a way to migrate SQL Server workloads to the cloud with 100 percent code compatibility. As part of the Azure SQL family, SQL Server on Azure Virtual Machines offers the flexibility and hybrid connectivity of Azure. But this database solution also provides the performance, security, and analytics of SQL Server. With SQL Server on Azure Virtual Machines, you can migrate existing apps or build new apps. You can also access the latest SQL Server updates and releases.

- [SQL Server][SQL Server technical documentation] provides a solution for storing and querying structured and unstructured data. This database engine features industry-leading performance and security.

#### Tools

- [HIS][What is HIS] software connects IBM systems with Azure systems. HIS runs on an on-premises or Azure VM. HIS provides integration services for networks, data, applications, messaging, and security features.

- [Microsoft Service for DRDA][Microsoft Service for DRDA] is a component of HIS. Microsoft Service for DRDA is an Application Server (AS) that DRDA Application Requester (AR) clients use. Examples of DRDA AR clients include IBM Db2 for z/OS and Db2 for i. These clients use the AS to convert Db2 SQL statements and run them on SQL Server.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

 * [Nithish Aruldoss](https://www.linkedin.com/in/nithish-aruldoss-b4035b2b) | Engineering Architect
 * [Ashish Khandelwal](https://www.linkedin.com/in/ashish-khandelwas-839a851a3) | Senior Engineering Architect

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- For general information on mainframe modernization and database migration:

  - Contact Azure Data Engineering - Mainframe & Midrange Modernization at [datasqlninja@microsoft.com][Email address for information on mainframe modernization].
  - See [Azure Database Migration Guides][Azure Database Migration Guides].
  - See [Planning and architecting solutions using Microsoft Service for DRDA][Planning and Architecting Solutions Using Microsoft Service for DRDA].
  - See [Migrate databases and data][Migrate databases and data].

- For implementation information:

  - See [Install and configure HIS 2020][Install and configure HIS 2020].
  - Learn how to [add information on a target database to an HIS server configuration][Configuring SQL Server Connections].
  - See how to [configure a Db2 database to reroute requests to an HIS server][Configuring DB2 for z-OS].

## Related resources

- [Mainframe file replication and sync on Azure][Mainframe file replication and sync on Azure]
- [Replicate and sync mainframe data in Azure][Replicate and sync mainframe data in Azure]
- [Modernize mainframe and midrange data][Modernize mainframe and midrange data]
- [Migrate IBM mainframe applications to Azure with TmaxSoft OpenFrame][Migrate IBM mainframe applications to Azure with TmaxSoft OpenFrame]

[Azure Database Migration Guides]: /data-migration
[Azure pricing calculator]: https://azure.microsoft.com/pricing/calculator
[Configuring DB2 for z-OS]: /host-integration-server/core/configuring-db2-for-z-os
[Configuring SQL Server Connections]: /host-integration-server/core/configuring-sql-server-connections
[DRDA]: https://en.wikipedia.org/wiki/DRDA
[Email address for information on mainframe modernization]: mailto:datasqlninja@microsoft.com
[Five reasons a data-first strategy works]: http://www.enterpriseappstoday.com/data-management/5-reasons-a-data-first-strategy-works.html
[Install and configure HIS 2020]: /host-integration-server/install-and-config-guides/installing-his-2020
[Mainframe file replication and sync on Azure]: ./mainframe-azure-file-replication.yml
[Microsoft Service for DRDA]: /host-integration-server/what-is-his#Data
[Migrate databases and data]: /azure/cloud-adoption-framework/infrastructure/mainframe-migration/application-strategies#migrate-databases-and-data
[Migrate IBM mainframe applications to Azure with TmaxSoft OpenFrame]: ./migrate-mainframe-apps-with-tmaxsoft-openframe.yml
[Modernize mainframe and midrange data]: /azure/architecture/example-scenario/mainframe/modernize-mainframe-data-to-azure
[Planning and Architecting Solutions Using Microsoft Service for DRDA]: /host-integration-server/core/planning-and-architecting-solutions-using-microsoft-service-for-drda
[Replicate and sync mainframe data in Azure]: ../../reference-architectures/migration/sync-mainframe-data-with-azure.yml
[SQL Server technical documentation]: /sql/sql-server
[Visio version of architecture diagram]: https://arch-center.azureedge.net/US-1826653-PR-2782-mainframe-access-azure-databases-architecture.vsdx
[What is Azure SQL Database?]: /azure/azure-sql/database/sql-database-paas-overview
[What is Azure SQL?]: /azure/azure-sql/azure-sql-iaas-vs-paas-what-is-overview
[What is HIS]: /host-integration-server/what-is-his
[What is SQL Server on Azure Virtual Machines (Windows)]: /azure/azure-sql/virtual-machines/windows/sql-server-on-azure-vm-iaas-what-is-overview
[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

Data-first strategies can help digital transformations succeed. But finding a coexistence model for a mainframe and midrange data platform modernization can be challenging. The best models offer target data platforms that require no changes in application code and are compatible with current platforms. To offer compatibility, platforms can support the Distributed Relational Database Architecture (DRDA) protocol. IBM Db2 clients and servers communicate by using DRDA.

This solution outlines a data integration approach that meets these criteria:

- Requires zero or minimal changes in code.
- Offers flexible, scalable data transformation and data access capabilities.
- Uses Azure databases as the target data platform.
- Supports DRDA through Microsoft Service for DRDA.

## Potential use cases

Various mainframe and midrange integration scenarios can benefit from this solution:

- Coexistent or hybrid environments that run applications on mainframe or midrange systems but have modernized data to Azure.
- Systems that modernize the data tier first as part of a data-first strategy.
- Systems with mainframe applications in COBOL, PL/I, or assembly language that need access to an Azure or SQL Server database.

## Architecture

:::image type="complex" source="../media/mainframe-azure-data-integration-architecture.png" alt-text="Architecture diagram showing how mainframe applications can access Azure databases." border="false":::
   The diagram contains two parts, one for mainframe components and one for Azure components. The mainframe part contains a cylinder that represents a database. That part also contains a rectangle filled with the names of mainframe languages and environments. The Azure part contains two rectangles. The first rectangle represents software and contains a computer icon. The second rectangle contains two icons. The first icon has the label PaaS and shows a database in a cloud. The second icon has the label IaaS and shows a computer. Arrows point back and forth between the icons and components that represent applications, databases, and software.
:::image-end:::

1. Host Integration Server (HIS) software runs on an on-premises or Azure virtual machine (VM). HIS helps IBM host systems connect with Azure systems.

   The solution requires these steps:

   1. [Set up HIS][Install and configure HIS 2020].
   1. [Add information on the target database to the HIS server configuration][Configuring SQL Server Connections].

1. Mainframe and midrange applications run on the local system. These applications use languages and environments like COBOL, CICS, TSO, PL1, Java, and JCL. To access the Azure data store, no significant changes are needed in this code. The applications can access Azure databases in the same way that they access local mainframe or midrange tables.

1. A mainframe or midrange application sends a SQL request to the local Db2 subsystem. The solution uses these Db2 configurations, which reroute the request to the HIS server:

   - The SYSIBM.IPNAMES table contains the IP address of the HIS server. For more information, see [Update SYSIBM.IPNAMES table][Update SYSIBM.IPNAMES table].
   - The SYSIBM.LOCATIONS table contains the name, address, and other properties of the target database. For more information, see [Update SYSIBM.LOCATIONS table][Update SYSIBM.LOCATIONS table].

1. The HIS server receives the request and forwards it to the target database. Microsoft Service for DRDA is a component of HIS that functions as a DRDA Application Server (AS). In this role, Microsoft Service for DRDA converts the Db2 SQL statements and runs them on the Azure database.

1. The target database handles the request. This solution can configure the following target databases:

   - Azure SQL Database, which offers all the benefits of a fully managed and evergreen platform as a service (PaaS).
   - SQL Server on Azure Virtual Machines. As an infrastructure as a service (IaaS) offering, this service provides a customizable database engine.
   
   These database services can also form the core of business intelligence solutions that offer analytics and insights.

### Components

This solution uses the following components. See the [Azure pricing calculator][Azure pricing calculator] to estimate costs for Azure resources.

#### Data stores

- [SQL Database][What is Azure SQL Database?] is part of the [Azure SQL][What is Azure SQL?] family. This relational database service is evergreen and is built for the cloud. SQL Database also provides AI-powered, automated features that optimize performance and durability. Serverless compute and Hyperscale storage options automatically scale resources on demand.

- [SQL Server on Azure Virtual Machines][What is SQL Server on Azure Virtual Machines (Windows)] provides a way to migrate SQL Server workloads to the cloud with 100 percent code compatibility. As part of the Azure SQL family, SQL Server on Azure Virtual Machines offers the flexibility and hybrid connectivity of Azure. But this database solution also provides the performance, security, and analytics of [SQL Server][SQL Server technical documentation]. With SQL Server on Azure Virtual Machines, you can migrate existing apps or build new apps. You can also access the latest SQL Server updates and releases, including SQL Server 2019.

#### Tools

- [HIS][What is HIS] software helps IBM host systems connect with Azure systems. HIS runs on an on-premises or Azure VM. HIS provides integration services for networks, data, applications, messaging, and security features.

- [Microsoft Service for DRDA][Microsoft Service for DRDA] is a component of HIS. Microsoft Service for DRDA is an Application Server (AS) that DRDA Application Requester (AR) clients use. Examples of DRDA AR clients include IBM Db2 for z/OS and Db2 for i5/OS. These clients use the AS to convert Db2 SQL statements and run them on SQL Server.

## Next steps

- For more information, contact Azure Data Engineering - Mainframe & Midrange Modernization at [datasqlninja@microsoft.com][Email address for information on mainframe modernization].
- See [Azure Database Migration Guides][Azure Database Migration Guides].
- See [Planning and architecting solutions using Microsoft Service for DRDA][Planning and Architecting Solutions Using Microsoft Service for DRDA].
- See [Migrate databases and data][Migrate databases and data].

## Related resources

- [Mainframe file replication and sync on Azure][Mainframe file replication and sync on Azure]
- [Replicate and sync mainframe data in Azure][Replicate and sync mainframe data in Azure]
- [Modernize mainframe and midrange data][Modernize mainframe and midrange data]
- [Migrate IBM mainframe applications to Azure with TmaxSoft OpenFrame][Migrate IBM mainframe applications to Azure with TmaxSoft OpenFrame]

[Azure Database Migration Guides]: /data-migration/
[Azure pricing calculator]: https://azure.microsoft.com/pricing/calculator
[Configuring SQL Server Connections]: /host-integration-server/core/configuring-sql-server-connections
[DRDA]: https://en.wikipedia.org/wiki/DRDA
[Email address for information on mainframe modernization]: mailto:datasqlninja@microsoft.com
[Install and configure HIS 2020]: /host-integration-server/install-and-config-guides/installing-his-2020
[Mainframe file replication and sync on Azure]: /azure/architecture/solution-ideas/articles/mainframe-azure-file-replication
[Microsoft Service for DRDA]: /host-integration-server/what-is-his#Data
[Migrate databases and data]: /azure/cloud-adoption-framework/infrastructure/mainframe-migration/application-strategies#migrate-databases-and-data
[Migrate IBM mainframe applications to Azure with TmaxSoft OpenFrame]: /azure/architecture/solution-ideas/articles/migrate-mainframe-apps-with-tmaxsoft-openframe
[Modernize mainframe and midrange data]: /azure/architecture/reference-architectures/migration/modernize-mainframe-data-to-azure
[Planning and Architecting Solutions Using Microsoft Service for DRDA]: /host-integration-server/core/planning-and-architecting-solutions-using-microsoft-service-for-drda
[Replicate and sync mainframe data in Azure]: /azure/architecture/reference-architectures/migration/sync-mainframe-data-with-azure
[SQL Server technical documentation]: /sql/sql-server/
[Update SYSIBM.IPNAMES table]: /host-integration-server/core/configuring-db2-for-z-os#updating-sysibmipnames-table
[Update SYSIBM.LOCATIONS table]: /host-integration-server/core/configuring-db2-for-z-os#updating-sysibmlocations-table
[What is Azure SQL Database?]: /azure/azure-sql/database/sql-database-paas-overview
[What is Azure SQL?]: /azure/azure-sql/azure-sql-iaas-vs-paas-what-is-overview
[What is HIS]: /host-integration-server/what-is-his
[What is SQL Server on Azure Virtual Machines (Windows)]: /azure/azure-sql/virtual-machines/windows/sql-server-on-azure-vm-iaas-what-is-overview

[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

When you migrate an on-premises mainframe or midrange application to Azure, data transfer is a key consideration. Several modernization scenarios require you to replicate files to Azure quickly or to maintain synchronization between on-premises files and Azure files.

This article describes several ways to transfer files to Azure, convert and transform file data, and store the data on-premises and in Azure.

## Architecture

:::image type="complex" border="false" source="../media/mainframe-azure-file-replication-updated.svg" alt-text="Diagram that shows the three steps of migrating on-premises files to Azure: data transfer, conversion and transformation, and storing in persistent storage." lightbox="../media/mainframe-azure-file-replication-updated.svg":::
   The image contains an on-premises section and an Azure section that both have multiple sections and subsections. The on-premises section shows the first step in the migration process. It includes three flows. The first flow points from Local storage to an icon that represents FTP using JCL and then to a section that contains Azure Virtual Machines. The second flow points from a Mainframe dataset to SHIR and then to Azure Data Factory via the Azure Data Factory FTP connector. The last flow points from an IBM mainframe to Azure Blob Storage via non-Microsoft solutions. The Azure section contains steps two and three. The step two section contains a subsection that includes Host Integration Server, Azure Databricks and Microsoft Fabric paired together, Azure Data Factory, and Azure Data Lake Storage. Azure Data Factory points to Data Lake Storage and Fabric Data Factory points to OneLake. The step three section contains Azure SQL Database, Azure Database for PostgreSql, Azure Cosmos DB, Azure Database for MySQL, Data Lake Storage, Blob Storage, and Microsoft Fabric.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/mainframe-azure-file-replication-updated.vsdx) of this architecture.*

### Dataflow

The following dataflow corresponds to the architecture diagram:

1. Transfer files to Azure:

   - The easiest way to transfer files on-premises to Azure is by using [File Transfer Protocol (FTP)](https://wikipedia.org/wiki/File_Transfer_Protocol). You can host an FTP server on an Azure virtual machine (VM). A simple FTP job control language (JCL) sends files to Azure in binary format, which is essential to preserving mainframe and midrange computation and binary data types. You can store transmitted files in on-premises disks, Azure VM file storage, or Azure Blob Storage.

   - You can also upload on-premises files to Blob Storage by using tools like [AzCopy](/azure/storage/common/storage-use-azcopy-v10).

   - The Azure Data Factory FTP or Secure File Transfer Protocol (SFTP) connector can be used to transfer data from the mainframe system to Blob Storage. This method requires an intermediate VM on which a self-hosted integration runtime is installed.

   - You can also find non-Microsoft tools on the [Microsoft Marketplace](https://marketplace.microsoft.com/marketplace/apps?search=mainframe) to transfer files from mainframes to Azure.

1. Orchestrate, convert, and transform data:

   - Azure can't read IBM Extended Binary Coded Decimal Interchange Code (EBCDIC) code page files in Azure VM disks or Blob Storage. To make these files compatible with Azure, Host Integration Server (HIS) converts them from EBCDIC to American Standard Code for Information Interchange (ASCII) format.

     Copybooks define the data structure of COBOL, PL/I, and assembly language files. HIS converts these files to ASCII based on the copybook layouts.

   - Mainframe file data conversion can be achieved by using the Azure Logic Apps connector for IBM host files.

   - Before you transfer data to Azure data stores, you might need to transform the data or use it for analytics. Azure Data Factory can manage these extract-transform-load (ETL) and extract-load-transform (ELT) activities and store the data directly in Azure Data Lake Storage. Alternatively, you can use Fabric Data Factory and OneLake store.

   - For big data integrations, Azure Databricks, as well as Microsoft Fabric, can perform all transformation activities fast and effectively by using the Apache Spark engine for in-memory computations.

1. Store data:

   You can store transferred data in one of several available persistent Azure storage modes, depending on your requirements.

   - If analytics aren't required, Azure Data Factory can store data directly in a wide range of storage options, such as Data Lake Storage, Blob Storage, and Microsoft Fabric OneLake.

   - [Azure hosts various databases](/azure/architecture/guide/technology-choices/data-options) that address different needs:

     - Relational databases include the SQL Server family and open-source databases like PostgreSQL and MySQL.

     - Nonrelational databases include Azure Cosmos DB, which is a fast, multi-model, globally distributed NoSQL database.

   Review analytics and business intelligence. [Microsoft Fabric](/fabric/get-started/microsoft-fabric-overview) is an all-in-one analytics solution that covers everything from data movement to data science, real-time analytics, and business intelligence. It offers a suite of services, including data lake, data engineering, and data integration, all in one place.

### Components

This architecture uses the following components.

#### Networking

An [on-premises data gateway](/data-integration/gateway/service-gateway-onprem) is bridge software that connects on-premises data sources to cloud services. In this architecture, it enables communication between mainframe systems and Azure services for file transfer and integration. You can install the gateway [on a dedicated on-premises VM](/azure/logic-apps).

#### Data integration and transformation

This architecture outlines various Azure-native migration tools that you can use based on your mainframe source data and target database.

- [Data Provider for Host Files](/host-integration-server/core/data-for-host-files) is a component of [HIS](/host-integration-server/what-is-his) that converts EBCDIC code page files to ASCII. The provider can read and write records offline in a local binary file. Or it can use Systems Network Architecture (SNA) or Transmission Control Protocol/Internet Protocol (TCP/IP) to read and write records in remote IBM z/OS mainframe datasets or i5/OS physical files. HIS connectors are available for [BizTalk](/host-integration-server/core/biztalk-adapter-for-host-files-configuration1) and [Logic Apps](/azure/logic-apps/logic-apps-overview). In this architecture, Data Provider for Host Files enables file-level access and transformation of IBM z/OS and i5/OS datasets for migration to Azure.

- [Azure Data Factory](/azure/data-factory/introduction) is a hybrid data integration service that you can use to create, schedule, and orchestrate ETL and ELT workflows. In this architecture, Azure Data Factory transfers mainframe files to Blob Storage via FTP and manages transformation pipelines.

- [Azure Databricks](/azure/well-architected/service-guides/azure-databricks-security) is an Apache Spark-based analytics platform optimized for Azure. In this architecture, it enriches and correlates incoming mainframe data with other datasets for advanced analytics and transformation.
  
- [Microsoft Fabric](/fabric/get-started/microsoft-fabric-overview) is an intelligent data platform with a suite of cloud services and tools for every data life cycle stage, including ingestion, preparation, storage, analysis, and visualization. In this architecture, Fabric enables organizations to study data movement, experiment with data science, and perform real-time analytics and business intelligence on transformed mainframe data.

- [Logic Apps](/azure/logic-apps/logic-apps-overview) is a cloud-based service that you can use to automate workflows and integrate applications, data, and services across different environments. In this architecture, it uses the IBM Host File connector to interact with mainframe systems and automate file parsing and transformation.

#### Databases

This architecture outlines the process of migrating mainframe file data to cloud storage and managed databases in Azure. It includes converting mainframe file metadata to match the target schema in Azure.

- [Azure SQL Database](/azure/well-architected/service-guides/azure-sql-database) is a scalable relational cloud database service. SQL Database is evergreen and always up-to-date, with AI-powered and automated features that optimize performance and durability. Serverless compute and hyperscale storage options automatically scale resources on demand. In this architecture, SQL Database stores transformed mainframe data and supports high availability. It also supports cost efficiency through [Azure Hybrid Benefit](/azure/virtual-machines/windows/hybrid-use-benefit-licensing) because you can use your existing on-premises SQL Server licenses on the cloud with no extra cost.

- [Azure SQL Managed Instance](/azure/well-architected/service-guides/azure-sql-managed-instance/reliability) is a platform as a service (PaaS) offering that provides full SQL Server compatibility with managed infrastructure. In this architecture, it modernizes legacy applications by hosting migrated mainframe data with minimal code changes.

- [SQL Server on Azure Virtual Machines](/azure/azure-sql/virtual-machines/windows/sql-server-on-azure-vm-iaas-what-is-overview?view=azuresql) is an infrastructure as a service (IaaS) solution that lifts and shifts SQL Server workloads to Azure, which combines the flexibility and hybrid connectivity of Azure with SQL Server performance, security, and analytics. In this architecture, it provides control over SQL Server configurations for hosting mainframe-derived data.

- [Azure Database for PostgreSQL](/azure/well-architected/service-guides/postgresql) is a managed open-source relational database service. In this architecture, it serves as a target for migrated mainframe data that requires PostgreSQL compatibility.

- [Azure Database for MySQL](/azure/well-architected/service-guides/azure-db-mysql-cost-optimization) is a managed MySQL database service. In this architecture, it supports workloads that require MySQL-based storage for transformed mainframe data.

- [Azure Cosmos DB](/azure/well-architected/service-guides/cosmos-db) is a globally distributed NoSQL database service that includes multi-model support. In this architecture, it stores high-performance, scalable applications built on transformed mainframe data.

#### Other data stores

- [Blob Storage](/azure/well-architected/service-guides/azure-blob-storage) is a cloud-based object storage solution that stores large amounts of unstructured data, such as text or binary data. You can access this data from anywhere via HTTP or HTTPS. You can use Blob Storage to expose data publicly or to store application data privately. In this architecture, it stores binary and text files transferred from mainframe systems and serves as a staging area for transformation.

- [Data Lake Storage](/azure/storage/blobs/data-lake-storage-introduction) is a storage repository that holds a large amount of data in native, raw format. Data Lake Storage provides scaling for big data analytics workloads with terabytes and petabytes of data. The data typically comes from multiple heterogeneous sources, and can be structured, semi-structured, or unstructured. In this architecture, it stores raw and transformed mainframe data in native format for processing by analytics services.

- [OneLake in Microsoft Fabric](/fabric/onelake/onelake-overview) is a single, unified, logical data lake. In this architecture, it serves as the storage destination for Fabric Data Factory pipelines. It provides a centralized location to store transformed mainframe data for analytics and business intelligence workloads.

## Scenario details

Converting mainframe files from EBCDIC-encoded format to ASCII format is necessary for migrating data from mainframe systems to Azure cloud storage and databases. Mainframe applications generate and handle large amounts of data daily. This data must be accurately converted for use in other platforms.

As your organization transitions mainframe file system data, you should transform file metadata into cloud-native schematics. And develop a migration strategy that includes effective file conversion techniques.

## Potential use cases

On-premises file replication and synchronization are essential for various use cases:

- Downstream or upstream dependencies, like when applications that run on a mainframe and applications that run on Azure need to exchange data via files
  
- Parallel testing of rehosted or re-engineered applications on Azure with on-premises applications
  
- Tightly coupled on-premises applications on systems that can't be immediately remediated or modernized
  
## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal authors:

- [Nithish Aruldoss](https://www.linkedin.com/in/nithish-aruldoss-b4035b2b) | Engineering Architect
- [Ashish Khandelwal](https://www.linkedin.com/in/ashish-khandelwal-839a851a3/) | Principal Engineering Architecture Manager

Other contributors:

- [Gyani Sinha](https://www.linkedin.com/in/gyani-sinha/) | Senior Cloud Solution Architect

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- For more information, contact the [Microsoft SQL Data Engineering team](mailto:datasqlninja@microsoft.com).
- [Azure database migration guides](https://datamigration.microsoft.com)

## Related resources

- [Replicate and sync mainframe data in Azure](../../reference-architectures/migration/sync-mainframe-data-with-azure.yml)
- [Modernize mainframe and midrange data](../../example-scenario/mainframe/modernize-mainframe-data-to-azure.yml)
- [Unisys mainframe migration with Avanade Automated Migration Technology](../../reference-architectures/migration/unisys-mainframe-migration.yml)

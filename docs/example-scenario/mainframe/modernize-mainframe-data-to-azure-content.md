This reference architecture outlines an end-to-end modernization plan for mainframe and midrange data sources.

## Architecture

:::image type="complex" source="./images/modernize-mainframe-data-with-azure.png" alt-text="Architecture diagram that shows how to modernize mainframe and midrange systems by migrating data to Azure." border="false":::
:::image-end:::

The diagram contains two parts, one for on-premises components, and one for Azure components. The on-premises part contains boxes that represent the file system, the relational and non-relational databases, and the object conversion components. Arrows point from the on-premises components to the Azure components. One of those arrows goes through the object conversion box, and one is labeled on-premises data gateway. The Azure part contains boxes that represent data ingestion and transformation, data storage, Azure services, and client apps. Some arrows point from the on-premises components to the tools and services in the data integration and transformation box. Another arrow points from that box to the data storage box, which contains databases and data stores. Additional arrows point from data storage to Azure services and to client apps.

*Download a [Visio file][Visio version of architecture diagram] of this architecture.*

### Dataflow

Mainframe Data tiers modernization must pass through the process below and steps to orchestrate dataflow.

1. **On-Premises Data Gateway** The [on-premises data gateway](/data-integration/gateway) acts as a bridge. It provides quick and secure data transfer between Mainframe on-premises data to Azure Services. 
1. **Object conversion**

   The object conversion process extracts object definitions from sources. The definitions are then converted into corresponding objects on the target data store.

   -	[Microsoft SQL Server Migration Assistant](/sql/ssma/sql-server-migration-assistant) (SSMA) for Db2 migrates schemas and data from IBM Db2 databases to Azure databases.
   - Data Provider for Host Files converts objects by:
       - Parsing COBOL and RPG record layouts, or copybooks.
       - Mapping the copybooks to C# objects that .NET applications use.
   -	Third-party tools perform automated object conversion on non-relational databases, file systems, and other data stores.

1. **Data ingestion and transformation**
 
   In the next step, the process migrates data.

   **File data**

   1. FTP transfers mainframe and midrange datasets with single layouts and unpacked fields in binary format to Azure.
   1. Mainframe Dataset Converter.
    
      Mainframe and midrange systems store data on DASD or tape in EBCDIC format in these types of files:
      - Indexed [VSAM](/sql/ssma/sql-server-migration-assistant) files
      -	Non-indexed [GDG](https://www.ibm.com/support/knowledgecenter/zosbasics/com.ibm.zos.zconcepts/zconcepts_175.htm) files
      - [Flat files](https://www.pcmag.com/encyclopedia/term/flat-file).

      COBOL, PL/I, and assembly language copybooks define the data structure of these files. Data Provider converts the data from EBCDIC to ASCII format based on the copybook layout.

      **ADF Custom Connector**

      The custom connector is a no code solution built using Host File Client (HFC) component of Microsoft Host Integration Server (HIS). With minimal setup the custom connector can be used like any other connectors on [Azure Data Factory (ADF)](https://azure.microsoft.com/products/data-factory) User Interface for Mainframe Dataset conversion.  

      **Host Integration Server**

      [Host Integration Server (HIS)](/host-integration-server/what-is-his) is an industry tried and tested solution for decades. HFC give complete freedom/flexibility to the usage data that is converted from EBCDIC to ASCII. For example, you can generate JSON/XML from the data that is transformed. The Host integration server technologies and tools enables existing IBM Host File system data transformation (EBCDIC to ASCII) efficiently.

     **Azure Synapse with OSS (Open-Source Software)**  

     This conversion solution is built based on industry known Open-Source Software (OSS) in [Azure Synapse](https://azure.microsoft.com/products/synapse-analytics). It covers a wide range of mainframe data structures and desired targets with minimal coding efforts. It is an Apache spark-based solution and a good candidate for huge mainframe dataset workload conversion.

3c) Migrate Relational Database data
IBM mainframe and midrange systems store data in relational databases including:
o	Db2 for z/OS
o	Db2 LUW
o	Db2 for i
     These services migrate the database data:
o	Azure Data Factory uses a Db2 connector to extract and integrate data from these databases.
o	SQL Server Integration Services (SSIS) handles a broad range of data ETL tasks.
3d) Migrate Non-Relational Database data
IBM mainframe and midrange systems store data in non-relational databases including:
o	IDMS, a network model Database Management System (DBMS)
o	IMS, a hierarchical model DBMS
o	ADABAS
o	Datacom
      Third-party products integrate data from these databases.
4) Data Ingestion
Azure services like Data Factory and AzCopy load data into Azure databases and Azure data storage. Third-party solutions and custom loading solutions can also load data.
5) Data storage
Azure offers many managed data storage solutions:
•	Databases:
o	Azure SQL Database
o	Azure Database for PostgreSQL
o	Azure Cosmos DB
o	Azure Database for MySQL
o	Azure Database for MariaDB
o	Azure SQL Managed Instance
•	Storage:
o	Azure Data Lake Storage
o	Azure Blob Storage
Data tier
6) A range of Azure Services use the modernized data tier for computing, analytics, storage, and networking.
7) Existing client applications also use the modernized data tier.




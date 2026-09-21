### Select a database service

The following articles help you evaluate and select the best database technologies for your workload requirements:

- [Prepare to choose a data store in Azure](../guide/technology-choices/data-stores-getting-started.md)
- [Understand data models](../data-guide/technology-choices/understand-data-store-models.md)
- [Choose a data pipeline orchestration technology in Azure](../data-guide/technology-choices/pipeline-orchestration-data-movement.md)
- [Choose a Microsoft Fabric deployment pattern](../data-guide/technology-choices/fabric-deployment-patterns.md)

#### Select a specialized data store model

- [Choose a big data storage technology in Azure](../data-guide/technology-choices/data-storage.md)
- [Choose a search data store in Azure](../data-guide/technology-choices/search-options.md)
- [Choose an Azure service for vector search](../guide/technology-choices/vector-search.md)

### Database solution ideas

The following solution ideas demonstrate implementation patterns and possibilities to explore:

#### Relational solution ideas

- [Migrate an Oracle database to Azure](../databases/idea/topic-migrate-oracle-azure.yml)
- [Migrate an Oracle database to an Azure virtual machine](../databases/idea/migrate-oracle-azure-iaas.yml)
- [Migrate an Oracle database to OD@A Exadata Database Service](../databases/idea/migrate-oracle-odaa-exadata.yml)
- [Cross-region resiliency for SQL TDE with Azure Key Vault Managed HSM](../solution-ideas/articles/secure-sql-managed-instance-managed-hardware-security-module.yml)

#### NoSQL solution ideas

- [Minimal storage – Change feed to replicate data](../databases/idea/minimal-storage-change-feed-replicate-data.yml)

#### Relational and NoSQL

- [Polyglot persistence with Azure Cosmos DB and Azure SQL Database](../databases/idea/combine-relational-nosql.yml)

#### Mainframe solution ideas

- [Replicate and sync mainframe data to Azure](../reference-architectures/migration/sync-mainframe-data-with-azure.yml)

### Database architectures

The following production-ready architectures demonstrate end-to-end database solutions that you can deploy and customize:

#### Data warehouse

- [Modern data warehouse medallion architecture in Microsoft Fabric](../databases/architecture/dataops-mdw.yml)
- [Greenfield lakehouse on Microsoft Fabric](../example-scenario/data/greenfield-lakehouse-fabric.yml)

#### Azure Data Factory reference architectures

- [Design a medallion lakehouse with Azure Data Factory](../databases/architecture/azure-data-factory-on-azure-landing-zones-index.yml)
- [Azure Data Factory baseline architecture in an Azure landing zone](../databases/architecture/azure-data-factory-on-azure-landing-zones-baseline.yml)
- [Azure Data Factory enterprise hardened architecture](../databases/architecture/azure-data-factory-enterprise-hardened.yml)
- [Azure Data Factory mission-critical architecture](../databases/architecture/azure-data-factory-mission-critical.yml)

#### NoSQL architectures

- [Deploy MongoDB Atlas in Azure](../databases/architecture/mongodb-atlas-baseline.md)
- [Set up real-time sync of MongoDB Atlas data changes to Microsoft Fabric](../example-scenario/analytics/sync-mongodb-atlas-fabric-analytics.yml)

#### Mainframe architectures

- [Replicate mainframe data by using Precisely Connect](../example-scenario/mainframe/mainframe-replication-precisely-connect.yml)
- [Use Qlik to replicate mainframe and midrange data to Azure](../example-scenario/mainframe/mainframe-midrange-data-replication-azure-qlik.yml)
- [Replicate mainframe and midrange data to Azure by using RDRS](../example-scenario/mainframe/mainframe-data-replication-azure-rdrs.yml)
- [Migrate mainframe data tier to Azure with mLogica LIBER*IRIS](../example-scenario/mainframe/mainframe-data-replication-azure-data-platform.yml)
- [Modernize mainframe and midrange data](../example-scenario/mainframe/modernize-mainframe-data-to-azure.yml)
- [Re-engineer mainframe batch applications on Azure](../example-scenario/mainframe/reengineer-mainframe-batch-apps-azure.yml)
- [Rehost an IMS database and IMS data communications on Azure by using Raincode IMSql](../example-scenario/mainframe/rehost-ims-raincode-imsql.yml)

#### In-memory data stores

- [Write-through caching with Azure Managed Redis and Azure SQL Database](../databases/architecture/write-through-caching-azure-sql-managed-redis.yml)

#### Relational architectures

- [Oracle Database with Azure NetApp Files](../example-scenario/file-storage/oracle-azure-netapp-files.yml)
- [SAP deployment on Azure by using an Oracle database](../example-scenario/apps/sap-production.yml)

### Database guides

- [Choose a data transfer technology](../data-guide/scenarios/data-transfer.md)
- [Online analytical processing](../data-guide/relational-data/online-analytical-processing.md)
- [Online transaction processing (OLTP)](../data-guide/relational-data/online-transaction-processing.md)
- [Extract, transform, and load (ETL)](../data-guide/relational-data/etl.yml)
- [What is a data lake?](../data-guide/scenarios/data-lake.md)
- [Big data architectures](../databases/guide/big-data-architectures.md)

#### NoSQL guides

- [Implement the Transactional Outbox pattern by using Azure Cosmos DB](../databases/guide/transactional-out-box-cosmos.md)
- [Run Apache Cassandra on Azure VMs](../databases/guide/cassandra.md)

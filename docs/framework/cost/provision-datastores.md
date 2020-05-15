---
title: Cost considerations for data store resources
description: Describes cost strategies for database design choices
author:  PageWriter-MSFT
ms.date: 4/8/2020
ms.topic: article
ms.service: architecture-center
ms.subservice: well-architected
ms.custom: 
---

# Data store cost estimates

Azure data store services are capable of handling large volumes of data with varied processing features and each service has a different billing model. 

Most cloud workloads adopt the _polyglot persistence_ approach. Instead of using one data store service, a mix of technologies are used. To establish a cost estimate, assess the types of data you need to store for each workload. 

First, identify the business transactions and their requirements. 

Let's take an example of an e-commerce application. It needs to store data for transactions such as orders, payments, and billing. The data structure is predetermined and not expected to change frequently. Also, data integrity and consistency are crucial. There is also a need to store product catalogs, social media posts, and product reviews. In some cases, the data is unstructured, and is likely to change overtime. Lastly, media files must also be stored. Also, data must be stored for auditing purposes.

**What type of data is processed in each operation?**
***

Then, break each transaction into operations and identify a data store appropriate for the type of data. 

An inappropriate data store or one that is mis-configured can have a huge cost impact on your design.

For example, instead of storing binary image data in Azure SQL Database as a varbinary (MAX) column type, consider Azure Blob Storage Block Blobs. Blob storage is cheaper than Azure SQL Database.

If your design requires SQL, then store a lookup table in SQL Database, and retrieve the document when needed to serve it to the user in your application middle tier. SQL Database is highly targeted to high speed data lookups and set-based operations. 

The hot access tier of Azure Block Blob Storage cost is cheaper than the equivalent size of the Premium SSD volume that has the database. 

Read [this decision chart](../../guide/technology-choices/data-store-overview.md) to make your choices.

Then, break each transaction into distinct operations. For example, one business transaction can be processed by these distinct operations:
- 10-15 database calls
- 3 append operations on blob
- 2 list operations on two separate file shares

## RDBMS

RDBMS is the recommended choice when you need strong consistency guarantees. These databases implement a transactionally consistent mechanism that conforms to the ACID (Atomic, Consistent, Isolated, Durable) model for updating data. Also, the data structure is well defined and known before a write operation. The read operations must use the structure to read the data. 

**Is the on-premises data already on SQL server?**
***

If the on-premises data is already on a SQL server, it might be a natural choice. The on-premises license with Software Assurance can be used to bring down the cost if the workload is eligible for [Azure Hybrid Benefit](https://azure.microsoft.com/pricing/hybrid-benefit/). This option applies tor Azure SQL Database (PaaS) and SQL Server on Azure Virtual Machines (IaaS).

For open source database such as MySQL, MariaDB, or PostGreSQL, Azure provides a managed services that are easy to provision. 

### Compute
Higher throughput and IOPS require higher compute, memory, I/O and storage limits. Those limits are expressed in a vCore model. With higher vCore number, you buy more resources and consequently the cost is higher. Azure SQL Database has more vCores and allows you to scale in smaller increments. Azure Database for MySQL, PostgreSQL, and MariaDB have fewer vCores and scaling up to a higher vCore can cost more. 
All options offer a consumption and provisioned pricing models.  With pre-provisioned instances, you save more if you can commit to one or three years. 

**Are your write throughput requirements particularly high?**
***

MySQL provides in-memory tables in the **Memory Optimized** tier, which can increase the cost. 

### Primary and backup storage
With Azure SQL Database the initial 32 GB of storage is included in the price. For the other listed options, you have to buy storage separately and might increase the cost depending on your storage needs. 

Database backups are crucial for business continuity and disaster recovery strategy and must be done periodically. In your design, consider the restore strategy and the retention period for your backups. For most databases, the price of backup storage that is equal in size to primary storage, is free. If you need more backup storage, you will incur an additional cost.  

An important consideration is how critical is the data how soon do you need to access data if the primary data center is unavailable.

**How much downtime is acceptable?**
***

Here are some design considerations that will affect your cost:

- If the SLAs don't allow for downtime, can a read-only replica in a different region to enable business continuity? 
- If the database in the other region must be read/write, how will the data be replicated? 
- Does it need to be synchronous, or could the data consistency allow for asynchronous replication?

Azure storage has several options to make sure data is copied and available when needed.  [Locally redundant storage (LRS)](/azure/storage/common/storage-redundancy#locally-redundant-storage) synchronously replicates data in the primary region. If the entire primary center is unavailable the replicated data is lost.  At the expensive end, [Geo-zone-redundant storage (preview) (GZRS)](/azure/storage/common/storage-redundancy#geo-zone-redundant-storage-preview) replicates data in availability zones within the primary region and asynchronously copied to another paired region. Databases that offer geo-redundant storage, such as SQL Database, are more expensive. Most other OSS RDBMS database use LRS storage, which contributes to the lower price range.

For more information, see [automated backups](/azure/sql-database/sql-database-automated-backups?tabs=single-database).

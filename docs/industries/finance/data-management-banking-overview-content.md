Banks today carry responsibility for securing and storing enormous amounts of
valuable information within their firewalls. This information is both about their customers and
about the shifting financial landscape. In many cases, that information goes
unused because it's not easily accessible or searchable, even though use of
data could improve decision making across multiple banking activities.

With this data, banks could find information faster about who is at risk for defaulting on
a loan. Banks can also decide what market portfolio valuation adjustments are needed. Banks
could also have a clearer view of how their data is stored and managed to meet
regulatory requirements. This way, the data can be leveraged, retained, archived, or
deleted to comply.

Thousands of decisions, large and small, are required to meet everyday banking
function requirements. As a result, data becomes increasingly important. Not only that, but
banks are given strict regulatory requirements and financial crime obligations. They need
the ability to audit the results of any data analysis process, all the way back
to the initial information landing into a data repository. Traceability
requires transparency from ingestion to producing actionable data.

To manage the many accounts or businesses that banks are serving, they need to
make sense of all this data rapidly and cost-effectively. As banks mature
digitally, the amount of data and the new opportunities to apply that data are exponentially growing. This growth enables banks to pursue new business models and
areas of customer-centric opportunities.

Having the appropriate data storage strategy in place is key to operational
efficiencies, good application performance, and regulatory compliance. The data
storage strategy is also the initial lynchpin in getting data into formats where
it can be used for business intelligence and actionable insights.

A common pattern to data management follows:

![Data management flow](./images/data-management-banking-overview/data-management-pattern.png)

In this model, “Data Services” describes any transformation, joining of data, or
any other data operations other than archiving. This is the key activity needed
to take advantage of the data to help make more informed decisions.

All banks and financial institutions ingest, move and store data. This article
focuses on bringing data to Azure. The solution helps move you away from traditional on-premises
data storage, processing, archiving, and deletion. By moving data to Azure,
banks and financial institutions can take advantage of fundamental benefits
including:

- Cost control through effectively unlimited global scale, using compute
    resources and data capacity only when and where it's needed.

- Reduction of capital expenditure and management costs through retiring of
    physical servers on-premises.

- Integrated backup and disaster recovery, reducing the cost and complexity of
    data protection.

- Automated archiving of cold data to low cost storage, while still ensuring
    compliance needs are met.

- Access to advanced and integrated data services to process data for
    learning, forecasting, transformation, or other needs.

This article provides recommended techniques to ensure efficient data ingress to
Azure and fundamental data management techniques to use once it's in the cloud.

## Data ingest

Financial Institutions will have data that has already been collected and is
being used by current applications. There are several options for moving this
data to Azure. In many cases existing applications can connect to data in Azure
as though it were on-premises, with minimal changes to those existing
applications. This process is especially true when using Microsoft [Azure SQL
Database](/azure/sql-database/?WT.mc_id=bankdm-docs-dastarr), but through the
[Azure
Marketplace](https://azuremarketplace.microsoft.com/marketplace/apps/category/databases?WT.mc_id=bankdm-docs-dastarr)
solutions can be found for Oracle, Teradata, MongoDB, and others.

Different data migration strategies exist for moving data from on-premises to
Azure and have varying degrees of latency. All the techniques referenced below
provide data transparency and reliable security.

### Virtual Network (VNet) service endpoints

Security is a primary concern when dealing with customer financial information.
The securing of resources (such as a database) within Azure often depends on
setting up a network infrastructure within Azure itself, and then accessing that
network via a specific endpoint.

Before transferring data to Azure, it's useful to consider the network topology
securing both your Azure resources and the connection to them from on-premises.
[Virtual Network service endpoints](/azure/virtual-network/virtual-network-service-endpoints-overview?WT.mc_id=bankdm-docs-dastarr)
provide a secured direct connection to an Azure defined VNet.

VNets are defined in Azure to contain Azure resources within a bounded VNet. An
endpoint to that VNet then enables secure access to your critical Azure service
resources and only to those on the defined VNet.

## Database lift and shift

A “lift and shift” model of database migration is one of the most common
scenarios for using Azure SQL Database. Lift and shift simply means taking
existing on-premises databases and moving them directly to the cloud. Reasons to
do this include the following:

- Move from a current datacenter where prices are higher or some other
    operational reason
- Current on-premises SQL Server database hardware is expiring or nearing
    end-of-life
- To support a general “move to cloud” strategy for the company
- Take advantage of SQL Azure’s availability and disaster recovery
    capabilities

In the case of smaller databases, the first step of data ingestion is typically
creating the datastores and structures (like tables) needed via the Azure
Portal, Azure CLI, or the Azure SDK. For these smaller data stores, the next
steps may be performed by a custom application written to copy the right data to
the appropriate Azure data storage. Typically, the fastest route for larger data migrations is to restore backups
in Azure.

There are many ways to transfer data securely and quickly into Azure. [See this
article](/azure/architecture/data-guide/scenarios/data-transfer?WT.mc_id=bankdm-docs-dastarr)
for some standard techniques with advantages, and disadvantages of each.

### Azure Database Migration Service

When lifting and shifting SQL Server databases the [Microsoft Azure Database
Migration Service](/azure/dms/dms-overview?WT.mc_id=bankdm-docs-dastarr) can
be used to move databases to Azure. The service uses the [Data Migration
Assistant](/sql/dma/dma-overview?WT.mc_id=bankdm-docs-dastarr) to ensure your
on-premises database will be compatible with features offered in Azure SQL. Any
changes required before migrating the database are up to you. Further, use of the
service requires a Site-to-Site internet connection between the on-premises
network and Azure.

### Bulk copy program (BCP) for SQL Server

If SQL Server is on-premises today and the goal is to move to SQL Azure, another
great technique is to use SQL Server Management Studio [and the BCP utility to
move data](https://azure.microsoft.com/blog/bcp-and-sql-azure/?WT.mc_id=bankdm-docs-dastarr) into SQL
Azure. After you script and create Azure SQL databases from the original
on-premises server, BCP can be used to rapidly transfer data into Azure SQL.

### Azure Blob and File storage

Individual bank branches often have their own file stores on local on-premises
servers. This can cause problems with file sharing between branches and result
in having no single source of truth for a given file. Even worse, the
institution may have an “official” file store that branches access, but have
intermittent connectivity or other problems accessing the file share.

Azure has services to help mitigate these problems. Moving this data into Azure
provides a single source of truth for all data and universally accessible
storage with centralized permissions and access controls.

Different data storage solutions may be more suitable for specific data formats.
For example, data stored on-premises in SQL Server is likely best suited for
Azure SQL. Data stored in .csv or Excel files is likely best suited for [Azure
Blob](/azure/storage/blobs/storage-blobs-introduction?WT.mc_id=bankdm-docs-dastarr)
storage or [Azure
Files](/azure/storage/files/storage-files-introduction?WT.mc_id=bankdm-docs-dastarr)
storage, which is implemented on top of the Blob service.

Almost all data flowing in and out of Azure goes through Blob storage as some
part of the data’s movement. Blob storage has the following pillars.

- Durable & Available
- Secure & Compliant
- Manageable & Cost efficient
- Scalable & Performant
- Open & Interoperable

Connecting all branches to the same file share in Azure is often done through
the bank’s existing datacenter as shown in Figure 1. The corporate data center
connects to Files storage through an SMB (Server Message Block) connection.
Logically, and from the site network’s point of view, the file share can be in
the corporate datacenter and can be mounted as any other networked file share.
When you use this technique, data is encrypted at rest and during transport
between the data center and Azure.

![Logical File Sharing](./images/data-management-banking-overview/logical-network-connection.png)

Figure 1

Enterprises often use Files storage to consolidate and secure large volumes of
files. This allows retiring old file servers or repurposing the hardware.
Another advantage of moving to Files storage is to centralize data management
and recovery services.

### Azure Data Box

Often, banks will have terabytes, if not petabytes, of information to bring into Azure. Luckily data stores in Azure are very elastic and highly scalable.

A service focused on migrating very large volumes of data to Azure is [Azure Data
Box](https://azure.microsoft.com/services/storage/databox/?WT.mc_id=bankdm-docs-dastarr). This service
is designed to migrate data without transferring data or backups over an Azure
connection. Suitable for terabytes of data, Azure Data Box is an appliance that
can be ordered from the Azure portal. It's shipped to your location, where it
can be connected to your network and loaded with data via standard NAS protocols
and secured via standard256-AES encryption. Once the data is on the appliance,
it's shipped back to the Azure Data Center where the data is hydrated in Azure.
The device is then securely erased.

## Azure Information Protection

Azure Information Protection (AIP) is a cloud-based solution helping organizations to classify, label, and protect its documents and emails. This can be done automatically by administrators who define rules and conditions, manually by users, or a combination where users are given recommendations.

## Data services

Banks struggle with Master Data Management, meta data conflicting due to disparate core banking systems,
and data coming from origination systems, onboarding systems, offers management systems, CRM systems, and more. Azure has tools to help mitigate these and other commonly occurring data issues.

There are many operations financial services organizations need to perform on
their data. When you write data to Azure data stores, there may be a need to
transform that data or to join it with other data that augments what is being
ingested.

### Azure Data Factory

[Microsoft Azure Data
Factory](/azure/data-factory/introduction?WT.mc_id=bankdm-docs-dastarr) is a
fully managed service to help with ingress, processing, and monitoring data
movement in a Data Factory pipeline. Data Factory activities form the structure
of the data management pipeline.

Data Factory enables transformation or augmentation of data as it flows into
Azure and between other Azure services. Data Factory is a managed cloud service
that's built for complex hybrid extract-transform-load (ETL),
extract-load-transform (ELT), and data integration projects.

For example, data may be fed into analytics pipelines or tools that result in
actionable insights. Data may flow into a machine learning solution or be
transformed to another format for later downstream processing. An example is
converting .csv files to parquet files, which are better suited for machine
learning systems, and storing those parquet files in Blog storage.

Data may also be submitted to downstream compute services, such as [Azure
HDInsight](/azure/hdinsight/hadoop/apache-hadoop-introduction?WT.mc_id=bankdm-docs-dastarr),
[Spark](/azure/hdinsight/spark/apache-spark-overview?WT.mc_id=bankdm-docs-dastarr),
[Azure Data Lake
Analytics](/azure/data-lake-analytics/data-lake-analytics-overview?WT.mc_id=bankdm-docs-dastarr),
and [Azure Machine
Learning](/azure/machine-learning/?WT.mc_id=bankdm-docs-dastarr). This allows
directly feeding systems which result in analysis and intelligent reporting. One
common model for data ingress is shown in Figure 2 below. The data is held in a
common [Data
Lake](/azure/data-lake-store/data-lake-store-overview?WT.mc_id=bankdm-docs-dastarr)
to be used by downstream analytics services.

![A Data Lake ingest model](./images/data-management-banking-overview/data-lake-ingest-model.png)

Figure 2

Data Factory pipelines are composed of activities, which take in and output
datasets. Activities can be assembled into a pipeline defining where you want to
get your data, how you want it processed, and where you want to store the
results. Building pipelines with activities is the heart of Data Factory and
composing a visual workflow right in the Azure portal makes creating pipelines
easy. [See here for a complete
listing](/azure/data-factory/concepts-pipelines-activities?WT.mc_id=bankdm-docs-dastarr)
of activities.

### Azure Databricks

[Azure Databricks](/azure/azure-databricks/?WT.mc_id=bankdm-docs-dastarr) is
a managed Apache Spark based analytics platform in Azure. It's highly scalable
and Spark jobs run on machine clusters as large as needed. Databricks works from
a Notebook which provides a single place of collaboration between data
scientists, data engineers, and business analysts.

Databricks is a logical processing pipeline when data transformation or analysis
is needed. It can be fed directly by Data Factory for machine learning scenarios
where time-to-insight is critical, or for simple file transformations.

![Databricks](./images/data-management-banking-overview/data-pipeline.png)

## Archiving data

When data is no longer needed in an active data store, it can be archived due
for compliance or audit trail purposes in accordance with state and local
banking regulations. Azure has options available for storage of infrequently
accessed data. There are often privacy issues with data that require keeping
data in storage for years.

The costs of storing data can be high, particularly when storing in on-premises
databases. These databases are sometimes accessed infrequently and only to write
new archived data or rid the database of data no longer wanted in the archive.
The infrequent access to on-premises machines means higher total cost of
ownership of the hardware.

### Azure Archive Storage

For unstructured data, such as files or images, Azure offers [several tiers of
storage](/azure/storage/blobs/storage-blob-storage-tiers?WT.mc_id=bankdm-docs-dastarr)
for Blob storage including hot, cool, and archive. The hot access tier is for
data that is active and expected to be most performant and in use in
applications. The cool access tier is for short-term backup and disaster
recovery datasets, as well as for data available to an application but is rarely
accessed. The archive tier has the lowest cost and is intended for data that is
offline.

Archive tier data can be rehydrated into the cool or hot tiers, but this action
may take several hours to complete. Archive storage may be appropriate if your
data isn’t going to be accessed for at least 180 days. When a blob is in archive
storage, it can't be read, but other existing operations may be performed such
as list, delete, and retrieving metadata. The archive data tier is the least
expensive data tier for blob storage.

### Azure SQL Database long-term retention

When you use Azure SQL, there's a [long-term backup retention
service](/azure/sql-database/sql-database-long-term-retention?WT.mc_id=bankdm-docs-dastarr)
for storing backups up to ten years. Users can schedule backups to be retained
for long-term storage such that the backup will be retained for weeks, months,
or even years.

To restore a database from long-term storage, select a specific backup based on
its timestamp. The database can be restored to an existing server under the same
subscription as the original database.

## Deleting unwanted data

To remain compliant with banking regulations or policies regarding data
retention, data must often be deleted when it's no longer wanted. Before
implementing a technical solution for this unwanted data, it's important to
have a purge plan in place so agreed upon policies aren't violated. Data may be
deleted from archive or any other data stores in Azure at any time.

An effective strategy for deleting unwanted data is to do so on an interval,
nightly or weekly being the most common. A [time triggered Azure
Function](/azure/azure-functions/functions-bindings-timer?WT.mc_id=bankdm-docs-dastarr)
can be written to perform this job well. If you delete any data, Microsoft Azure
deletes the data, including any cached or backup copies.

## Getting started

There are many ways to get started based on the current usage and maturity of
the data models used today. In all cases, it's a perfect time to review the
data storage, processing, and the retention model needed per data store. This step is
critical in building data management systems in regulatory compliance scenarios.
The cloud provides new opportunities here, that aren't currently available
on-premises. This may mean updates to existing data models you may have.

Once you're comfortable with new data model, determine your data ingestion
strategy. What data sources are there? Where will the data live in Azure? How
and when will it be moved into Azure? There are many resources available here to
help migrate based on the content type, size and more. The Azure Data Migration
Service is one such example.

Once your data is hosted in Azure, create a data purge plan for data that has
outlived its usefulness or lifespan. While long-term (cold) storage is always a
great option for archiving, clean-up of expired data reduces footprint and
overall storage costs. The backup and archive [Azure solution
architectures](/azure/architecture/browse/?terms=backup+archive)
are good resources to help plan your overall strategy.

## Components

The following technologies are relevant to this solution:

- [Azure Functions](https://azure.microsoft.com/services/functions) is a service that uses serverless scripts and small programs that can run in response to a system event or on a timer.

- [Azure Storage Client Tools](/azure/storage/common/storage-explorers?WT.mc_id=bankdm-docs-dastarr) are tools to access data stores and include far more than the Azure portal.

- [Blob storage](https://azure.microsoft.com/services/storage/blobs) is suitable to store files like text or images and other types of unstructured data.

- [Databricks](https://azure.microsoft.com/free/databricks) is a fully managed service offering easy implementation of a Spark cluster.

- [Data Factory](https://azure.microsoft.com/services/data-factory) is a cloud data integration service used to compose data storage, transit, and processing services into automated data pipelines

## Conclusion

With the rapid change of the digital landscape for the banking and financial
industry, customers are increasingly looking to solutions and partners they can
immediately utilize with no slow ramp up time. As data ingestion increases
exponentially, banks are needing fast, innovative and secure ways to store,
analyze and use their important data.

Azure can help data ingestion, processing, archiving and deletion requirements
using several technologies and strategies. Ingesting data into Azure is simple
and various data stores are available to store data depending on its type,
structure, etc. Data solutions are available beyond SQL Server and SQL Azure to
include 3rd party databases.

Operating and acting on that data can be simple using Azure services like
Databricks and Data Factory. Archival storage is available for long-term storage
of rarely accessed data, and it can be deleted on a rolling cycle, as needed.

## Contributors

*This article is being updated and maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Howard Bush](https://www.linkedin.com/in/howardbush) | Banking and Capital Markets Cloud & AI, Consulting Services
- [David Starr](https://www.linkedin.com/in/davidstarr) | Principal Azure Software Engineer

## Next steps

Visit the Azure solutions library for [backup and archival storage](https://azure.microsoft.com/solutions/architecture/?solution=backup-archive?WT.mc_id=bankdm-docs-dastarr) to get started designing your data management plan.

Product documentation:

- [Azure Functions](/azure/azure-functions/functions-overview)
- [Azure Storage Client Tools](/azure/storage/common/storage-explorers)
- [Introduction to Blob storage](/azure/storage/blobs/storage-blobs-introduction)
- [What is Azure Databricks?](/azure/databricks/scenarios/what-is-azure-databricks)
- [What is Azure Data Factory?](/azure/data-factory/introduction)

## Related resources

- [Loan credit risk and default modeling](../../example-scenario/ai/loan-credit-risk-analyzer-default-modeling.yml)
- [Medical data storage solutions](../../solution-ideas/articles/medical-data-storage.yml)
- [Determine customer lifetime and churn with Azure AI services](../../example-scenario/ai/customer-lifecycle-churn.yml)

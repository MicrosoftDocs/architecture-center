---
title: "Azure readiness database design decisions"
titleSuffix: Microsoft Cloud Adoption Framework for Azure
description: Azure readiness database design decisions
author: BrianBlanchard
ms.author: brblanch
ms.date: 05/15/2019
ms.topic: guide
ms.service: architecture-center
ms.subservice: enterprise-cloud-adoption
---

# Data design decisions

When preparing your landing zone environment for your cloud adoption efforts, you will need to determine the data requirements for hosting your workloads. Azure database products and services support a wide variety of data storage scenarios and capabilities. How you configure your landing zone environment to support these requirements will depend on your workload's governance, technical, and business requirements.

## Identify data services requirements

As part of your landing zone evaluation and preparation, you will want to identify the data stores that your landing zone will need to support. This process involves assessing each of the applications and services that make up your workloads for data storage and access requirements. Once you've identified and documented these requirements, you can create policies for your landing zone controlling what resource types are allowed based on your workload needs.

For each of the applications or services you will be deploying to your landing zone environment, use the following decision tree as a starting point when determining the appropriate data store services to use.

![Azure database services decision tree](../../_images/ready/data-decision-tree.png)

### Key questions

Answering the following questions about your workloads will help you make decisions based on the above tree.

- **Do you need full control or ownership of your database software or host OS?** Some scenarios require a high-degree of control or ownership of the software configuration and host servers of your database workloads. In these scenarios, you can deploy custom IaaS virtual machines that allow you to fully control the deployment and configuration of data services. If you don't face these requirements, PaaS managed database services may reduce your management and operations costs.
- **Will your workloads make use of a relational database technology?** If so, what technology do you plan to use? Azure provides managed PaaS database capabilities for [SQL Database](/azure/sql-database/sql-database-technical-overview), [MySQL](/azure/mysql/overview), [PostgreSQL](/azure/postgresql/overview), [MariaDB](/azure/mariadb/overview).
- **Will your workloads make use of SQL Server?** In Azure, you can have your workloads running in IaaS-based [SQL Server on Azure Virtual Machines](https://azure.microsoft.com/services/virtual-machines/sql-server/) or on the PaaS-based [Azure SQL Database hosted service](/azure/sql-database/sql-database-technical-overview). Choosing which option to use is primarily a question of if you want to manage your database, apply patches, take backups, or you want to delegate these operations to Azure? In certain scenarios, compatibility issues may also require the use of IaaS-hosted SQL Server. For more information on deciding the correct option for your workloads, see [Choose the right SQL Server option in Azure](/azure/sql-database/sql-database-paas-vs-sql-server-iaas).
- **Will your workloads make use of key / value database storage?** [Azure Cache for Redis](/azure/azure-cache-for-redis/cache-overview) offers a high-performance cached key / value data storage solution capable of powering fast, scalable applications. [Azure Cosmos DB](/azure/cosmos-db/introduction) also provides general-purpose key / value storage capabilities.
- **Will your workloads make use of document or graph data?** [Azure Cosmos DB](/azure/cosmos-db/introduction) is multi-model database service supporting a wide variety of data types and APIs, and provides both document and graph database capabilities.
- **Will your workloads make use of column-family data?** [Apache HBase in Azure HDInsight](/azure/hdinsight/hbase/apache-hbase-overview) is built on Apache Hadoop and supports large amounts of unstructured and semi-structured data in a schema-less database organized by column families.
- **Will your workloads require high-capacity data analytics capabilities?** [Azure SQL Data Warehouse](/azure/sql-data-warehouse/sql-data-warehouse-overview-what-is) provides the ability to effectively store and query structured petabyte-scale data. For unstructured big data workloads, [Azure Data Lake](https://azure.microsoft.com/solutions/data-lake/) allows you to store and analyze petabyte-size files and trillions of objects.
- **Will your workload require search engine capabilities?** [Azure Search](/azure/search/search-what-is-azure-search) allows you to build AI-enhanced cloud-based search indexes that can be integrated into your applications.
- **Will your workload make use of time series data?** [Azure Time Series Insights](/azure/time-series-insights/time-series-insights-overview) is built to store, visualize, and query large amounts of time series data, such as that generated by IoT devices.

> [!NOTE]
> You can find additional guidance on assessing database options for each of your application or services in the Azure application architecture guide's [choosing a database service](/azure/architecture/guide/technology-choices/data-store-comparison) section.

## Common database scenarios

The following table illustrates a few common usage scenarios and the recommended database services best suited to handle them.

| **Scenario** | **Data service** |
|-----|-----|
| Globally distributed multi-model database, with support for NoSQL choices. | [Azure Cosmos DB](/azure/cosmos-db/introduction) |
| Fully managed relational database that provisions quickly, scales on the fly, and includes built-in intelligence and security. | [Azure SQL Database](/azure/sql-database/sql-database-technical-overview) |
| Fully managed scalable MySQL relational database, with high availability and security built in at no extra cost. | [Azure Database for MySQL](/azure/mysql/overview) |
| Fully managed scalable PostgreSQL relational database, with high availability and security built in at no extra cost. | [Azure Database for PostgreSQL](/azure/postgresql/overview) |
| Hosting enterprise SQL Server apps in the cloud, with full control over server OS. | [SQL Server on Virtual Machines](/azure/virtual-machines/windows/sql/virtual-machines-windows-sql-server-iaas-overview) |
| Fully managed, elastic data warehouse with security at every level of scale at no extra cost. | [SQL Data Warehouse](/azure/sql-data-warehouse/sql-data-warehouse-overview-what-is) |
| Data lake storage resources capable of supporting Hadoop clusters or HDFS data. | [Azure Data Lake](https://azure.microsoft.com/solutions/data-lake/) |
| High throughput and consistent low-latency data access to power fast, scalable applications. | [Azure Cache for Redis](/azure/azure-cache-for-redis/cache-overview) |
| A fully managed scalable MariaDB relational database, with high availability and security built in at no extra cost. | [Azure Database for MariaDB](/azure/mariadb/overview) |

## Regional availability

Azure lets you deliver services at the scale you need to reach your customers and partners, _wherever they are_. A key factor in planning your cloud deployment is to determine what Azure region will host your workload resources.

The majority of database services are generally available in most Azure regions. However, there are a few regions, mostly targeting governmental customers, that only support a subset of these products. Before deciding on what regions you will deploy your database resources to, we recommend referring to the [regions page](https://azure.microsoft.com/global-infrastructure/services/?regions=all&products=data-factory,sql-server-stretch-database,redis-cache,database-migration,sql-data-warehouse,postgresql,mariadb,cosmos-db,mysql,sql-database) to check the latest status.

To learn more about Azure global infrastructure, you can visit [Azure regions page](https://azure.microsoft.com/global-infrastructure/regions). You can also consult the [products available by region](https://azure.microsoft.com/global-infrastructure/services/?regions=all&products=all) page for specific details on what overall services are available in each Azure region.

## Data residency and compliance requirements

Legal and contractual requirements related to data storage will often apply to your workloads. These requirements may vary based on the location of your organization, the jurisdiction of the physical assets that host your data stores, and your applicable business sector. Components of understanding data obligations include data classification, data location, and the respective responsibilities for data protection under the shared responsibility model. For help with understanding these requirements, see the white paper [Achieving Compliant Data Residency and Security with Azure](https://azure.microsoft.com/resources/achieving-compliant-data-residency-and-security-with-azure).

As part of these compliance efforts you may need to control where your database resources are physically located. Azure regions are organized into groups called geographies. An [Azure geography](https://azure.microsoft.com/global-infrastructure/geographies) ensures that data residency, sovereignty, compliance, and resiliency requirements are honored within geographical and political boundaries. If your workloads are subject to data sovereignty or other compliance requirements, storage resources must be deployed to regions in a compliant Azure geography.

## Establish controls for database services

As part of preparing your landing zone environment, you can establish controls limiting what types of data stores users are allowed to deploy. These controls can help manage costs and limit security risks, while still allowing developers and IT teams to deploy and configure resources needed to support your workloads.

After you've identified and documented your landing zone's requirements, you can use [Azure Policy](/azure/governance/policy/overview) to control the database resources you allow users to create. These controls may take the form of [allowing or denying the creation of database resource types](/azure/governance/policy/samples/allowed-resource-types), for instance restricting users to creating only Azure SQL Database resources. Policy can also be used to control the allowable options when creating a resource, like [restricting what SQL Database SKUs can be provisioned](/azure/governance/policy/samples/allowed-sql-db-skus), or only [allowing specific versions of SQL server](/azure/governance/policy/samples/require-sql-12) to be installed on an IaaS VM.

Policies can be scoped to resources, resource groups, subscriptions, or management groups. These policies can also be included in [Azure Blueprint](/azure/governance/blueprints/overview) definitions and applied repeatedly throughout your cloud estate.

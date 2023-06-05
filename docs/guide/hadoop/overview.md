---
title: Hadoop migration to Azure
description: Learn about migrating Hadoop to Azure. This is an overview that has links to articles about Hadoop features such as HBase, HDFS, Kafka, Sqoop, and Storm.
author: martinekuan
ms.author: namratam
ms.date: 09/29/2022
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
categories:
  - migration
products:
  - azure-hdinsight
  - azure-cosmos-db
  - azure-data-lake-storage
  - azure-synapse-analytics
  - azure-stream-analytics
---

# Hadoop migration to Azure

Apache Hadoop provides a distributed file system and a framework for using MapReduce techniques to analyze and transform very large data sets. An important characteristic of Hadoop is the partitioning of data and computation across many (thousands) of hosts. Computations are done in parallel close to the data. A Hadoop cluster scales computation capacity, storage capacity, and I/O bandwidth simply by adding commodity hardware.

This article is an overview of migrating Hadoop to Azure. The other articles in this section provide migration guidance for specific Hadoop components. They are:

- [Apache HDFS migration to Azure](apache-hdfs-migration.yml)
- [Apache HBase migration to Azure](apache-hbase-migration.yml)
- [Apache Kafka migration to Azure](apache-kafka-migration.yml)
- [Apache Sqoop migration to Azure](apache-sqoop-migration.yml)

Hadoop provides an extensive ecosystem of services and frameworks. These articles don't describe the Hadoop components and Azure implementations of them in detail. Instead, they provide high-level guidance and considerations to serve as a starting point for you to migrate your on-premises and cloud Hadoop applications to Azure.

*[Apache](https://www.apache.org)®, [Apache Spark®](https://spark.apache.org), [Apache Hadoop®](https://hadoop.apache.org), [Apache HBase](https://hbase.apache.org), [Apache Hive](https://hive.apache.org), [Apache Ranger®](https://ranger.apache.org), [Apache Sentry®](https://sentry.apache.org), [Apache ZooKeeper®](https://zookeeper.apache.org), [Apache Storm®](https://storm.apache.org), [Apache Sqoop®](https://sqoop.apache.org), [Apache Flink®](https://flink.apache.org), [Apache Kafka®](https://kafka.apache.org), and the flame logo are either registered trademarks or trademarks of the Apache Software Foundation in the United States and/or other countries. No endorsement by The Apache Software Foundation is implied by the use of these marks.*

## Hadoop components

The key components of a Hadoop system are listed in the following table. For each component there's a brief description, and migration information such as:

- Links to decision flowcharts for deciding on migration strategies
- A list of possible Azure target services

|Component | Description| Decision flowcharts|Targeted Azure services|
|----------|-----------|-----------|-----------|
|[Apache HDFS](apache-hdfs-migration.yml) |Distributed file system |[Planning the data migration](images/hdfs-1-data-migration-planning.png), [Pre-checks prior to data migration](images/hdfs-2-pre-checks.png)|Azure Data Lake Storage|
|[Apache HBase](apache-hbase-migration.yml) |Column-oriented table service |[Choosing landing target for Apache HBase](images/flowchart-hbase-azure-landing-targets.png), [Choosing storage for Apache HBase on Azure](images/flowchart-hbase-azure-storage-options.png)|HBase on a virtual machine (VM), HBase in Azure HDInsight, Azure Cosmos DB|
|[Apache Spark](https://github.com/Azure/Hadoop-Migrations/tree/main/docs/spark) |Data processing framework |[Choosing landing target for Apache Spark on Azure](images/flowchart-spark-azure-landing-targets.png)|Spark in HDInsight, Azure Synapse Analytics, Azure Databricks|
|[Apache Hive](https://github.com/Azure/Hadoop-Migrations/tree/main/docs/hive) |Data warehouse infrastructure |[Choosing landing target for Hive](images/hive-decision-matrix.png), [Selecting target DB for Hive metadata](images/hive-metadata-db-decision-flow.png)|Hive on a VM, Hive in HDInsight, Azure Synapse Analytics|
|[Apache Ranger](https://github.com/Azure/Hadoop-Migrations/tree/main/docs/ranger) |Framework for monitoring and managing data security||Enterprise Security Package for HDInsight, Azure Active Directory (Azure AD), Ranger on a VM|
|[Apache Sentry](https://github.com/Azure/Hadoop-Migrations/tree/main/docs/sentry)|Framework for monitoring and managing data security|[Choosing landing targets for Apache Sentry on Azure](images/authorization-service.png)|Sentry and Ranger on a VM, Enterprise Security Package for HDInsight, Azure AD|
|[Apache MapReduce](https://github.com/Azure/Hadoop-Migrations/tree/main/docs/mapreduce) |Distributed computation framework||MapReduce, Spark|
|[Apache Zookeeper](https://github.com/Azure/Hadoop-Migrations/tree/main/docs/zookeeper) |Distributed coordination service||ZooKeeper on a VM, built-in solution in platform as a service (PaaS)|
|[Apache YARN](https://github.com/Azure/Hadoop-Migrations/tree/main/docs/yarn) | Resource manager for Hadoop ecosystem||YARN on a VM, built-in solution in PaaS|
|[Apache Sqoop](apache-sqoop-migration.yml)|Command line interface tool for transferring data between Apache Hadoop clusters and relational databases|[Choosing landing targets for Apache Sqoop on Azure](images/flowchart-sqoop-azure-landing-targets.png)|Sqoop on a VM, Sqoop in HDInsight, Azure Data Factory|
|[Apache Kafka](apache-kafka-migration.yml)|Highly scalable fault-tolerant distributed messaging system|[Choosing landing targets for Apache Kafka on Azure](images/flowchart-kafka-azure-landing-targets.png)|Kafka on a VM, Event Hubs for Kafka, Kafka on HDInsight|
|[Apache Atlas](https://github.com/Azure/Hadoop-Migrations/tree/main/docs/atlas)|Open source framework for data governance and metadata management||Azure Purview|

## Migration approaches

The following diagram shows three approaches to migrating Hadoop applications:

:::image type="content" source="images/target-state.png" alt-text="Diagram that shows three ways to migrate Hadoop applications." lightbox="images/target-state.png" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/US-1952879-overview-diagrams.vsdx) of this architecture.*

The approaches are:

- **Replatform by using Azure PaaS:** For more information, see [Modernize by using Azure Synapse Analytics and Databricks](#modernize-by-using-azure-synapse-analytics-and-databricks).
- **Lift and shift to HDInsight:** For more information, see [Lift and shift to HDInsight](#lift-and-shift-to-hdinsight).
- **Lift and shift to IaaS:** For more information, see [Lift and shift to Azure infrastructure as a service (IaaS)](#lift-and-shift-to-azure-infrastructure-as-a-service-iaas).

### Modernize by using Azure Synapse Analytics and Databricks

The following diagram shows this approach:

:::image type="content" source="images/end-state-architecture-modernize.png" alt-text="Diagram of an architecture to modernize by using Azure Synapse Analytics and Databricks." lightbox="images/end-state-architecture-modernize.png" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/US-1952879-overview-diagrams.vsdx) of this architecture.*

### Lift and shift to HDInsight

The following diagram shows this approach:

:::image type="content" source="images/hdinsight-end-state.png" alt-text="Diagram of an architecture to modernize by doing a lift and shift to HDInsight." lightbox="images/hdinsight-end-state.png" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/US-1952879-overview-diagrams.vsdx) of this architecture.*

For more information, see [Guide to migrating Big
Data workloads to Azure HDInsight](https://azure.microsoft.com/resources/migrating-big-data-workloads-hdinsight). That article provides a link for downloading a migration guide and also provides an email address that you can use to ask questions or make suggestions.

### Lift and shift to Azure infrastructure as a service (IaaS)

The following pattern presents a point of view on how to deploy OSS on Azure IaaS with a tight integration back to on-premises systems such as Active Directory, Domain Controller, and DNS. The deployment follows enterprise-scale landing zone guidance from Microsoft. Management capabilities such as monitoring, security, governance, and networking are hosted within a management subscription. The workloads, all IaaS-based, are hosted in a separate subscription. For more information about enterprise-scale landing zones, see [What is an Azure landing zone?](/azure/cloud-adoption-framework/ready/enterprise-scale/architecture#landing-zone-in-enterprise-scale).

:::image type="content" source="images/azure-iaas-target-state.png" alt-text="Diagram of architecture to lift and shift to Azure IaaS." lightbox="images/azure-iaas-target-state.png" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/US-1952879-overview-diagrams.vsdx) of this architecture.*

1. On-premises Active Directory synchronizes with Azure AD by using Azure AD Connect hosted on-premises.
1. Azure ExpressRoute provides secure and private network connectivity between on-premises and Azure.
1. The management (or hub) subscription provides networking and management capabilities for the deployment. This pattern is in line with enterprise-scale landing zone guidance from Microsoft.
1. The services hosted inside the hub subscription provide network connectivity and management capabilities.
   - **NTP (hosted on Azure VM)** is required to keep the clocks synchronized across all virtual machines. When you run multiple applications, such as HBase and ZooKeeper, you should run a Network Time Protocol (NTP) service or another time-synchronization mechanism on your cluster. All nodes should use the same service for time synchronization. For instructions on setting up NTP on Linux, see [14.6. Basic NTP configuration](https://tldp.org/LDP/sag/html/basic-ntp-config.html).
   - **[Azure Network Watcher](/azure/network-watcher/network-watcher-monitoring-overview)** provides tools to monitor, diagnose, and manage resources in an Azure virtual network. Network Watcher is designed to monitor and repair the network health of IaaS products, including VMs, virtual networks, application gateways, and load balancers.
   - **[Azure Advisor](/azure/advisor/advisor-overview)** analyzes your resource configuration and usage telemetry and then recommends solutions to improve the cost effectiveness, performance, reliability, and security of your Azure resources.
   - **[Azure Monitor](/azure/azure-monitor/overview)** provides a comprehensive solution for collecting, analyzing, and acting on telemetry from your cloud and on-premises environments. It helps you understand how your applications are performing so that you can proactively identify issues that affect the applications and the resources they depend on.
   - **[Log Analytics Workspace](/azure/azure-monitor/logs/quick-create-workspace)** is a unique environment for Azure Monitor log data. Each workspace has its own data repository and configuration. Data sources and solutions are configured to store their data in a particular workspace. You need a Log Analytics workspace if you intend to collect data from the following sources:
     - Azure resources in your subscription
     - On-premises computers that are monitored by System Center Operations Manager
     - Device collections from System Center Configuration Manager
     - Diagnostics or log data from Azure Storage
   - **[Azure DevOps Self-Hosted Agent](/azure/devops/pipelines/agents/v2-linux)** hosted on Azure virtual Machine Scale Sets gives you flexibility over the size and the image of machines on which agents run. You specify a virtual machine scale set, a number of agents to keep on standby, a maximum number of virtual machines in the scale set. Azure Pipelines manages the scaling of your agents for you.
1. The **[Azure AD](/azure/active-directory/fundamentals/active-directory-whatis)** tenant is synchronized with the on-premises Active Directory via Azure AD Connect synchronization services. For more information, see [Azure AD Connect sync: Understand and customize synchronization](/azure/active-directory/hybrid/how-to-connect-sync-whatis).
1. **[Azure Active Directory Domain Services (Azure AD DS)](/azure/active-directory-domain-services/synchronization)** provides LDAP and Kerberos capabilities on Azure. When you first deploy Azure AD DS, an automatic one-way synchronization is configured and started in order to replicate the objects from Azure AD. This one-way synchronization continues to run in the background to keep the Azure AD DS managed domain up-to-date with any changes from Azure AD. No synchronization occurs from Azure AD DS back to Azure AD.
1. Services such as **[Azure DNS](/azure/dns/private-dns-overview)**, **[Microsoft Defender for Cloud](/azure/security-center/security-center-introduction)**, and **[Azure Key Vault](/azure/key-vault/general/basic-concepts)** sit inside the management subscription and provide service/IP address resolution, unified infrastructure security management, and certificate and key management capabilities, respectively.
1. **[Virtual Network Peering](/azure/virtual-network/virtual-network-peering-overview)** provides connectivity between virtual networks deployed in two subscriptions: management (hub) and workload (spoke).
1. In line with enterprise-scale landing zones, workload subscriptions are used for hosting application workloads.
1. **[Azure Data Lake Storage](/azure/storage/blobs/data-lake-storage-introduction)** is a set of capabilities that are built on Azure Blob Storage to do big data analytics. In the context of big data workloads, Data Lake Storage can be used as secondary storage for Hadoop. Data written to Data Lake Storage can be consumed by other Azure services that are outside of the Hadoop framework.
1. **Big data workloads** are hosted on a set of independent Azure virtual machines. Refer to guidance for [HDFS](apache-hdfs-migration.yml), [HBase](apache-hbase-migration.yml), [Hive](https://github.com/Azure/Hadoop-Migrations/blob/main/docs/hive/migration-approach.md), [Ranger](https://github.com/Azure/Hadoop-Migrations/blob/main/docs/ranger/migration-approach.md), and [Spark](https://github.com/Azure/Hadoop-Migrations/blob/main/docs/spark/migration-approach.md) on Azure IaaS for more information.
1. **[Azure DevOps](/azure/devops/user-guide/alm-devops-features)** is a software as a service (SaaS) offering that provides an integrated set of services and tools to manage your software projects, from planning and development through testing and deployment.

## End state reference architecture

One of the challenges of migrating workloads from on-premises Hadoop to Azure is deploying to achieve the desired end state architecture and application. The project that's described in [Hadoop Migration on Azure PaaS](https://github.com/Azure/Hadoop-Migrations/tree/main/bicep) is intended to reduce the significant effort that's usually needed to deploy the PaaS services and the application.

In that project, we look at the end state architecture for big data workloads on Azure and list the components that are used in a Bicep template deployment. With Bicep we deploy only the modules that we need to deploy architecture. We cover the prerequisites for the template and the various methods of deploying the resources on Azure, such as One-click, Azure CLI, GitHub Actions, and Azure DevOps Pipeline.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Namrata Maheshwary](https://www.linkedin.com/in/namrata0104) | Senior Cloud Solution Architect
- [Raja N](https://www.linkedin.com/in/nraja) | Director, Customer Success
- [Hideo Takagi](https://www.linkedin.com/in/hideo-takagi) | Cloud Solution Architect
- [Ram Yerrabotu](https://www.linkedin.com/in/ram-reddy-yerrabotu-60044620) | Senior Cloud Solution Architect

Other contributors:

- [Ram Baskaran](https://www.linkedin.com/in/ram-baskaran) | Senior Cloud Solution Architect
- [Jason Bouska](https://www.linkedin.com/in/jasonbouska) | Senior Software Engineer
- [Eugene Chung](https://www.linkedin.com/in/eugenesc) | Senior Cloud Solution Architect
- [Pawan Hosatti](https://www.linkedin.com/in/pawanhosatti) | Senior Cloud Solution Architect - Engineering
- [Daman Kaur](https://www.linkedin.com/in/damankaur-architect) | Cloud Solution Architect
- [Danny Liu](https://www.linkedin.com/in/geng-liu) | Senior Cloud Solution Architect - Engineering
- [Jose Mendez](https://www.linkedin.com/in/jos%C3%A9-m%C3%A9ndez-de-la-serna-946985aa) Senior Cloud Solution Architect
- [Ben Sadeghi]( https://www.linkedin.com/in/bensadeghi) | Senior Specialist
- [Sunil Sattiraju](https://www.linkedin.com/in/sunilsattiraju) | Senior Cloud Solution Architect
- [Amanjeet Singh](https://www.linkedin.com/in/amanjeetsingh2004) | Principal Program Manager
- [Nagaraj Seeplapudur Venkatesan](https://www.linkedin.com/in/nagaraj-venkatesan-b6958b6) | Senior Cloud Solution Architect - Engineering

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

### Azure product introductions

- [Introduction to Azure Data Lake Storage Gen2](/azure/storage/blobs/data-lake-storage-introduction)
- [What is Apache Spark in Azure HDInsight](/azure/hdinsight/spark/apache-spark-overview)
- [What is Apache Hadoop in Azure HDInsight?](/azure/hdinsight/hadoop/apache-hadoop-introduction)
- [What is Apache HBase in Azure HDInsight](/azure/hdinsight/hbase/apache-hbase-overview)
- [What is Apache Kafka in Azure HDInsight](/azure/hdinsight/kafka/apache-kafka-introduction)

### Azure product reference

- [Azure Active Directory documentation](/azure/active-directory)
- [Azure Cosmos DB documentation](/azure/cosmos-db)
- [Azure Data Factory documentation](/azure/data-factory)
- [Azure Databricks documentation](/azure/databricks)
- [Azure Event Hubs documentation](/azure/event-hubs)
- [Azure Functions documentation](/azure/azure-functions)
- [Azure HDInsight documentation](/azure/hdinsight)
- [Microsoft Purview data governance documentation](/azure/purview)
- [Azure Stream Analytics documentation](/azure/stream-analytics)
- [Azure Synapse Analytics](/azure/synapse-analytics)

### Other

- [Enterprise Security Package for Azure HDInsight](/azure/hdinsight/enterprise-security-package)
- [Develop Java MapReduce programs for Apache Hadoop on HDInsight](/azure/hdinsight/hadoop/apache-hadoop-develop-deploy-java-mapreduce-linux)
- [Use Apache Sqoop with Hadoop in HDInsight](/azure/hdinsight/hadoop/hdinsight-use-sqoop)
- [Overview of Apache Spark Streaming](/azure/hdinsight/spark/apache-spark-streaming-overview)
- [Structured Streaming tutorial](/azure/databricks/getting-started/spark/streaming)
- [Use Azure Event Hubs from Apache Kafka applications](/azure/event-hubs/event-hubs-for-kafka-ecosystem-overview)

## Related resources

- [Apache HDFS migration to Azure](apache-hdfs-migration.yml)
- [Apache HBase migration to Azure](apache-hbase-migration.yml)
- [Apache Kafka migration to Azure](apache-kafka-migration.yml)
- [Apache Sqoop migration to Azure](apache-sqoop-migration.yml)

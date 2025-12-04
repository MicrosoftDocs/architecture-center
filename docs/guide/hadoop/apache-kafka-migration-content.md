
[Apache Kafka](https://kafka.apache.org) is a highly scalable and fault tolerant distributed messaging system that implements a publish-subscribe architecture. It's used as an ingestion layer in real-time streaming scenarios, such as Internet of Things and real-time log monitoring systems. It's also used increasingly as the immutable append-only data store in Kappa architectures.

*[Apache](https://www.apache.org)®, [Apache Spark®](https://spark.apache.org), [Apache Hadoop®](https://hadoop.apache.org), [Apache HBase](https://hbase.apache.org), [Apache Storm®](https://storm.apache.org), [Apache Sqoop®](https://sqoop.apache.org), [Apache Kafka®](https://kafka.apache.org), and the flame logo are either registered trademarks or trademarks of the Apache Software Foundation in the United States and/or other countries. No endorsement by The Apache Software Foundation is implied by the use of these marks.*

## Migration approach

This article presents various strategies for migrating Kafka to Azure:

- [Migrate Kafka to Azure infrastructure as a service (IaaS)](#migrate-kafka-to-azure-iaas)
- [Migrate Kafka to Azure Event Hubs for Kafka](#migrate-kafka-to-event-hubs-for-kafka)
- [Migrate Kafka on Azure HDInsight](#migrate-kafka-on-hdinsight)
- [Use Azure Kubernetes Service (AKS) with Kafka on HDInsight](#use-aks-with-kafka-on-hdinsight)
- [Use Kafka on AKS with the Strimzi Operator](#use-kafka-on-aks-with-the-strimzi-operator)

Here's a decision flowchart for deciding which strategy to use.

![Diagram that shows a decision chart for determining a strategy for migrating Kafka to Azure.](images/flowchart-kafka-azure-landing-targets.png)

### Migrate Kafka to Azure IaaS

For one way to migrate Kafka to Azure IaaS, see [Kafka on Ubuntu virtual machines](https://github.com/Azure/azure-quickstart-templates/tree/master/application-workloads/kafka/kafka-ubuntu-multidisks).

### Migrate Kafka to Event Hubs for Kafka

Event Hubs provides an endpoint that's compatible with the Apache Kafka producer and consumer APIs. Most Apache Kafka client applications can use this endpoint, so you can use it as an alternative to running a Kafka cluster on Azure. The endpoint supports clients that use API versions 1.0 and later. For more information about this feature, see [Event Hubs for Apache Kafka overview](/azure/event-hubs/azure-event-hubs-kafka-overview).

To learn how to migrate your Apache Kafka applications to use Event Hubs, see [Migrate to Event Hubs for Apache Kafka ecosystems](/azure/event-hubs/apache-kafka-migration-guide).

#### Features of Kafka and Event Hubs

| Similarities between Kafka and Event Hubs | Differences in Kafka and Event Hubs |
| :------------------------------------ | :----------------- |
| Use partitions                   | Platform as a service versus software |
| Partitions are independent       | Partitioning       |
| Use a client-side cursor concept | APIs              |
| Can handle very high workloads | Runtime           |
| Nearly identical conceptually | Protocols        |
| Neither uses the HTTP protocol for receiving | Durability |
|                                         | Security         |
|                                         | Throttling       |

##### Partitioning differences

| Kafka | Event Hubs |
| :----------| :----------|
| Partition count manages scale. | Throughput units manage scale. |
| You must load balance partitions across machines. | Load balancing is automatic. |
| You must manually reshard by using split and merge. | Repartitioning isn't required. |

##### Durability differences

| Kafka | Event Hubs |
| :------------| :---------------|
| Volatile by default | Always durable |
| Replicated after an acknowledgment (ACK) is received | Replicated before an ACK is sent |
| Depends on disk and quorum | Provided by storage |

##### Security differences

| Kafka | Event Hubs |
| :------------------| :----------------|
| Secure Sockets Layer (SSL) and Simple Authentication and Security Layer (SASL) | Shared Access Signature (SAS) and SASL or PLAIN RFC 4618 |
| File-like access control lists | Policy |
| Optional transport encryption | Mandatory Transport Layer Security (TLS) |
| User based | Token based (unlimited) |

##### Other differences

| Kafka | Event Hubs |
| :----------------| :-----------------|
| Doesn't throttle | Supports throttling |
| Uses a proprietary protocol | Uses AMQP 1.0 protocol |
| Doesn't use HTTP for send | Uses HTTP send and batch send |

### Migrate Kafka on HDInsight

You can migrate Kafka to Kafka on HDInsight. For more information, see [What is Apache Kafka in HDInsight?](/azure/hdinsight/kafka/apache-kafka-introduction).

### Use AKS with Kafka on HDInsight

For more information, see [Use AKS with Apache Kafka on HDInsight](https://docs.azure.cn/hdinsight/kafka/apache-kafka-azure-container-services).

### Use Kafka on AKS with the Strimzi Operator

For more information, see [Deploy a Kafka cluster on AKS by using Strimzi](/azure/aks/kafka-overview).

#### Kafka data migration

You can use Kafka's [MirrorMaker tool](/azure/hdinsight/kafka/apache-kafka-mirroring) to replicate topics from one cluster to another. This technique can help you migrate data after a Kafka cluster is provisioned. For more information, see [Use MirrorMaker to replicate Apache Kafka topics with Kafka on HDInsight](/azure/hdinsight/kafka/apache-kafka-mirroring).

The following migration approach uses mirroring:

1. Move producers first. When you migrate the producers, you prevent production of new messages on the source Kafka.

1. After the source Kafka consumes all remaining messages, you can migrate the consumers.

The implementation includes the following steps:

1. Change the Kafka connection address of the producer client to point to the new Kafka instance.

1. Restart the producer business services and send new messages to the new Kafka instance.

1. Wait for the data in the source Kafka to be consumed.

1. Change the Kafka connection address of the consumer client to point to the new Kafka instance.

1. Restart the consumer business services to consume messages from the new Kafka instance.

1. Verify that consumers succeed in getting data from the new Kafka instance.

### Monitor the Kafka cluster

You can use Azure Monitor logs to analyze logs that Apache Kafka on HDInsight generates. For more information, see [Analyze logs for Apache Kafka on HDInsight](/azure/hdinsight/kafka/apache-kafka-log-analytics-operations-management).

### Apache Kafka Streams API

The Kafka Streams API makes it possible to process data in near real-time and to join and aggregate data. For more information, see [Introducing Kafka Streams: Stream Processing Made Simple - Confluent](https://www.confluent.io/blog/introducing-kafka-streams-stream-processing-made-simple).

### The Microsoft and Confluent partnership

Confluent provides a cloud-native service for Apache Kafka. Microsoft and Confluent have a strategic alliance. For more information, see the following resources:

- [Confluent and Microsoft announce strategic alliance](https://azure.microsoft.com/blog/introducing-seamless-integration-between-microsoft-azure-and-confluent-cloud/)
- [Introducing seamless integration between Microsoft Azure and Confluent Cloud](https://azure.microsoft.com/blog/introducing-seamless-integration-between-microsoft-azure-and-confluent-cloud)

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal authors:

- [Namrata Maheshwary](https://www.linkedin.com/in/namrata0104) | Senior Cloud Solution Architect
- [Raja N](https://www.linkedin.com/in/nraja) | Director, Customer Success
- [Hideo Takagi](https://www.linkedin.com/in/hideo-takagi) | Cloud Solution Architect
- [Ram Yerrabotu](https://www.linkedin.com/in/ram-reddy-yerrabotu-60044620) | Senior Cloud Solution Architect

Other contributors:

- [Ram Baskaran](https://www.linkedin.com/in/ram-baskaran) | Senior Cloud Solution Architect
- [Jason Bouska](https://www.linkedin.com/in/jasonbouska/) | Senior Software Engineer - Azure Patterns & Practices
- [Eugene Chung](https://www.linkedin.com/in/eugenesc) | Senior Cloud Solution Architect
- [Pawan Hosatti](https://www.linkedin.com/in/pawanhosatti) | Senior Cloud Solution Architect - Engineering
- [Daman Kaur](https://www.linkedin.com/in/damkaur) | Cloud Solution Architect
- [Danny Liu](https://www.linkedin.com/in/geng-liu) | Senior Cloud Solution Architect - Engineering
- [Jose Mendez](https://www.linkedin.com/in/jos%C3%A9-m%C3%A9ndez-de-la-serna-946985aa) Senior Cloud Solution Architect
- [Ben Sadeghi](https://www.linkedin.com/in/bensadeghi) | Senior Specialist
- [Sunil Sattiraju](https://www.linkedin.com/in/sunilsattiraju) | Senior Cloud Solution Architect
- [Amanjeet Singh](https://www.linkedin.com/in/amanjeetsingh2004) | Principal Program Manager
- [Nagaraj Seeplapudur Venkatesan](https://www.linkedin.com/in/nagaraj-venkatesan-b6958b6) | Senior Cloud Solution Architect - Engineering

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

### Azure product introductions

- [Introduction to Azure Data Lake Storage](/azure/storage/blobs/data-lake-storage-introduction)
- [What is Apache Spark in HDInsight?](/azure/hdinsight/spark/apache-spark-overview)
- [What is Apache Hadoop in HDInsight?](/azure/hdinsight/hadoop/apache-hadoop-introduction)
- [What is Apache HBase in HDInsight?](/azure/hdinsight/hbase/apache-hbase-overview)
- [What is Apache Kafka in HDInsight?](/azure/hdinsight/kafka/apache-kafka-introduction)
- [Overview of enterprise security in HDInsight](/azure/hdinsight/domain-joined/hdinsight-security-overview)

### Azure product reference

- [Microsoft Entra documentation](/entra)
- [Azure Cosmos DB documentation](/azure/cosmos-db)
- [Azure Data Factory documentation](/azure/data-factory)
- [Azure Databricks documentation](/azure/databricks)
- [Event Hubs documentation](/azure/event-hubs)
- [Azure Functions documentation](/azure/azure-functions)
- [HDInsight documentation](/azure/hdinsight)
- [Microsoft Purview data governance documentation](/azure/purview)
- [Azure Stream Analytics documentation](/azure/stream-analytics)

### Other

- [Enterprise Security package for HDInsight](/azure/hdinsight/enterprise-security-package)
- [Develop Java MapReduce programs for Apache Hadoop on HDInsight](/azure/hdinsight/hadoop/apache-hadoop-develop-deploy-java-mapreduce-linux)
- [Use Apache Sqoop with Hadoop in HDInsight](/azure/hdinsight/hadoop/hdinsight-use-sqoop)
- [Overview of Apache Spark Streaming](/azure/hdinsight/spark/apache-spark-streaming-overview)
- [Structured Streaming tutorial](/azure/databricks/getting-started/spark/streaming)
- [Use Event Hubs from Apache Kafka applications](/azure/event-hubs/event-hubs-for-kafka-ecosystem-overview)

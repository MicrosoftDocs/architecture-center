---
title: Kafka on Azure
titleSuffix: Azure solution ideas
description: Learn about solutions for implementing Apache Kafka on Azure, including a comparison of the features for each solution. 
author: rasavant-ms
ms.date: 10/16/2020
ms.service: architecture-center
ms.subservice: solution-idea
ms.custom:
- fcp
---

# Kafka on Azure

[Apache Kafka](https://kafka.apache.org/intro) is an open-source distributed event streaming platform with the capability to publish, subscribe,
store, and process streams of events in a distributed and highly scalable manner. Kafka is deployed on hardware, virtual machines, containers,
and on-premises as well as in the cloud.

You can take advantage of Azure cloud capacity, cost, and flexibility by implementing Kafka on Azure.

This article presents options for implementing Kafka on Azure, evaluates their pros and cons, provides a feature comparison, and offers a decision guidance matrix to help you select between the options.

## Architecture

The following diagram shows what a typical [Lambda architecture](https://wikipedia.org/wiki/Lambda_architecture) looks like with different Kafka on Azure options for the ingestion phase and an exhaustive list of services from the Azure ecosystem supporting them.

![Diagram of a typical Lambda architecture showing options for implementing Apache Kafka on Azure.](../media/kafka-on-azure-architecture-diagram.png)

## Kafka on Azure options

To evaluate the options for Kafka on Azure, place them on a continuum between Infrastructure-as-a-Service (IaaS) and Platform-as-a-Service (PaaS).

To evaluate the options, use a PaaS-first approach. First, consider whether your design requirements are met using the PaaS offering, and if you come across a limitation, move on to the next offering in the list.

The following diagram summarizes Kafka on Azure options using the IaaS-PaaS continuum.

![Diagram showing the steps in a PaaS first approach with Kafka on Azure.](../media/kafka-on-azure-paas-first-approach.png)

The following sections present pros and cons for each Kafka on Azure option.

### Confluent Cloud PaaS solution

Confluent provides a fully managed Apache Kafka on Azure. The [Confluent Cloud](https://www.confluent.io/confluent-cloud/) implementation of Kafka abstracts the user from all the deployment, implementation, and management details while providing a pure service. For more detailed information, see [Supported features for Confluent Cloud](https://docs.confluent.io/current/cloud/features.html).

Here are some of the advantages and limitations of using the Confluent Cloud solution:

Pros

- The managed PaaS offering ensures easy usage with support.
- Offers a rich feature set through the Confluent ecosystem.
- The ability to purchase through the Azure Marketplace instead of entering a billing arrangement with a third party.

Cons

- Available in a limited set of Azure regions.
- Missing geo-replication.
- Limited network peering options available.
- Tied in with Confluent licensing agreements.
- Requires Enterprise pricing for an extensive feature set at additional cost.
- Kafka version support and compatibility will always lag behind the published version.

### Azure Event Hubs with Kafka PaaS solution

[Azure Event Hubs](/azure/event-hubs/event-hubs-for-kafka-ecosystem-overview) provides a fully managed, cloud-native service that doesn't require you to configure servers, disks, or networks. Azure Event Hubs is compatible with Apache Kafka client applications that use producer and consumer APIs for Apache Kafka. This means that you can use Azure Event Hubs like Apache Kafka topics and can send and receive messages by applying minor changes to the client configuration.

Azure Event Hubs includes features such as:

- The ability to publish and consume events using HTTPS, AMQP 1.0, or Kafka 1.0+.
- The Event Hubs Capture feature that saves streaming data into a Blob storage account or Azure Data Lake Service account.
- Clients using Event Hub SDKs act as intelligent consumer agents to simplify checkpointing, leasing, and managing readers.

Here are some of the advantages and limitations of using the Azure Event Hubs solution:

Pros

- Fully managed cloud-native service with ease of deployment, management, and monitoring.
- Opens up the ability to integrate with different Azure services like:

  - [Azure Stream Analytics](/azure/stream-analytics/stream-analytics-introduction)
  - [Azure Synapse Analytics](/azure/event-grid/event-grid-event-hubs-integration)
  - [Azure Cosmos DB](/azure/cosmos-db/introduction)
  - [Azure Data Lake Storage](/azure/data-lake-store/data-lake-store-overview)
  - [Azure Machine Learning](/azure/machine-learning/overview-what-is-azure-ml)
  - [Azure Functions](/azure/azure-functions/functions-overview)
  - [Azure Databricks](/azure/databricks/scenarios/what-is-azure-databricks)

- Integrated [geo-disaster recovery and geo-replication](/azure/event-hubs/event-hubs-geo-dr) is not available in most other offerings.
- Available across Azure regions.

Cons

- Feature parity with Apache Kafka. Native Kafka features like Transactions, Compression, Log Compaction, Kafka Streams, Kafka Connect (currently in Preview) aren't available in production.
- Schema Registry, which is one of the most sought after offerings from Confluent, is in Public Preview.
- [Quotas and limits](/azure/event-hubs/event-hubs-quotas) for Azure Event Hubs are restrictive.
- The single tenant Dedicated Tier offering of Event Hubs with more quota and relaxed limits comes at a [higher price](https://azure.microsoft.com/pricing/details/event-hubs/).

### Apache Kafka on HDInsight managed cluster

[Kafka on HDInsight](/azure/hdinsight/kafka/apache-kafka-introduction) is a managed platform that provides a simplified configuration process that is tested and supported by Microsoft. HDInsight uses native Kafka APIs, which means that you don't need to change client application code to use this solution.

Kafka on HDInsight includes features such as:

- Azure Managed Disks as the backing store for Kafka, providing up to 16 TB of storage per Kafka broker.
- Rebalancing of Kafka partitions and replicas across update domains and fault domains.
- You can easily change the number of worker nodes which host the Kafka broker after cluster creation.
- Virtual Machine (VM)-level monitoring with disk and NIC metrics, and JMX metrics from Kafka is possible with Azure Monitoring.
- Extended throughput options at the cost of increased complexity and management.

Here are some of the advantages and limitations of using Apache Kafka on HDInsight:

Pros

- Managed cluster offering that is customizable.
- No license requirements, unless going for Confluent features
- Complete Kafka feature set and APIs are available.
- [High availability](/azure/hdinsight/kafka/apache-kafka-high-availability) ensures the configuration of fault domains and update domains and [multi-region support](/azure/hdinsight/kafka/apache-kafka-mirroring) for replication.
- Data retention is more configurable than the managed services mentioned above.

Cons

- Kafka version support and compatibility always lag behind the published version.
- Upgrading a cluster requires workload migration.
- Disks can't be added to an existing cluster. To add more disk space, more cluster nodes must be added.
- No public endpoint available, which makes virtual network integration mandatory and requires advanced networking configurations.

### Confluent Platform on Azure Marketplace IaaS solution

[Confluent Platform](https://azuremarketplace.microsoft.com/marketplace/apps/confluentinc.confluent-enterprise) is available as a bring-your-own-license offering in Azure Marketplace. It includes all components from the Apache Kafka Core along with some Apache-licensed open-source additions like client tools, pre-built connectors, and cluster-side services such as Schema Registry and REST Proxy.

Here are some of the advantages and limitations of using Confluent Platform on Azure Marketplace:

Pros

- Automated cluster provisioning, management, and elastic scaling.
- Complete support for all Confluent Platform components like Kafka Connect Workers, Kafka Streams Apps, Schema Registry, REST Proxy, and Control Center.

Cons

- The deployment available on Azure Marketplace is designed only for Development and Proof of concept (POC) environments. Production deployment must be processed via email exchanges with [azureteam@confluent.io](mailto:azureteam@confluent.io).
- Kafka version support and compatibility always lag behind the published version.
- Deployment inside virtual network requires peering to work with clients requiring advanced network configurations.
- Bring Your Own License agreement.

### Kafka on Azure Kubernetes Service IaaS solution

[Azure Kubernetes Service (AKS)](/azure/aks/intro-kubernetes) reduces the complexity and overhead of managing Kubernetes by offloading much of that responsibility to Azure. Apache Kafka clusters are deployed on AKS in various configurations using the best practices of Kubernetes operators like [Strimzi](https://strimzi.io/documentation/) or [Confluent Kafka Operator](https://docs.confluent.io/current/installation/operator/index.html).

Here are some of the advantages and limitations of using Kafka on AKS:

Pros

- Uses standard Kubernetes deployment mechanisms, which are cloud agnostic.
- Provides the complete Kafka feature set and APIs.
- Supports additional features.

Cons

- High availability and disaster recovery must be planned and configured manually.
- A custom configuration to achieve the desired scale and throughput with an apt number of resources requires much work.
- Upgrades could be disruptive.
- Lack of documentation and support for implementation in production.

### Kafka on Azure VMs IaaS solution

The Apache Kafka software can be deployed on a group of Azure VMs to represent a Kafka cluster. The configuration of the cluster is completely up to the user, but there are some [recommended approaches](https://docs.confluent.io/2.0.1/kafka/deployment.html).

Here are some of the advantages and limitations of using Kafka on Azure Virtual Machines:

Pros

- Complete autonomy and control to configure and scale the Kafka cluster.
- Numerous options to extend the deployment.

Cons

- Selecting the right size of VMs is difficult.
- You must implement your own scaling logic. User configurations determine efficacy.
- Management and monitoring overhead.
- Achieving the best performance demands knowledge of the ins and outs of Azure networking and Apache Kafka.

## Considerations

The following section presents the considerations for each of the Kafka on Azure solutions.

### Feature comparison

The following table shows a comparison of features for each of the Kafka on Azure solutions this article discusses:

| Features | Confluent Cloud | Event Hubs + Kafka Head | HDInsight Kafka | Confluent Platform on Marketplace | Kafka on AKS | Azure VMs |
|:--------:|:---------------:|:-----------------------:|:---------------:|:-----------------------------------:|:------------:|:---------:|
|          | PaaS offering from external vendor | Fully managed PaaS offering that supports Kafka protocol | Managed Hortonworks cluster offering | Azure Marketplace offering | Open Source Apache Kafka implementation on your own compute platform | Open Source Apache Kafka implementation on your own compute platform |
| **Model** | PaaS (external vendor) | PaaS | Managed IaaS | IaaS |IaaS |IaaS |
| **Third-Party Licensing** | Purchase from Confluent	| Not needed | Not mandatory | Bring Your Own License (BYOL) | Not mandatory | Not mandatory |  
| **Compute Platform** | PaaS – Not applicable | PaaS – Not applicable | Managed disks and VMs | VMs | AKS cluster | VMs |  
| **Feature Set** | [See Features](https://docs.confluent.io/current/cloud/features.html) | [See Features](/azure/event-hubs/event-hubs-for-kafka-ecosystem-overview#apache-kafka-feature-differences) | Complete for available versions and extendable | Complete for available versions + Schema Registry, Connectors, KSQL | Complete and extendable	| Complete and extendable |  
| **Data retention** | 5 TB | Max 90 days, 10 TB included per control unit | Customizable | Customizable | Customizable | Customizable | 
| **Schema Registry** | Yes | Public Preview | Yes | Yes | Yes | Yes | 
| **Kafka Connectors API** | Yes | Preview | Yes | Yes | Yes | Yes | 
| **Azure Stack Options** | N/A | Preview | Not Available | Yes | Preview | Yes |  
| **Virtual network/Public deployment** | Virtual Private Cloud | Public endpoint always exposed | Virtual network availability in Preview | Virtual network deployment recommended | Virtual network deployment | Virtual network deployment available |
| **Configurable message retention beyond 7 days** | Yes | Yes | Yes | Yes | Yes | Yes |
| **Idempotency** | Yes | Yes | Yes | Yes | Yes | Yes |
| **Transaction** | Yes | In preview | Yes | Yes | Yes | Yes |
| **Kafka Streams** | Yes | In preview | Yes | Yes | Yes | Yes |
| **Integrated logging and monitoring** | Yes | Yes | Can be added | Yes | Can be added | Can be added |
| **Kafka version support** | Yes | 1.0+ | 2.1, 1.1, 1.0, 0.10.1, 0.9.0 | 2.2.0, 2.0.1 | Yes | Yes |
| **Java Client** | Yes | Yes | Yes | Yes | Yes | Yes |
| **.NET/Python/C++ Client** | Yes | Yes | Yes | Yes | Yes | Yes |
| **Declarative stream processing** | Yes | Can be added using another Azure service | Yes | Yes | Yes | Yes |
| **Log compaction** | Yes | In preview | Yes | Yes | Yes | Yes |
| **REST Proxy** | Yes | Yes | Yes | Yes | Yes | Yes |
| **Geo-replication** | Must be configured | Integrated | Integrated | Must be configured | Must be configured | Must be configured |
| **Authentication** | Secure Sockets Layer (SSL) or Simple Authentication and Security Layer (SSAL) | SSL, SASL Plain | SSL | SSL or SASL | SSL or SASL | SSL or SASL |
| **Authorization** | Access Control List (ACL) based |	Role-based Access Control (RBAC) | RBAC in Preview | ACL based |	ACL based |	ACL based |
| **Encryption** | SSL/TLS | SSL, Bring Your Own Key (BYOK) in Preview | SSE/TLS, Customer-managed disk encryption | SSL/TLS | SSL/TLS | SSL/TLS |
| **Automatic data balancer** | N/A - PaaS | N/A - PaaS | Yes | Configure Self-Balancing feature | User must configure | User must configure |
| **Monitoring metrics** | Yes | Yes | Can be added | Yes | Can be added | Can be added |
| **Monitoring tools** | Confluent Control Center | Azure Monitoring | Azure Monitoring and open-source tools | Confluent Control Center | Azure Monitoring and open-source tools | Can be added |
| **Managed service** | Yes | Yes | Managed clusters | Managed deployment | No – IaaS | No - IaaS |
| **Non-disruptive upgrades** | Yes | Yes | No | No | No | No |
| **Data replication** | Confluent Replicator | MirrorMaker or similar | Managed disk export / MirrorMaker  or similar | Confluent Replicator | MirrorMaker or similar | MirrorMaker or similar |

### Kafka on Azure decision guidance matrix

The decision guidance matrix uses the following key:

| Symbol                                                 | Feature Support      |
|--------------------------------------------------------|--------------------|
|:::image type="icon" source="../media/empty-star.png" alt-text="Not supported natively or not applicable.":::| Not supported natively or not applicable
|:::image type="icon" source="../media/half-star.png" alt-text="Support with limitations or via extensions or via custom code."::: | Support with limitations or via extensions or via custom code
|:::image type="icon" source="../media/full-star.png" alt-text="Full native support."::: | Full native support

| Feature | Confluent Cloud | Event Hubs + Kafka Head | HDInsight Kafka | Confluent Platform on Marketplace | Kafka on AKS | Azure VMs |
|------------------------------------|:--------------------:|:--------------------:|:--------------------:|:--------------------:|:--------------------:|:--------------------:|
| Ease of configuration/deployment   | :::image type="icon" source="../media/full-star.png" alt-text="Full native support."::: | :::image type="icon" source="../media/full-star.png" alt-text="Full native support."::: | :::image type="icon" source="../media/half-star.png" alt-text="Support with limitations or via extensions or via custom code."::: | :::image type="icon" source="../media/half-star.png" alt-text="Support with limitations or via extensions or via custom code."::: | :::image type="icon" source="../media/empty-star.png" alt-text="Not supported natively or not applicable."::: | :::image type="icon" source="../media/empty-star.png" alt-text="Not supported natively or not applicable."::: | 
| Simplicity of maintenance          | :::image type="icon" source="../media/full-star.png" alt-text="Full native support."::: | :::image type="icon" source="../media/full-star.png" alt-text="Full native support."::: | :::image type="icon" source="../media/half-star.png" alt-text="Support with limitations or via extensions or via custom code."::: | :::image type="icon" source="../media/empty-star.png" alt-text="Not supported natively or not applicable."::: | :::image type="icon" source="../media/empty-star.png" alt-text="Not supported natively or not applicable."::: | :::image type="icon" source="../media/empty-star.png" alt-text="Not supported natively or not applicable."::: | 
| Kafka native support               | :::image type="icon" source="../media/full-star.png" alt-text="Full native support."::: | :::image type="icon" source="../media/half-star.png" alt-text="Support with limitations or via extensions or via custom code."::: | :::image type="icon" source="../media/full-star.png" alt-text="Full native support."::: | :::image type="icon" source="../media/full-star.png" alt-text="Full native support."::: | :::image type="icon" source="../media/full-star.png" alt-text="Full native support."::: | :::image type="icon" source="../media/full-star.png" alt-text="Full native support."::: |  
| Java, .NET, Python clients         | :::image type="icon" source="../media/full-star.png" alt-text="Full native support."::: | :::image type="icon" source="../media/full-star.png" alt-text="Full native support."::: | :::image type="icon" source="../media/full-star.png" alt-text="Full native support."::: | :::image type="icon" source="../media/full-star.png" alt-text="Full native support."::: | :::image type="icon" source="../media/full-star.png" alt-text="Full native support."::: | :::image type="icon" source="../media/full-star.png" alt-text="Full native support."::: |  
| 100% managed solution              | :::image type="icon" source="../media/full-star.png" alt-text="Full native support."::: | :::image type="icon" source="../media/full-star.png"  alt-text="Full native support."::: | :::image type="icon" source="../media/half-star.png" alt-text="Support with limitations or via extensions or via custom code."::: | :::image type="icon" source="../media/half-star.png" alt-text="Support with limitations or via extensions or via custom code."::: | :::image type="icon" source="../media/half-star.png" alt-text="Support with limitations or via extensions or via custom code."::: | :::image type="icon" source="../media/empty-star.png" alt-text="Not supported natively or not applicable."::: |
| Stream processing support          | :::image type="icon" source="../media/full-star.png" alt-text="Full native support."::: | :::image type="icon" source="../media/half-star.png" alt-text="Support with limitations or via extensions or via custom code."::: | :::image type="icon" source="../media/full-star.png" alt-text="Full native support."::: | :::image type="icon" source="../media/full-star.png" alt-text="Full native support."::: | :::image type="icon" source="../media/full-star.png" alt-text="Full native support."::: | :::image type="icon" source="../media/full-star.png" alt-text="Full native support."::: | 
| Portability to other clouds        | :::image type="icon" source="../media/half-star.png" alt-text="Support with limitations or via extensions or via custom code."::: | :::image type="icon" source="../media/empty-star.png" alt-text="Not supported natively or not applicable."::: | :::image type="icon" source="../media/half-star.png" alt-text="Support with limitations or via extensions or via custom code."::: | :::image type="icon" source="../media/empty-star.png" alt-text="Not supported natively or not applicable."::: | :::image type="icon" source="../media/full-star.png" alt-text="Full native support."::: | :::image type="icon" source="../media/full-star.png" alt-text="Full native support."::: |
| Failure recovery                   | :::image type="icon" source="../media/full-star.png" alt-text="Full native support."::: | :::image type="icon" source="../media/full-star.png" alt-text="Full native support."::: | :::image type="icon" source="../media/empty-star.png" alt-text="Not supported natively or not applicable."::: | :::image type="icon" source="../media/empty-star.png" alt-text="Not supported natively or not applicable."::: | :::image type="icon" source="../media/empty-star.png" alt-text="Not supported natively or not applicable."::: | :::image type="icon" source="../media/empty-star.png" alt-text="Not supported natively or not applicable."::: | 
| Meets low latency requirements     | :::image type="icon" source="../media/full-star.png" alt-text="Full native support."::: | :::image type="icon" source="../media/full-star.png" alt-text="Full native support."::: | :::image type="icon" source="../media/full-star.png" alt-text="Full native support."::: | :::image type="icon" source="../media/half-star.png" alt-text="Support with limitations or via extensions or via custom code."::: | :::image type="icon" source="../media/half-star.png" alt-text="Support with limitations or via extensions or via custom code."::: | :::image type="icon" source="../media/half-star.png" alt-text="Support with limitations or via extensions or via custom code."::: |
| Meets high throughput requirements | :::image type="icon" source="../media/full-star.png" alt-text="Full native support."::: | :::image type="icon" source="../media/full-star.png" alt-text="Full native support."::: | :::image type="icon" source="../media/full-star.png" alt-text="Full native support."::: | :::image type="icon" source="../media/half-star.png" alt-text="Support with limitations or via extensions or via custom code."::: | :::image type="icon" source="../media/half-star.png" alt-text="Support with limitations or via extensions or via custom code."::: | :::image type="icon" source="../media/half-star.png" alt-text="Support with limitations or via extensions or via custom code."::: | 
| Ecosystem support                  | :::image type="icon" source="../media/full-star.png" alt-text="Full native support."::: | :::image type="icon" source="../media/half-star.png" alt-text="Support with limitations or via extensions or via custom code."::: | :::image type="icon" source="../media/full-star.png" alt-text="Full native support."::: | :::image type="icon" source="../media/full-star.png" alt-text="Full native support."::: | :::image type="icon" source="../media/full-star.png" alt-text="Full native support."::: | :::image type="icon" source="../media/full-star.png" alt-text="Full native support."::: |
| Extensibility and flexibility      | :::image type="icon" source="../media/half-star.png" alt-text="Support with limitations or via extensions or via custom code."::: | :::image type="icon" source="../media/half-star.png" alt-text="Support with limitations or via extensions or via custom code."::: | :::image type="icon" source="../media/half-star.png"::: | :::image type="icon" source="../media/half-star.png" alt-text="Support with limitations or via extensions or via custom code."::: | :::image type="icon" source="../media/full-star.png" alt-text="Full native support."::: | :::image type="icon" source="../media/full-star.png" alt-text="Full native support."::: |
| Supportability                     | :::image type="icon" source="../media/full-star.png" alt-text="Full native support."::: | :::image type="icon" source="../media/full-star.png" alt-text="Full native support."::: | :::image type="icon" source="../media/full-star.png" alt-text="Full native support."::: | :::image type="icon" source="../media/full-star.png" alt-text="Full native support."::: | :::image type="icon" source="../media/half-star.png" alt-text="Support with limitations or via extensions or via custom code."::: | :::image type="icon" source="../media/half-star.png" alt-text="Support with limitations or via extensions or via custom code."::: | 
| Full feature parity                | :::image type="icon" source="../media/half-star.png" alt-text="Support with limitations or via extensions or via custom code."::: | :::image type="icon" source="../media/half-star.png" alt-text="Support with limitations or via extensions or via custom code."::: | :::image type="icon" source="../media/full-star.png" alt-text="Full native support."::: | :::image type="icon" source="../media/full-star.png" alt-text="Full native support."::: | :::image type="icon" source="../media/full-star.png" alt-text="Full native support."::: | :::image type="icon" source="../media/full-star.png" alt-text="Full native support."::: | 
| Geo-replication                    | :::image type="icon" source="../media/half-star.png" alt-text="Support with limitations or via extensions or via custom code."::: | :::image type="icon" source="../media/full-star.png" alt-text="Full native support."::: | :::image type="icon" source="../media/full-star.png" alt-text="Full native support."::: | :::image type="icon" source="../media/half-star.png" alt-text="Support with limitations or via extensions or via custom code."::: | :::image type="icon" source="../media/half-star.png" alt-text="Support with limitations or via extensions or via custom code."::: | :::image type="icon" source="../media/half-star.png" alt-text="Support with limitations or via extensions or via custom code."::: | 
| Data replication                   | :::image type="icon" source="../media/half-star.png" alt-text="Support with limitations or via extensions or via custom code."::: | :::image type="icon" source="../media/half-star.png" alt-text="Support with limitations or via extensions or via custom code."::: | :::image type="icon" source="../media/half-star.png" alt-text="Support with limitations or via extensions or via custom code."::: | :::image type="icon" source="../media/half-star.png" alt-text="Support with limitations or via extensions or via custom code."::: | :::image type="icon" source="../media/half-star.png" alt-text="Support with limitations or via extensions or via custom code."::: | :::image type="icon" source="../media/half-star.png" alt-text="Support with limitations or via extensions or via custom code."::: | 
| Kafka version support              | :::image type="icon" source="../media/half-star.png" alt-text="Support with limitations or via extensions or via custom code."::: | :::image type="icon" source="../media/half-star.png" alt-text="Support with limitations or via extensions or via custom code."::: | :::image type="icon" source="../media/half-star.png" alt-text="Support with limitations or via extensions or via custom code."::: | :::image type="icon" source="../media/half-star.png" alt-text="Support with limitations or via extensions or via custom code."::: | :::image type="icon" source="../media/full-star.png" alt-text="Full native support."::: | :::image type="icon" source="../media/full-star.png" alt-text="Full native support."::: | 
| Integrated logging and monitoring  | :::image type="icon" source="../media/full-star.png" alt-text="Full native support."::: | :::image type="icon" source="../media/full-star.png" alt-text="Full native support."::: | :::image type="icon" source="../media/full-star.png" alt-text="Full native support."::: | :::image type="icon" source="../media/full-star.png" alt-text="Full native support."::: | :::image type="icon" source="../media/half-star.png" alt-text="Support with limitations or via extensions or via custom code."::: | :::image type="icon" source="../media/half-star.png" alt-text="Support with limitations or via extensions or via custom code."::: | 
| Confluent schema registry          | :::image type="icon" source="../media/full-star.png" alt-text="Full native support."::: | :::image type="icon" source="../media/half-star.png" alt-text="Support with limitations or via extensions or via custom code."::: | :::image type="icon" source="../media/half-star.png" alt-text="Support with limitations or via extensions or via custom code."::: | :::image type="icon" source="../media/full-star.png" alt-text="Full native support."::: | :::image type="icon" source="../media/half-star.png" alt-text="Support with limitations or via extensions or via custom code."::: | :::image type="icon" source="../media/half-star.png" alt-text="Support with limitations or via extensions or via custom code."::: | 
| Configurable message retention     | :::image type="icon" source="../media/full-star.png" alt-text="Full native support."::: | :::image type="icon" source="../media/half-star.png" alt-text="Support with limitations or via extensions or via custom code."::: | :::image type="icon" source="../media/half-star.png" alt-text="Support with limitations or via extensions or via custom code."::: | :::image type="icon" source="../media/full-star.png" alt-text="Full native support."::: | :::image type="icon" source="../media/full-star.png" alt-text="Full native support."::: | :::image type="icon" source="../media/full-star.png" alt-text="Full native support."::: |
| Non-disruptive upgrades            | :::image type="icon" source="../media/full-star.png" alt-text="Full native support."::: | :::image type="icon" source="../media/full-star.png" alt-text="Full native support."::: | :::image type="icon" source="../media/half-star.png" alt-text="Support with limitations or via extensions or via custom code."::: | :::image type="icon" source="../media/empty-star.png" alt-text="Not supported natively or not applicable."::: | :::image type="icon" source="../media/empty-star.png" alt-text="Not supported natively or not applicable."::: | :::image type="icon" source="../media/empty-star.png" alt-text="Not supported natively or not applicable."::: | 

## Next steps

- [Azure Event Grid documentation](/azure/event-grid)
- [What is Apache Kafka in Azure HDInsight](/azure/hdinsight/kafka/apache-kafka-introduction)
- [Confluent Cloud](https://azuremarketplace.microsoft.com/marketplace/apps/confluentinc.confluent-cloud-kafka-service-azure)
- [Confluent Platform](https://azuremarketplace.microsoft.com/marketplace/apps/confluentinc.confluent-enterprise)

## Related resources

- [Partitioning in Event Hubs and Kafka](../../reference-architectures/event-hubs/partitioning-in-event-hubs-and-kafka.md)
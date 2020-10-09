---
title: Kafka on Azure
titleSuffix: Azure Solution Ideas
description: Learn the 
author: doodlemania2
ms.date: 09/29/2020
ms.service: architecture-center
ms.subservice: solution-idea
ms.custom:
- fcp
---

# Kafka on Azure

[Apache Kafka](https://kafka.apache.org/intro) is an open source distributed event streaming platform.
 
Customers that are already using Apache Kafka want to know ways to either deploy it on Azure Cloud or emulate the experience in Azure with minimal changes to their current setup. 

Customers are also interested in implementing solutions with Apache Kafka for Greenfield projects and want to leverage Azure.

The targeted audience for this document is Solution Architects looking to implement the scalable message ingestion platform, Apache Kafka on Azure. 


## Use cases

If you have already decided to use Apache Kafka and want to know what the options are for implementing it on Azure, this document outlines the right information for you.

- Deploy Apache Kafka on Azure Cloud or emulate the experience in Azure with minimal changes to your current setup.
- Implement solutions with Apache Kafka for Greenfield projects and leverage Azure.

## Architecture

Here is what a typical Lambda architecture would look like with different Kafka on Azure options for the ingestion phase and an exhaustive list of services from the Azure ecosystem supporting them.

![Typical Lambda Architecture with Kafka on Azure options.](../media/kafka-on-azure-architecture-diagram.png)

Let us look at the options for Kafka on Azure one by one. The following diagram summarizes these options using the Infrastructure as a service (IaaS)-Platform-as-a-service (PaaS) Continuum.

Ideally you would want to consider the PaaS-first approach. What this means is, you should consider whether your design requirements are met using the PaaS offering. If you come across a limitation, then move on to the next offering in this list.

![Diagram showing the steps in a PaaS first approach with Kafka on Azure.](../media/kafka-on-azure-paas-first-approach.png)

## Components

The example architecture uses the following components:

- [Azure ExpressRoute](https://azure.microsoft.com/services/expressroute/)
- [Azure VPN Gateway](https://azure.microsoft.com/services/vpn-gateway/)
- [Azure Active Directory Domain Services](https://azure.microsoft.com/services/active-directory-ds/)
- [Azure IoT Hub](https://azure.microsoft.com/services/iot-hub/)
- [Azure Key Vault](https://azure.microsoft.com/services/key-vault/)
- [Azure App Service](https://azure.microsoft.com/services/app-service/)
- [Cognitive services](https://azure.microsoft.com/services/cognitive-services/)
- [Azure Automation](https://azure.microsoft.com/services/automation/)

### Confluent Cloud - Platform-as-a-Service

In addition to the options in the preceding diagram, Confluent provides a fully managed Apache Kafka on Azure. This implementation of Kafka abstracts the user from all the deployment, implementation and management details while providing pure service.

Here is a link to the [Supported features for Confluent Cloud](https://docs.confluent.io/current/cloud/features.html).

Here are some advantages and drawbacks of using Solution X

Pros

- Managed PaaS offering ensures easy usage with support
- Rich feature set available through Confluent ecosystem

Cons

- Available in limited Azure regions
- Missing Geo-replication
- Network peering options are not available
- Tied in with Confluent licensing agreements
- Need to choose Enterprise pricing for an extensive feature set at additional cost
- Kafka version support and compatibility will always lag behind the published version

### Event Hubs with Kafka – Platform-as-a-Service

[Azure Event Hubs](https://docs.microsoft.com/azure/event-hubs/event-hubs-for-kafka-ecosystem-overview) provides a fully managed, cloud-native service where you do not have to configure servers, disks, or networks.

Azure Event Hubs is compatible with Apache Kafka client applications using producer and consumer APIs for Apache Kafka. This means that customers can use Azure Event Hubs like Apache Kafka topics and can send and receive messages by applying minor changes to the client configuration.

- Ability to publish events using HTTPS, AMQP 1.0 or Kafka 1.0+
- Event Hubs Capture feature to save streaming data into Blob storage account or Azure Data Lake Service account
- Ability to consume events using AMQP 1.0 or Kafka 1.0+
- Clients using Event Hub SDKs act as intelligent consumer agents simplifying checkpointing, leasing, and managing readers

Pros

- Fully managed cloud-native service with ease of deployment, management, and monitoring
- Opens up the ability to integrate with different Azure services like:

  - [Azure Stream Analytics](https://docs.microsoft.com/azure/stream-analytics/stream-analytics-introduction)
  - [Azure Synapse Analytics](https://docs.microsoft.com/azure/event-grid/event-grid-event-hubs-integration)
  - [Azure Cosmos DB](https://docs.microsoft.com/azure/cosmos-db/introduction)
  - [Azure Data Lake Storage](https://docs.microsoft.com/azure/data-lake-store/data-lake-store-overview)
  - [Azure Machine Learning](https://docs.microsoft.com/azure/machine-learning/overview-what-is-azure-ml)
  - [Azure Functions](https://docs.microsoft.com/azure/azure-functions/functions-overview)
  - [Azure Databricks](https://docs.microsoft.com/azure/databricks/scenarios/what-is-azure-databricks)

- Integrated [Geo-disaster recovery and Geo-replication](https://docs.microsoft.com/azure/event-hubs/event-hubs-geo-dr) with data replication coming soon. This integrated geo-disaster recovery is not available in most other offerings.

Cons

- Feature parity with Apache Kafka - Native Kafka features like Transactions, Compression, Log Compaction, Kafka Streams, Kafka Connect (currently in Preview) are not yet available in production
- Schema Registry, which is one of the most sought after offering from Confluent, is just recently announced to be in Public Preview
- [Quotas and limits](https://docs.microsoft.com/azure/event-hubs/event-hubs-quotas) for Azure Event Hubs are restrictive
- The single tenant Dedicated Tier offering of Event Hubs with more quota and relaxed limits comes at a [higher price](https://azure.microsoft.com/pricing/details/event-hubs/)

### Apache Kafka on HDInsight – Managed Cluster

[Kafka on HDInsight](https://docs.microsoft.com/azure/hdinsight/kafka/apache-kafka-introduction) is a managed platform that provides a simplified configuration process that is tested and supported by Microsoft. HDInsight uses native Kafka APIs which means that client application code does not need to change.

- Azure Managed Disks as the backing store for Kafka providing up to 16 TB of storage per Kafka broker
- Rebalancing of Kafka partitions and replicas across Update Domains and Fault Domains
- Number of worker nodes (which host the Kafka broker) can be changed after cluster creation with ease
- VM level monitoring with disk and NIC metrics, and JMX metrics from Kafka is possible with Azure Monitoring
- Offers extended throughput options at the cost of increased complexity and management

Pros

- Managed cluster offering that is customizable
- No license requirements, unless going for Confluent features
- Complete Kafka feature set and APIs are available
- [High availability](https://docs.microsoft.com/azure/hdinsight/kafka/apache-kafka-high-availability) is ensured with the configuration of fault domains and update domains and [multi-region support](https://docs.microsoft.com/azure/hdinsight/kafka/apache-kafka-mirroring) using MirrorMaker for replication
- Data retention is more configurable than the managed services mentioned above

Cons

- Kafka version support and compatibility will always lag behind the published version
- Workload migration is required for upgrading cluster
- Adding more disks to existing cluster is not supported
- No public endpoint available which makes VNET integration mandatory requiring advanced networking configurations

### Confluent Enterprise on Azure Marketplace – Infrastructure-as-a-Service

Confluent Enterprise is available as a bring-your-own-license offering in Azure Marketplace. It  includes all components from the Apache Kafka Core along with some Apache-licensed open source additions (client tools, pre-built connectors, and cluster-side services such as Schema Registry and REST Proxy)

Pros

- Automated cluster provisioning, management, and elastic scaling
- Complete support for all Confluent Enterprise components like Kafka Connect Workers, Kafka Streams Apps, Schema Registry, REST Proxy, and Control Center

Cons

- Deployment available on Azure Marketplace is designed only for Development and POC environments. Production deployment needs to be processed via email exchanges with [azureteam@confluent.io](mailto:azureteam@confluent.io)
- Kafka version support and compatibility will always lag behind the published version
- Deployment inside VNET and hence will need peering to work with clients requiring advanced network configurations
- Bring Your Own License agreement. Free trial for 30 days only.

### Kafka on Azure Kubernetes Service – Infrastructure-as-a-Service

[Azure Kubernetes Service (AKS)](https://docs.microsoft.com/azure/aks/intro-kubernetes) reduces the complexity and overhead of managing Kubernetes by offloading much of that responsibility to Azure. Apache Kafka clusters can be deployed on AKS in various configurations using best practices offered by Kubernetes operators like [Strimzi](https://strimzi.io/documentation/) or [Confluent Kafka Operator](https://docs.confluent.io/current/installation/operator/index.html). There is a basic [scale and throughput benchmarking and investigation](https://microsoft-my.sharepoint-df.com/:w:/p/cnadolny/Edx-ULTiowRFm9CSw_hF1esBrxtZEnhW28rNd9pBBvQ1KA?e=jF6RHT) done by CSE.

Pros

- Provides portable infrastructure as code which is cloud agnostic
- Complete Kafka feature set and APIs are available
- Optional additional features can be supported

Cons

- High availability and disaster recovery need to be planned and configured tediously
- Custom configuration to achieve desired scale and throughput with apt number of resources needs a lot of work
- Upgrades could be disruptive
- Lack of documentation and support for implementation in production

### Kafka on Azure Virtual Machines – Infrastructure-as-a-Service

The Apache Kafka software can be deployed on a bunch of Azure VMs to represent a Kafka cluster. The configuration of the cluster is completely up to the user but it is advisable to follow some [recommended approaches](https://docs.confluent.io/2.0.1/kafka/deployment.html).

Pros

- Complete autonomy and control for user to configure and scale Kafka cluster
- Numerous options to extend the deployment

Cons

- Selecting the right size of VMs can be tedious
- User needs to implement own scaling logic. User configurations determine efficacy
- Management and monitoring overhead
- Best performance demands knowing Azure networking ins and outs which can be tedious.


## Considerations

### Feature comparisons

[Link to Tech Score Card for comparison of top feedback items from customers](https://microsoft-my.sharepoint.com/:p:/p/rasavant/EW2JTX7_YyxFm_77jzwxz94BKrSpQvvoYP3rQk8RPIItoA?e=p14WhI)

| Features | Confluent Cloud | Event Hubs + Kafka Head | HDInsight Kafka | Confluent Enterprise on Marketplace | Kafka on AKS | Azure VMs |
|:--------:|:---------------:|:-----------------------:|:---------------:|:-----------------------------------:|:------------:|:---------:|
|          | PaaS offering from external vendor | Fully managed PaaS offering that supports Kafka protocol | Managed Hortonworks cluster offering | Azure Marketplace offering | Portable cloud agnostic infrastructure | Scalable computing resource |
| **Model** | PaaS (external vendor) | PaaS | Managed IaaS | IaaS |IaaS |IaaS |
| **3rd Party Licensing** | Purchase from Confluent	| Not needed | Not mandatory | BYOL | Not mandatory | Not mandatory |  
| **Supported Compute Environment** | PaaS – underlying Azure Cloud | PaaS – underlying Service Fabric | Managed disks and VMs | VMs | Containers | VMs |  
| **Feature Set** | Work in progress | Work in progress with Kafka | Complete for available versions and extendible | Complete for available versions + Schema Registry, Connectors, KSQL | Complete and extendible	| Complete and extendible |  
| **Data Retention** | 5 TB | Max 90 days, 10 TB included per CU | Customizable | Customizable | Customizable | Customizable | 
| **Schema Registry** | Yes | Public Preview | Yes | Yes | Yes | Yes | 
| **Kafka Connectors API** | Yes | Preview | Yes | Yes | Yes | Yes | 
| **Azure Stack Options** | N/A | Preview | Not Available | Yes | Preview | Yes |  
| **VNET/Public deployment** | Virtual Private Cloud | Public endpoint always exposed | VNET availability in Preview | VNET deployment recommended | VNET deployment | VNET deployment available | VNET deployment available |
| **Configurable Message Retention beyond 7 days** | 5TB limit | Yes | Yes | Yes | Yes | Yes |
| **Idempotency** | Yes | Yes | Yes | Yes | Yes | Yes |
| **Transaction** | Yes | EoY 2020 | Yes | Yes | Yes | Yes |
| **Kafka Streams** | Yes | EoY 2020 | Yes | Yes | Yes | Yes |
| **Scaling** | Yes | Yes | Yes | Yes | Tested on Small to Medium Loads | Yes |
| **Integrated Logging and Monitoring** | Yes | Yes | Can be added | Yes | Can be added | Can be added |
| **Kafka Version Support** | Yes | 1.0+ | 2.1, 1.1, 1.0, 0.10.1, 0.9.0 | 2.2.0, 2.0.1 | Yes | Yes |
| **Java Client** | Yes | Yes | Yes | Yes | Yes | Yes |
| **.NET/Python/C++ Client** | Yes | Yes | Yes | Yes | Yes | Yes |
| **Declarative Stream Processing** | Yes | Can be added using other Azure service | Yes | Yes | Yes | Yes |
| **Log Compaction** | Yes | EoY 2020 | Yes | Yes | Yes | Yes |
| **REST Proxy** | Yes | Yes | Yes | Yes | Yes | Yes |
| **Geo-Replication** | Not available | Integrated | Integrated | Needs to be configured | Needs to be configured | Needs to be configured |
| **Authentication** | SSL or SASL | SSL, SASL Plain | SSL | SSL or SASL | SSL or SASL | SSL or SASL |
| **Authorization** | ACL based |	RBAC |	RBAC (Preview) |	ACL based |	ACL based |	ACL based |
| **Encryption** | SSL/TLS | SSL, BYOK (Preview) | SSE/TLS, Customer-managed disk encryption | SSL/TLS | SSL/TLS | SSL/TLS |
| **Automatic Data Balancer** | N/A - PaaS | N/A - PaaS | Yes | Yes | Yes | Yes |
| **Monitoring Metrics** | Yes | Yes | Can be added | Yes | Can be added | Can be added |
| **Monitoring Tools** | Confluent Control Center | Azure Monitoring | Azure Monitoring and open source tools | Confluent Control Center | Azure Monitoring and open source tools | Can be added |
| **Managed Service** | Yes | Yes | Managed clusters | Managed deployment | No – IaaS | No - IaaS |
| **Non-disruptive upgrades** | Yes | Yes | No | No | No | No |
| **Availability SLA** | 99.5% | 99.9% | 99.9% | N/A | 99.5% for AKS | 95% - 99.9% based on usage |
| **Data Replication** | Confluent Replicator | MirrorMaker or similar (Integrated option coming soon) | Managed disk export / MirrorMaker  or similar | Confluent Replicator | MirrorMaker or similar | MirrorMaker or similar |

### Kafka on Azure Decision Guidance Matrix

The decision matrix uses the following key:

| Symbol                                                 | Feature Support      |
|--------------------------------------------------------|--------------------|
|:::image type="icon" source="../media/empty-star.png":::| Not supported natively or Not applicable
|:::image type="icon" source="../media/half-star.png"::: | Support with limitations or via extensions or via custom code
|:::image type="icon" source="../media/full-star.png"::: | Full native support
|:::image type="icon" source="../media/green-background.png":::| Common decision factor

| Feature | Confluent Cloud | Event Hubs + Kafka Head | HDInsight Kafka | Confluent Enterprise on Marketplace | Kafka on AKS | Azure VMs |
|------------------------------------|:--------------------:|:--------------------:|:--------------------:|:--------------------:|:--------------------:|:--------------------:|
| Ease of configuration/deployment   | :::image type="icon" source="../media/full-star.png"::: | :::image type="icon" source="../media/full-star-green-background.png"::: | :::image type="icon" source="../media/half-star.png"::: | :::image type="icon" source="../media/empty-star.png"::: | :::image type="icon" source="../media/empty-star.png"::: | :::image type="icon" source="../media/empty-star.png"::: | 
| Simplicity of maintenance          | :::image type="icon" source="../media/full-star.png"::: | :::image type="icon" source="../media/full-star-green-background.png"::: | :::image type="icon" source="../media/half-star.png"::: | :::image type="icon" source="../media/empty-star.png"::: | :::image type="icon" source="../media/empty-star.png"::: | :::image type="icon" source="../media/empty-star.png"::: | 
| Kafka native support               | :::image type="icon" source="../media/full-star.png"::: | :::image type="icon" source="../media/half-star.png"::: | :::image type="icon" source="../media/full-star.png"::: | :::image type="icon" source="../media/full-star.png"::: | :::image type="icon" source="../media/full-star.png"::: | :::image type="icon" source="../media/full-star.png"::: |  
| Java, .NET, Python clients         | :::image type="icon" source="../media/full-star.png"::: | :::image type="icon" source="../media/full-star.png"::: | :::image type="icon" source="../media/full-star.png"::: | :::image type="icon" source="../media/full-star.png"::: | :::image type="icon" source="../media/full-star.png"::: | :::image type="icon" source="../media/full-star.png"::: |  
| 100% managed solution              | :::image type="icon" source="../media/full-star-green-background.png"::: | :::image type="icon" source="../media/full-star-green-background.png"::: | :::image type="icon" source="../media/half-star.png"::: | :::image type="icon" source="../media/half-star.png"::: | :::image type="icon" source="../media/half-star.png"::: | :::image type="icon" source="../media/empty-star.png"::: |
| Stream processing support          | :::image type="icon" source="../media/full-star.png"::: | :::image type="icon" source="../media/half-star.png"::: | :::image type="icon" source="../media/full-star-green-background.png"::: | :::image type="icon" source="../media/full-star.png"::: | :::image type="icon" source="../media/full-star.png"::: | :::image type="icon" source="../media/full-star.png"::: | 
| Portability to other clouds        | :::image type="icon" source="../media/empty-star.png"::: | :::image type="icon" source="../media/empty-star.png"::: | :::image type="icon" source="../media/full-star.png"::: | :::image type="icon" source="../media/empty-star.png"::: | :::image type="icon" source="../media/full-star-green-background.png"::: | :::image type="icon" source="../media/full-star-green-background.png"::: |
| Failure recovery                   | :::image type="icon" source="../media/full-star.png"::: | :::image type="icon" source="../media/full-star.png"::: | :::image type="icon" source="../media/empty-star.png"::: | :::image type="icon" source="../media/empty-star.png"::: | :::image type="icon" source="../media/empty-star.png"::: | :::image type="icon" source="../media/empty-star.png"::: | 
| Meets low latency requirements     | :::image type="icon" source="../media/full-star.png"::: | :::image type="icon" source="../media/full-star.png"::: | :::image type="icon" source="../media/full-star.png"::: | :::image type="icon" source="../media/half-star.png"::: | :::image type="icon" source="../media/half-star.png"::: | :::image type="icon" source="../media/half-star.png"::: |
| Meets high throughput requirements | :::image type="icon" source="../media/full-star.png"::: | :::image type="icon" source="../media/full-star.png"::: | :::image type="icon" source="../media/full-star-green-background.png"::: | :::image type="icon" source="../media/half-star.png"::: | :::image type="icon" source="../media/half-star.png"::: | :::image type="icon" source="../media/half-star.png"::: | 
| Ecosystem support                  | :::image type="icon" source="../media/full-star-green-background.png"::: | :::image type="icon" source="../media/half-star.png"::: | :::image type="icon" source="../media/full-star.png"::: | :::image type="icon" source="../media/full-star.png"::: | :::image type="icon" source="../media/full-star.png"::: | :::image type="icon" source="../media/full-star.png"::: |
| Extensibility and Flexibility      | :::image type="icon" source="../media/half-star.png"::: | :::image type="icon" source="../media/half-star.png"::: | :::image type="icon" source="../media/half-star.png"::: | :::image type="icon" source="../media/half-star.png"::: | :::image type="icon" source="../media/full-star-green-background.png"::: | :::image type="icon" source="../media/full-star-green-background.png"::: |
| Supportability                     | :::image type="icon" source="../media/full-star.png"::: | :::image type="icon" source="../media/full-star.png"::: | :::image type="icon" source="../media/full-star.png"::: | :::image type="icon" source="../media/full-star.png"::: | :::image type="icon" source="../media/half-star.png"::: | :::image type="icon" source="../media/half-star.png"::: | 
| Full feature parity                | :::image type="icon" source="../media/full-star.png"::: | :::image type="icon" source="../media/half-star.png"::: | :::image type="icon" source="../media/full-star-green-background.png"::: | :::image type="icon" source="../media/full-star-green-background.png"::: | :::image type="icon" source="../media/full-star.png"::: | :::image type="icon" source="../media/full-star-green-background.png"::: | 
| Geo-replication                    | :::image type="icon" source="../media/empty-star.png"::: | :::image type="icon" source="../media/full-star-green-background.png"::: | :::image type="icon" source="../media/full-star-green-background.png"::: | :::image type="icon" source="../media/half-star.png"::: | :::image type="icon" source="../media/half-star.png"::: | :::image type="icon" source="../media/half-star.png"::: | 
| Data replication                   | :::image type="icon" source="../media/half-star.png"::: | :::image type="icon" source="../media/half-star.png"::: | :::image type="icon" source="../media/half-star.png"::: | :::image type="icon" source="../media/half-star.png"::: | :::image type="icon" source="../media/half-star.png"::: | :::image type="icon" source="../media/half-star.png"::: | 
| Kafka version support              | :::image type="icon" source="../media/half-star.png"::: | :::image type="icon" source="../media/half-star.png"::: | :::image type="icon" source="../media/half-star.png"::: | :::image type="icon" source="../media/half-star.png"::: | :::image type="icon" source="../media/full-star-green-background.png"::: | :::image type="icon" source="../media/full-star-green-background.png"::: | 
| Integrated logging and monitoring  | :::image type="icon" source="../media/full-star.png"::: | :::image type="icon" source="../media/full-star.png"::: | :::image type="icon" source="../media/full-star.png"::: | :::image type="icon" source="../media/full-star.png"::: | :::image type="icon" source="../media/half-star.png"::: | :::image type="icon" source="../media/half-star.png"::: | 
| Confluent schema registry          | :::image type="icon" source="../media/full-star.png"::: | :::image type="icon" source="../media/half-star.png"::: | :::image type="icon" source="../media/half-star.png"::: | :::image type="icon" source="../media/full-star-green-background.png"::: | :::image type="icon" source="../media/half-star.png"::: | :::image type="icon" source="../media/half-star-green-background.png"::: | 
| Configurable message retention     | :::image type="icon" source="../media/half-star.png"::: | :::image type="icon" source="../media/half-star.png"::: | :::image type="icon" source="../media/half-star.png"::: | :::image type="icon" source="../media/full-star.png"::: | :::image type="icon" source="../media/full-star.png"::: | :::image type="icon" source="../media/full-star.png"::: |
| Non-disruptive upgrades            | :::image type="icon" source="../media/full-star.png"::: | :::image type="icon" source="../media/full-star-green-background.png"::: | :::image type="icon" source="../media/half-star.png"::: | :::image type="icon" source="../media/empty-star.png"::: | :::image type="icon" source="../media/empty-star.png"::: | :::image type="icon" source="../media/empty-star.png"::: | 

## Next steps

* []()

## Related resources

* []()
* []()
* []()

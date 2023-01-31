---
title: Criteria for data store choice
titleSuffix: Azure Application Architecture Guide
description: Explore general considerations when choosing your data store. Examine functional and non-functional requirements, management and cost, security, and DevOps.
author: PageWriter-MSFT
ms.date: 08/08/2020
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: guide
azureCategories: developer-tools
categories: developer-tools
products: azure
ms.custom:
  - guide
---

# Criteria for choosing a data store

This article describes the comparison criteria you should use when evaluating a data store. The goal is to help you determine which data storage types can meet your solution's requirements.

## General considerations

Keep the following considerations in mind when making your selection.

### Functional requirements

- **Data format**. What type of data are you intending to store? Common types include transactional data, JSON objects, telemetry, search indexes, or flat files.

- **Data size**. How large are the entities you need to store? Will these entities need to be maintained as a single document, or can they be split across multiple documents, tables, collections, and so forth?

- **Scale and structure**. What is the overall amount of storage capacity you need? Do you anticipate partitioning your data?

- **Data relationships**. Will your data need to support one-to-many or many-to-many relationships? Are relationships themselves an important part of the data? Will you need to join or otherwise combine data from within the same dataset, or from external datasets?

- **Consistency model**. How important is it for updates made in one node to appear in other nodes, before further changes can be made? Can you accept eventual consistency? Do you need ACID guarantees for transactions?

- **Schema flexibility**. What kind of schemas will you apply to your data? Will you use a fixed schema, a schema-on-write approach, or a schema-on-read approach?

- **Concurrency**. What kind of concurrency mechanism do you want to use when updating and synchronizing data? Will the application perform many updates that could potentially conflict. If so, you may require record locking and pessimistic concurrency control. Alternatively, can you support optimistic concurrency controls? If so, is simple timestamp-based concurrency control enough, or do you need the added functionality of multi-version concurrency control?

- **Data movement**. Will your solution need to perform ETL tasks to move data to other stores or data warehouses?

- **Data lifecycle**. Is the data write-once, read-many? Can it be moved into cool or cold storage?

- **Other supported features**. Do you need any other specific features, such as schema validation, aggregation, indexing, full-text search, MapReduce, or other query capabilities?

### Non-functional requirements

- **Performance and scalability**. What are your data performance requirements? Do you have specific requirements for data ingestion rates and data processing rates? What are the acceptable response times for querying and aggregation of data once ingested? How large will you need the data store to scale up? Is your workload more read-heavy or write-heavy?

- **Reliability**. What overall SLA do you need to support? What level of fault-tolerance do you need to provide for data consumers? What kind of backup and restore capabilities do you need?

- **Replication**. Will your data need to be distributed among multiple replicas or regions? What kind of data replication capabilities do you require?

- **Limits**. Will the limits of a particular data store support your requirements for scale, number of connections, and throughput?

### Management and cost

- **Managed service**. When possible, use a managed data service, unless you require specific capabilities that can only be found in an IaaS-hosted data store.

- **Region availability**. For managed services, is the service available in all Azure regions? Does your solution need to be hosted in certain Azure regions?

- **Portability**. Will your data need to be migrated to on-premises, external datacenters, or other cloud hosting environments?

- **Licensing**. Do you have a preference of a proprietary versus OSS license type? Are there any other external restrictions on what type of license you can use?

- **Overall cost**. What is the overall cost of using the service within your solution? How many instances will need to run, to support your uptime and throughput requirements? Consider operations costs in this calculation. One reason to prefer managed services is the reduced operational cost.

- **Cost effectiveness**. Can you partition your data, to store it more cost effectively? For example, can you move large objects out of an expensive relational database into an object store?

### Security

- **Security**. What type of encryption do you require? Do you need encryption at rest? What authentication mechanism do you want to use to connect to your data?

- **Auditing**. What kind of audit log do you need to generate?

- **Networking requirements**. Do you need to restrict or otherwise manage access to your data from other network resources? Does data need to be accessible only from inside the Azure environment? Does the data need to be accessible from specific IP addresses or subnets? Does it need to be accessible from applications or services hosted on-premises or in other external datacenters?

### DevOps

- **Skill set**. Are there particular programming languages, operating systems, or other technology that your team is particularly adept at using? Are there others that would be difficult for your team to work with?

- **Clients** Is there good client support for your development languages?

## Next steps

- [Azure Cloud Storage Solutions and Services](https://azure.microsoft.com/products/category/storage)
- [Review your storage options](/azure/cloud-adoption-framework/ready/considerations/storage-options)
- [Introduction to Azure Storage](/azure/storage/common/storage-introduction)

## Related resources

- [Data store decision tree](data-store-decision-tree.md)
- [Understand data store models](data-store-overview.md)
- [Choose a data storage technology](../../data-guide/technology-choices/data-storage.md)


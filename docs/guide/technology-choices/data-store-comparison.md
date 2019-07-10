---
title: Criteria for choosing a data store
titleSuffix: Azure Application Architecture Guide
description: Overview of Azure compute options.
author: MikeWasson
ms.date: 06/01/2018
ms.topic: guide
ms.service: architecture-center
ms.subservice: reference-architecture
ms.custom: seojan19
---

# Criteria for choosing a data store

Azure supports many types of data storage solutions, each providing different features and capabilities. This article describes the comparison criteria you should use when evaluating a data store. The goal is to help you determine which data storage types can meet your solution's requirements.

## General Considerations

To start your comparison, gather as much of the following information as you can about your data needs. This information will help you to determine which data storage types will meet your needs.

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

The following sections compare various data store models in terms of workload profile, data types, and example use cases.

## Relational database management systems (RDBMS)

<!-- markdownlint-disable MD033 -->

<table>
<tr><td><strong>Workload</strong></td>
    <td>
        <ul>
            <li>Both the creation of new records and updates to existing data happen regularly.</li>
            <li>Multiple operations have to be completed in a single transaction.</li>
            <li>Requires aggregation functions to perform cross-tabulation.</li>
            <li>Strong integration with reporting tools is required.</li>
            <li>Relationships are enforced using database constraints.</li>
            <li>Indexes are used to optimize query performance.</li>
            <li>Allows access to specific subsets of data.</li>
        </ul>
    </td>
</tr>
<tr><td><strong>Data type</strong></td>
    <td>
        <ul>
            <li>Data is highly normalized.</li>
            <li>Database schemas are required and enforced.</li>
            <li>Many-to-many relationships between data entities in the database.</li>
            <li>Constraints are defined in the schema and imposed on any data in the database.</li>
            <li>Data requires high integrity. Indexes and relationships need to be maintained accurately.</li>
            <li>Data requires strong consistency. Transactions operate in a way that ensures all data are 100% consistent for all users and processes.</li>
            <li>Size of individual data entries is intended to be small to medium-sized.</li>
        </ul>
    </td>
</tr>
<tr><td><strong>Examples</strong></td>
    <td>
        <ul>
            <li>Line of business  (human capital management, customer relationship management, enterprise resource planning)</li>
            <li>Inventory management</li>
            <li>Reporting database</li>
            <li>Accounting</li>
            <li>Asset management</li>
            <li>Fund management</li>
            <li>Order management</li>
        </ul>
    </td>
</tr>
</table>

## Document databases

<table>
<tr><td><strong>Workload</strong></td>
    <td>
        <ul>
            <li>General purpose.</li>
            <li>Insert and update operations are common. Both the creation of new records and updates to existing data happen regularly.</li>
            <li>No object-relational impedance mismatch. Documents can better match the object structures used in application code.</li>
            <li>Optimistic concurrency is more commonly used.</li>
            <li>Data must be modified and processed by consuming application.</li>
            <li>Data requires index on multiple fields.</li>
            <li>Individual documents are retrieved and written as a single block.</li>
    </td>
</tr>
<tr><td><strong>Data type</strong></td>
    <td>
        <ul>
            <li>Data can be managed in de-normalized way.</li>
            <li>Size of individual document data is relatively small.</li>
            <li>Each document type can use its own schema.</li>
            <li>Documents can include optional fields.</li>
            <li>Document data is semi-structured, meaning that data types of each field are not strictly defined.</li>
            <li>Data aggregation is supported.</li>
        </ul>
    </td>
</tr>
<tr><td><strong>Examples</strong></td>
    <td>
        <ul>
            <li>Product catalog</li>
            <li>User accounts</li>
            <li>Bill of materials</li>
            <li>Personalization</li>
            <li>Content management</li>
            <li>Operations data</li>
            <li>Inventory management</li>
            <li>Transaction history data</li>
            <li>Materialized view of other NoSQL stores. Replaces file and Blob indexing.</li>
        </ul>
    </td>
</tr>
</table>

## Key/value stores

<table>
<tr><td><strong>Workload</strong></td>
    <td>
        <ul>
            <li>Data is identified and accessed using a single ID key, like a dictionary.</li>
            <li>Massively scalable.</li>
            <li>No joins, lock, or unions are required.</li>
            <li>No aggregation mechanisms are used.</li>
            <li>Secondary indexes are generally not used.</li>
        </ul>
    </td>
</tr>
<tr><td><strong>Data type</strong></td>
    <td>
        <ul>
            <li>Data size tends to be large.</li>
            <li>Each key is associated with a single value, which is an unmanaged data Blob.</li>
            <li>There is no schema enforcement.</li>
            <li>No relationships between entities.</li>
        </ul>
    </td>
</tr>
<tr><td><strong>Examples</strong></td>
    <td>
        <ul>
            <li>Data caching</li>
            <li>Session management</li>
            <li>User preference and profile management</li>
            <li>Product recommendation and ad serving</li>
            <li>Dictionaries</li>
        </ul>
    </td>
</tr>
</table>

## Graph databases

<table>
<tr><td><strong>Workload</strong></td>
    <td>
        <ul>
            <li>The relationships between data items are very complex, involving many hops between related data items.</li>
            <li>The relationship between data items are dynamic and change over time.</li>
            <li>Relationships between objects are first-class citizens, without requiring foreign-keys and joins to traverse.</li>
        </ul>
    </td>
</tr>
<tr><td><strong>Data type</strong></td>
    <td>
        <ul>
            <li>Data is comprised of nodes and relationships.</li>
            <li>Nodes are similar to table rows or JSON documents.</li>
            <li>Relationships are just as important as nodes, and are exposed directly in the query language.</li>
            <li>Composite objects, such as a person with multiple phone numbers, tend to be broken into separate, smaller nodes, combined with traversable relationships </li>
        </ul>
    </td>
</tr>
<tr><td><strong>Examples</strong></td>
    <td>
        <ul>
            <li>Organization charts</li>
            <li>Social graphs</li>
            <li>Fraud detection</li>
            <li>Analytics</li>
            <li>Recommendation engines</li>
        </ul>
    </td>
</tr>
</table>

## Column-family databases

<table>
<tr><td><strong>Workload</strong></td>
    <td>
        <ul>
            <li>Most column-family databases perform write operations extremely quickly.</li>
            <li>Update and delete operations are rare.</li>
            <li>Designed to provide high throughput and low-latency access.</li>
            <li>Supports easy query access to a particular set of fields within a much larger record.</li>
            <li>Massively scalable.</li>
        </ul>
    </td>
</tr>
<tr><td><strong>Data type</strong></td>
    <td>
        <ul>
            <li>Data is stored in tables consisting of a key column and one or more column families.</li>
            <li>Specific columns can vary by individual rows.</li>
            <li>Individual cells are accessed via get and put commands</li>
            <li>Multiple rows are returned using a scan command.</li>
        </ul>
    </td>
</tr>
<tr><td><strong>Examples</strong></td>
    <td>
        <ul>
            <li>Recommendations</li>
            <li>Personalization</li>
            <li>Sensor data</li>
            <li>Telemetry</li>
            <li>Messaging</li>
            <li>Social media analytics</li>
            <li>Web analytics</li>
            <li>Activity monitoring</li>
            <li>Weather and other time-series data</li>
        </ul>
    </td>
</tr>
</table>

## Search engine databases

<table>
<tr><td><strong>Workload</strong></td>
    <td>
        <ul>
            <li>Indexing data from multiple sources and services.</li>
            <li>Queries are ad-hoc and can be complex.</li>
            <li>Requires aggregation.</li>
            <li>Full text search is required.</li>
            <li>Ad hoc self-service query is required.</li>
            <li>Data analysis with index on all fields is required.</li>
        </ul>
    </td>
</tr>
<tr><td><strong>Data type</strong></td>
    <td>
        <ul>
            <li>Semi-structured or unstructured</li>
            <li>Text</li>
            <li>Text with reference to structured data</li>
        </ul>
    </td>
</tr>
<tr><td><strong>Examples</strong></td>
    <td>
        <ul>
            <li>Product catalogs</li>
            <li>Site search</li>
            <li>Logging</li>
            <li>Analytics</li>
            <li>Shopping sites</li>
        </ul>
    </td>
</tr>
</table>

## Data warehouse

<table>
<tr><td><strong>Workload</strong></td>
    <td>
        <ul>
            <li>Data analytics</li>
            <li>Enterprise BI</li>
        </ul>
    </td>
</tr>
<tr><td><strong>Data type</strong></td>
    <td>
        <ul>
            <li>Historical data from multiple sources.</li>
            <li>Usually denormalized in a &quot;star&quot; or &quot;snowflake&quot; schema, consisting of fact and dimension tables.</li>
            <li>Usually loaded with new data on a scheduled basis.</li>
            <li>Dimension tables often include multiple historic versions of an entity, referred to as a <em>slowly changing dimension</em>.</li>
        </ul>
    </td>
</tr>
<tr><td><strong>Examples</strong></td>
    <td>An enterprise data warehouse that provides data for analytical models, reports, and dashboards.
    </td>
</tr>
</table>

## Time series databases

<table>
<tr><td><strong>Workload</strong></td>
    <td>
        <ul>
            <li>An overwhelming proportion of operations (95-99%) are writes.</li>
            <li>Records are generally appended sequentially in time order.</li>
            <li>Updates are rare.</li>
            <li>Deletes occur in bulk, and are made to contiguous blocks or records.</li>
            <li>Read requests can be larger than available memory.</li>
            <li>It&#39;s common for multiple reads to occur simultaneously.</li>
            <li>Data is read sequentially in either ascending or descending time order.</li>
        </ul>
    </td>
</tr>
<tr><td><strong>Data type</strong></td>
    <td>
        <ul>
            <li>A timestamp that is used as the primary key and sorting mechanism.</li>
            <li>Measurements from the entry or descriptions of what the entry represents.</li>
            <li>Tags that define additional information about the type, origin, and other information about the entry.</li>
        </ul>
    </td>
</tr>
<tr><td><strong>Examples</strong></td>
    <td>
        <ul>
            <li>Monitoring and event telemetry.</li>
            <li>Sensor or other IoT data.</li>
        </ul>
    </td>
</tr>
</table>

## Object storage

<table>
<tr><td><strong>Workload</strong></td>
    <td>
        <ul>
            <li>Identified by key.</li>
            <li>Objects may be publicly or privately accessible.</li>
            <li>Content is typically an asset such as a spreadsheet, image, or video file.</li>
            <li>Content must be durable (persistent), and external to any application tier or virtual machine.</li>
        </ul>
    </td>
</tr>
<tr><td><strong>Data type</strong></td>
    <td>
        <ul>
            <li>Data size is large.</li>
            <li>Blob data.</li>
            <li>Value is opaque.</li>
        </ul>
    </td>
</tr>
<tr><td><strong>Examples</strong></td>
    <td>
        <ul>
            <li>Images, videos, office documents, PDFs</li>
            <li>CSS, Scripts, CSV</li>
            <li>Static HTML, JSON</li>
            <li>Log and audit files</li>
            <li>Database backups</li>
        </ul>
    </td>
</tr>
</table>

## Shared files

<table>
<tr><td><strong>Workload</strong></td>
    <td>
        <ul>
            <li>Migration from existing apps that interact with the file system.</li>
            <li>Requires SMB interface.</li>
        </ul>
    </td>
</tr>
<tr><td><strong>Data type</strong></td>
    <td>
        <ul>
            <li>Files in a hierarchical set of folders.</li>
            <li>Accessible with standard I/O libraries.</li>
        </ul>
    </td>
</tr>
<tr><td><strong>Examples</strong></td>
    <td>
        <ul>
            <li>Legacy files</li>
            <li>Shared content accessible among a number of VMs or app instances</li>
        </ul>
    </td>
</tr>
</table>

<!-- markdownlint-enable MD033 -->

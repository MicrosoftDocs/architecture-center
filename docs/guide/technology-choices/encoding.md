---
title: Message encoding considerations
titleSuffix: Azure Application Architecture Guide
description: Overview of various encoding formats related to messaging.
author: PageWriter-MSFT
ms.date: 02/28/2020
ms.topic: guide
ms.service: architecture-center
ms.subservice: reference-architecture
ms.custom: seomar20
---

# Message encoding considerations

Many cloud applications use asynchronous messages to exchange information between components of the system. An important aspect of messaging is the format used to encode the payload data. There are many options available, but the right choice depends on your use case. 

After you [choose a messaging technology](../messaging.md), the next step is to define how the messages will be encoded. This article describes some of the considerations.

## Overview

A message exchange between a producer and a consumer needs:

-	A shape or structure that defines the payload of the message. 
-	An encoding format to represent the payload. 
-	Serialization libraries to read and write the encoded payload. 

As the producer of the message, define the shape as per the [intent of the message](messaging.md). If the message is a command, the shape can be based on business logic. For an event, shape could be the notification data. 

To structure the shape, divide the information into discrete or related subjects (fields). Decide the characteristics of the values for those fields. Consider: What is the most efficient datatype? Will the payload always have certain fields? Will the payload have a single record or a repeated set of values? 

Then, choose an encoding format depending on your need. Certain factors include the ability to create highly structured data if you need it, time taken to encode and transfer the message, and the ability to parse the payload. 

Depending on the encoding format, choose a serialization library that is well supported. 

A consumer of the message must be aware of those decisions so that it knows how to read incoming messages.

To transfer messages, the producer serializes the message to an encoding format. At the receiving end, the consumer deserializes the payload to use the data. This way both entities share the model and as long as the shape doesn’t change, messaging continues without issues. When the contract changes, the encoding format should be capable of handling the change without breaking the consumer.

Some encoding formats such as JSON can be parsed without deserialization but yield larger messages. With other formats, the data may not be parsed easily but the messages are compact. This article highlights some factors that can help you choose a format. 

## Encoding format considerations
The type of message can influence the format choice. Your messages related to business transactions most likely will contain highly structured data. Also, you may want to retrieve it later for auditing purposes. For a stream of events, you might want to get a sequence of records as quickly as possible and store it for statistical analysis. 

Here are some points to consider when choosing an encoding format.

### Human readability

Message encoding can be broadly divided into text-based and binary formats. 

With text-based encoding, the message payload is in plain text and that's why easily parsed. Because the shape always stays with the payload, and the consumer doesn’t have to decipher the payload. So, human readable formats are suitable for archival data. Also, because you can read the payload, it’s easy to debug and send to logs for troubleshooting errors.

The downside is that the payload tends to be larger. A common text-based format is JSON.

Binary formats are compact and require serialization/deserialization libraries. The payload can't be read unless it's decoded.

### Encoding size
Message size impacts network I/O performance across the wire. For binary encoding, data is compressed during serialization resulting in smaller payloads. 

Use binary formats if you want to reduce wire footprint and transfer messages faster. This category of format is recommended in scenarios where storage or network bandwidth is a concern. Options for binary formats include Apache Avro, Google Protocol Buffers (protobuf), MessagePack, and Concise Binary Object Representation (CBOR).

The disadvantage is that the payload isn't human readable. Most binary formats use complex systems that can be costly to maintain. Also, they need specialized libraries to decode, which may not be supported if you want to retrieve archival data.  

### Understanding the payload

Metadata describes the shape that helps a consumer understand the payload. There are two main approaches for storing and distributing metadata: 

- Tagged metadata

    The producer writes the payload that contains metadata fields that describe the data. There's no schema at the producer’s end. 
    On receiving the message, the consumer reads the payload. One way to understand the fields is to query for expected values. For example, the producer sends a payload in JSON. The consumer parses the JSON into a dictionary and checks the existence of fields to understand the payload. Another way is for the consumer to apply a model shared by the producer.  
- Schema

    The producer and consumer have a contract through a well-defined schema. The schema can define the datatypes, required/optional fields, version information, and the structure of the payload. The producer sends the payload as per the writer schema. The consumer receives the payload by applying a reader schema. The message is serialized/deserialized by using the encoding-specific libraries. There are two ways to distribute schemas. 
    -	Store the schema as a preamble or header in the message but separate from the payload. 
    
    -	Store the schema in externally. 

        Some encoding formats define the schema and use tools that generate classes from the schema. The producer and consumer use those classes and libraries to serialize and deserialize the payload. The libraries also provide compatibility checks between the writer and reader schema. Both protobuf and Apache Avro follow that approach. The key difference is that protobuf has a language-agnostic schema definition but Avro uses compact JSON. Another difference is in the way both formats provide compatibility checks between reader and writer schemas.  

        Another way to store the schema externally in a schema registry. The message contains a reference to the schema and the payload. The producer sends the schema identifier in the message and the consumer retrieves the schema by specifying that identifier from an external store. Both parties use format-specific library to read and write messages. Apart from storing the schema a registry can provide compatibility checks to make sure the contract between the producer and consumer isn't broken as the schema evolves. 

Before choosing an approach, decide what is more important: the transfer data size or the ability to parse the archived data later.

Schema stored with the payload yields larger encoding size and is preferred for intermittent messages. Choose the schema approach if transferring smaller chunks of bytes is crucial or you expect a sequence of records. The cost of maintaining an external schema store can be high.

However, if on-demand decoding of the payload is more important than size, including the schema with the payload or the tagged metadata approach guarantees decoding afterwards. There might be a significant increase in message size and may impact the cost of storage.

### Schema versioning

As business requirements change, the shape is expected to change, and the schema will evolve. 

Versioning allows the producer to indicate schema updates that might include new features. 

There are two aspects to versioning. 

- The consumer should be aware of the changes. 

    One way is for the consumer to check all fields to determine whether the schema has changed. Another way is for the producer to publish a schema version number with the message. When the schema evolves, the producer increments the version.

- Changes must not affect or break the business logic of consumers.

    Suppose a field is added to an existing schema, which creates a new version. If consumers using the new schema get a payload as per the old schema, their logic might break if they are not able to overlook the lack of the new field. Considering the reverse case, suppose a field is removed in the new schema. Consumers using the old schema might not be able to read the data.  

    Encoding formats such as Avro offer the ability to define default values. In the preceding example, if the field is added with a default value, the missing field will be populated with the default value. Other formats such as protobuf provide similar functionality through required and optional fields.


### Payload structure

Consider the way data is arranged in the payload. Is it a sequence of records or a discrete single payload? The payload structure can be categorized into one of these models:

-	Array/dictionary/value: Defines entries that hold values in one or multi-dimensional arrays. Entries have unique key-value pairs. It can be extended to represent the complex structures. Some examples include, JSON, Apache Avro, and MessagePack.

    This layout is suitable if messages are individual encoded with different schemas. If you have multiple records, the payload can get overly redundant causing the payload to bloat.
-	Tabular data: Information is divided into rows and columns. Each column indicates a field, or the subject of the information and each row contains values for those fields. This layout is efficient for a repeating set of information, such as time series data. 

    CSV is one of the simplest text-based format. It presents data as a sequence of records with a common header. For binary encoding, Apache Avro has a preamble is similar to a CSV header but generate compact encoding size. 


### Library support

Consider using well-known formats over a proprietary model.

Well-known formats are supported through libraries that are universally supported by the community. With specialized formats, you need specific libraries. Your business logic might have to work around some of the API design choices provided by libraries.

Choose an encoding library that makes compatibility checks between the reader and writer schema. Certain encoding libraries, such as Apache Avro, expect the consumer to specify both writer and the reader schema before deserializing the message. This check ensures that the consumer is aware of the schema versions.

### Interoperability
In text-based options, JSON is the most interoperable.

Azure Stream Analytics has native support for JSON, CSV, Avro, or you can provide a [custom deserializer](/azure/stream-analytics/custom-deserializer).

JSON is a standard interchange format for HTTP REST APIs, you might pick JSON for messaging to avoid a deserialize/reserialize round trip.

## Choices for encoding formats 
Here are some popular encoding formats. Factor in the considerations before you choose a format.


### JSON
[JSON](https://json.org/) is an open standard (IETF [RFC8259]https://tools.ietf.org/html/rfc8259()). It’s a text-based format that follows the array/dictionary/value model. 

JSON can be used for tagging metadata and you can parse the payload without a schema. JSON supports the option to specify optional fields, which helps with forward and backward compatibility. 

The biggest advantage is that its universally available. It’s most interoperable and the default encoding format for many messaging services such as [Azure Service Bus](/azure/service-bus-messaging/) and [Event Grid](/azure/event-grid/). 

Being a text-based format, it isn't efficient over the wire and not an ideal choice in cases where storage is a concern. If you're returning cached items directly to a client via HTTP, storing JSON could save the cost of deserializing from another format and then serializing to JSON.

Use for messages single record messages or a sequence of messages where each message has a different schema. Avoid using JSON for a sequence of records, such as time-series data.  

There are other variations of JSON such as [BSON](http://bsonspec.org/), which is a binary encoding aligned to work with MongoDB.

### Comma-Separated Values (CSV)
CSV is a text-based tabular format. The header of the table indicates the fields. It’s a preferred choice where the message contains a set of records. 

The disadvantage is lack of standardization. There are many ways of expressing separators, headers, and empty fields. 

### Protocol Buffers (protobuf) 
[Google Protocol Buffers](https://github.com/google/protobuf) (or protobuf) is a serialization format that uses strongly typed definition files to define schemas in key/value pairs. These definition files are then compiled to language-specific classes that are used for serializing and deserializing messages. 

The message contains a compressed binary small payload, which results is faster transfer. The downside is the payload isn't human readable. Also, because the schema is external, it’s not recommended for cases where you have to retrieve archived data. 

### Apache Avro
[Apache Avro](https://avro.apache.org/) is a binary serialization format that uses definition file similar to protobuf but there isn't a compilation step. Instead, serialized data always includes a schema preamble.

The preamble can hold the header or a schema identifier. Because of the smaller encoding size, Avro is recommended for streaming data. Also, because it has a header that applies to a set of records, it’s a good choice for tabular data. 

### MessagePack
[MessagePack](https://msgpack.org/) is a binary serialization format that is designed to be compact for transmission over the wire. There are no message schemas or message type checking. This format isn't recommended for bulk storage. 

### CBOR
[Concise Binary Object Representation](http://cbor.io/) (CBOR) (Specification) is a binary format that offers small encoding size. The advantage of CBOR over MessagePack is that its compliant with IETF in RFC7049.



---
title: Message Encoding Considerations
description: Review how to choose an encoding format for asynchronous messaging. Explore encoding format considerations and choices for encoding formats.
ms.author: pnp
author: claytonsiemens77
ms.date: 01/31/2025
ms.topic: best-practice
ms.subservice: best-practice
---

<!-- cSpell:ignore BSON CBOR -->

# Best practices for message encoding

Many cloud applications use asynchronous messages to exchange information between components of the system. An important aspect of messaging is the format used to encode the payload data. After you [choose a messaging technology](../guide/technology-choices/messaging.yml), the next step is to define how the messages are encoded. There are many options available, but the right choice depends on your use case.

This article describes some of the considerations.

## Message exchange needs

A message exchange between a producer and a consumer needs:

- A shape or structure that defines the payload of the message.
- An encoding format to represent the payload.
- Serialization libraries to read and write the encoded payload.

The producer of the message defines the message shape based on the business logic and the information that it wants to send to the consumers. To structure the shape, divide the information into discrete or related subjects (or *fields*). Decide the characteristics of the values for those fields. Consider the following questions.

- What is the most efficient data type?
- Does the payload always have specific fields?
- Does the payload have a single record or a repeated set of values?

Then choose an encoding format depending on your needs. Specific factors include the ability to create highly structured data if you need it, the time taken to encode and transfer the message, and the ability to parse the payload. Then choose an encoding format that meets your needs.

The consumer must understand those decisions to correctly read incoming messages.

To transfer messages, the producer serializes the message to an encoding format. At the receiving end, the consumer deserializes the payload to access the data. This process ensures that both entities share the same model. As long as the shape remains unchanged, messaging continues without any problems. When the contract changes, the encoding format should be capable of handling the change without breaking the consumer.

Some encoding formats such as JSON are self-describing, which means that they can be parsed without referencing a schema. However, these formats often produce larger messages. Other formats might not parse data as easily, but they result in more compact messages. This article outlines key factors to help you choose the right format.

## Encoding format considerations

The encoding format defines how a set of structured data is represented as bytes. The type of message can influence the choice of format. Messages related to business transactions most likely contain highly structured data. Also, you might want to retrieve the structured data later for auditing purposes. For a stream of events, you might want to read a sequence of records as quickly as possible and store it for statistical analysis.

Consider the following factors when you choose an encoding format.

### Human readability

Message encoding can be broadly divided into text-based and binary formats.

With text-based encoding, the message payload is in plain text, so a person can inspect it without using code libraries. This approach makes data easier to read and understand. Human-readable formats are suitable for archival data. Because a human can read the payload, text-based formats are easier to debug and send to logs for troubleshooting errors.

The downside of text-based encoding is that the payload tends to be larger. The payload size can often be reduced through a minification process, as long as it can be reversed for human readability when needed. Common text-based formats are JSON and YAML.

### Encryption

If there's sensitive data in the messages, consider whether those messages should be [encrypted in their entirety](/azure/service-bus-messaging/configure-customer-managed-key). Alternatively, if only specific fields need to be encrypted and you prefer to reduce cloud costs, consider using a library like [NServiceBus](https://docs.particular.net/samples/encryption/basic-encryption/).

### Encoding size

Message size affects network input/output performance across the wire. Binary formats are more compact than text-based formats. Binary formats require serialization and deserialization libraries. The payload can only be read when it's decoded.

Use a binary format if you want to reduce wire footprint and transfer messages faster. This category of format is recommended in scenarios where storage or network bandwidth is a concern. Options for binary formats include Apache Avro, Google Protocol Buffers (protobuf), MessagePack, and Concise Binary Object Representation (CBOR). The pros and cons of these formats are described later in [Choices for encoding formats](#choices-for-encoding-formats).

The disadvantage of binary format is that the payload isn't human readable. Most binary formats use complex systems that can be costly to maintain. Also, they need specialized libraries to decode, which might not be supported if you want to retrieve archival data.

For nonbinary formats, a minification process removes unnecessary spaces and characters while preserving compliance with the format's specification. This approach helps reduce encoding size without altering the structure. Evaluate the capabilities of your encoder to make minification the default. For example, [`JsonSerializerOptions.WriteIndented`](/dotnet/api/system.text.json.jsonserializeroptions.writeindented) from .NET's `System.Text.Json.JsonSerializer` controls automatic minification when creating JSON text.

### Understanding the payload

A message payload arrives as a sequence of bytes. To parse this sequence, the consumer must have access to metadata that describes the data fields in the payload. The two main approaches for storing and distributing metadata are:

**Tagged metadata.** In some encoding formats, notably JSON, fields are tagged with the data type and identifier, within the body of the message. These formats are *self-describing* because they can be parsed into a dictionary of values without referring to a schema. One way for the consumer to understand the fields is to query for expected values. For example, the producer sends a payload in JSON. The consumer parses the JSON into a dictionary and checks the existence of fields to understand the payload. Another way is for the consumer to apply a data model that the producer shares. For example, if you use a statically typed language, many JSON serialization libraries can parse a JSON string into a typed class.

**Schema.** A schema formally defines the structure and data fields of a message. In this model, the producer and consumer have a contract through a well-defined schema. The schema can define the data types, required or optional fields, version information, and the structure of the payload. The producer sends the payload according to the writer schema. The consumer receives the payload by applying a reader schema. The message is serialized and deserialized by using the encoding-specific libraries. Schemas can be distributed in two ways:

- Store the schema as a preamble or header in the message but separately from the payload.

- Store the schema externally.

Some encoding formats define the schema and use tools that generate classes from the schema. The producer and consumer use those classes and libraries to serialize and deserialize the payload. The libraries also provide compatibility checks between the writer and reader schema. Both protobuf and Apache Avro follow that approach. The key difference is that protobuf has a language-agnostic schema definition and Avro uses compact JSON. Another difference is in the way both formats provide compatibility checks between reader and writer schemas.

Another way to store the schema externally is in a schema registry. The message contains a reference to the schema and the payload. The producer sends the schema identifier in the message. The consumer retrieves the schema by specifying that identifier from an external store. Both parties use a format-specific library to read and write messages. In addition to storing the schema, a registry can provide compatibility checks to ensure that the contract between the producer and consumer isn't broken as the schema evolves.

Before you choose an approach, decide whether the transfer data size or the ability to parse the archived data later is more important.

Storing the schema along with the payload produces a larger encoding size and is ideal for intermittent messages. Choose this approach if transferring smaller chunks of bytes is crucial or you expect a sequence of records. The cost to maintain an external schema store can be high.

However, if on-demand decoding of the payload is more important than size, including the schema with the payload or the tagged metadata approach guarantees decoding afterwards. There might be a significant increase in message size that affects the cost of storage.

### Schema versioning

As business requirements change, the shape is expected to change, and the schema evolves. Versioning allows the producer to indicate schema updates that might include new features. Versioning has two key aspects:

- The consumer should track and understand the changes.

  One way is for the consumer to check all fields to determine whether the schema has changed. Another way is for the producer to publish a schema version number with the message. When the schema evolves, the producer increments the version.

- Changes must not affect or break the business logic of consumers.

  Suppose a field is added to an existing schema. If consumers that use the new version get a payload according to the old version, their logic might break if they can't overlook the lack of the new field. Now consider the opposite scenario. If a field is removed in the new schema, consumers that use the old schema might not be able to read the data.

  Encoding formats such as Avro provide the ability to define default values. In the preceding example, if the field is added with a default value, the missing field is populated with the default value. Other formats such as protobuf provide similar functionality through required and optional fields.

### Payload structure

Consider whether the data in the payload is structured as a sequence of records or as a single discrete payload. The payload structure can be categorized into one of the following models:

- **Array/dictionary/value:** Defines entries that hold values in one or multidimensional arrays. Entries have unique key/value pairs. The model can be extended to represent complex structures. Some examples include JSON, Apache Avro, and MessagePack.

  This layout is suitable if messages are individually encoded with different schemas. If you have multiple records, the payload can get overly redundant. This redundancy can cause the payload to bloat.

- **Tabular data:** Information is divided into rows and columns. Each column indicates a field, or the subject of the information, and each row contains values for those fields. This layout is efficient for a repeating set of information, such as time series data.

  Comma-Separated Values (CSV) is one of the simplest text-based formats. It presents data as a sequence of records with a common header. For binary encoding, Apache Avro has a preamble that's similar to a CSV header but that generates a more compact encoding size.

### Library support

You should use well-known formats instead of a proprietary model. Well-known formats are supported through libraries that the community universally supports. With specialized formats, you need specific libraries. Your business logic might have to work around some of the API design choices provided by the libraries.

For a schema-based format, choose an encoding library that makes compatibility checks between the reader and writer schema. Specific encoding libraries, such as Apache Avro, expect the consumer to specify both the writer and the reader schema before deserializing the message. This check ensures that the consumer is aware of the schema versions.

### Interoperability

Your choice of formats might depend on the specific workload or technology ecosystem.

For example:

- Azure Stream Analytics has native support for JSON, CSV, and Avro. When your workload uses Stream Analytics, it makes sense to choose one of these formats.

- JSON is a standard interchange format for HTTP REST APIs. If your application receives JSON payloads from clients and then places them onto a message queue for asynchronous processing, it might make sense to use JSON for the messaging instead of re-encoding into a different format.

These are just two examples of interoperability considerations. Standardized formats are generally more interoperable than custom formats. In text-based options, JSON is one of the most interoperable.

## Choices for encoding formats

The following popular encoding formats are used for data representation and transmission. Factor in the considerations before you choose a format.

### JSON

JSON is an open standard, with its format defined by the [Internet Engineering Task Force (IETF)](https://www.ietf.org/) in [RFC 8259](https://tools.ietf.org/html/rfc8259). JSON is a text-based format that follows the array/dictionary/value model.

JSON can be used for tagging metadata, and you can parse the payload without a schema. JSON supports the option to specify optional fields, which helps with both forward and backward compatibility.

The biggest advantage is that it's universally available. JSON is the most interoperable encoding format and the default for many messaging services.

Because JSON is a text-based format, it isn't efficient over the wire and not ideal when storage is a concern. Use minification techniques when possible. If you return cached items directly to a client via HTTP, storing JSON might save the cost of deserializing from another format and then serializing to JSON.

Use JSON for single-record messages or for a sequence of messages in which each message has a different schema. Avoid using JSON for a sequence of records, such as for time-series data.

There are other variations of JSON such as [binary JSON (BSON)](https://bsonspec.org). BSON is a binary encoding aligned to work with MongoDB.

### CSV

CSV is a text-based tabular format. The header of the table indicates the fields. CSV is well-suited for messages that contain a set of records.

The disadvantage of CSV is a lack of standardization. There are multiple ways of expressing separators, headers, and empty fields.

### Protocol Buffers

[Protocol Buffers](https://protobuf.dev) (or protobuf) is a serialization format that uses strongly typed definition files to define schemas in key/value pairs. These definition files are then compiled to language-specific classes that are used for serializing and deserializing messages.

The message contains a small, compressed binary payload, which results in faster data transfer. The downside is that the payload isn't human readable. Also, because the schema is stored externally, this format isn't ideal for scenarios that require you to retrieve archived data.

### Apache Avro

[Apache Avro](https://avro.apache.org) is a binary serialization format that uses a definition file similar to protobuf, but without a compilation step. Instead, serialized data always includes a schema preamble.

The preamble can contain the header or a schema identifier. Because of its smaller encoding size, Avro is recommended for streaming data. Also, because it has a header that applies to a set of records, it's well-suited for tabular data.

### Apache Parquet

[Apache Parquet](https://parquet.apache.org/) is a columnar storage file format typically associated with Apache Hadoop and related data processing frameworks.

Apache Parquet supports data compression and has limited capabilities for schema evolution. This format is typically used when other big data technologies in your workload require it for data creation or consumption.

### MessagePack

[MessagePack](https://msgpack.org) is a binary serialization format that's designed to be compact for transmission over the wire. MessagePack lacks schema definition and type checking. This format isn't recommended for bulk storage.

### CBOR

[CBOR](https://cbor.io) (Specification) is a binary format that provides a small encoding size. The advantage of using CBOR over MessagePack is its compliance with IETF in RFC7049.

## Next steps

- [Azure Service Bus messages, payloads, and serialization](/azure/service-bus-messaging/service-bus-messages-payloads)
- [Response compression in ASP.NET Core](/aspnet/core/performance/response-compression)

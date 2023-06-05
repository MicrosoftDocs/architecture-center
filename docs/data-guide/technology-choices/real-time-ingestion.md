---
title: Choose a real-time message ingestion technology
description: Choose an Azure message ingestion store to support message buffering, scale-out processing, reliable delivery, and queuing semantics.
author: martinekuan
ms.author: architectures
categories: azure
ms.date: 07/25/2022
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
products:
  - azure-event-hubs
  - azure-iot-hub
ms.custom:
  - guide
---

# Choose a real-time message ingestion technology in Azure

Real time processing deals with streams of data that are captured in real-time and processed with minimal latency. Many real-time processing solutions need a message ingestion store to act as a buffer for messages, and to support scale-out processing, reliable delivery, and other message queuing semantics.

## What are your options for real-time message ingestion?

- [Azure Event Hubs](/azure/event-hubs/)
- [Azure IoT Hub](/azure/iot-hub/)
- [Kafka on HDInsight](/azure/hdinsight/kafka/apache-kafka-get-started)

## Azure Event Hubs

[Azure Event Hubs](/azure/event-hubs/) is a highly scalable data streaming platform and event ingestion service, capable of receiving and processing millions of events per second. Event Hubs can process and store events, data, or telemetry produced by distributed software and devices. Data sent to an event hub can be transformed and stored using any real-time analytics provider or batching/storage adapters. Event Hubs provides publish-subscribe capabilities with low latency at massive scale, which makes it appropriate for big data scenarios.

## Azure IoT Hub

[Azure IoT Hub](/azure/iot-hub/) is a managed service that enables reliable and secure bidirectional communications between millions of IoT devices and a cloud-based back end.

Features of IoT Hub include:

- Multiple options for device-to-cloud and cloud-to-device communication. These options include one-way messaging, file transfer, and request-reply methods.
- Message routing to other Azure services.
- Queryable store for device metadata and synchronized state information.
- Secure communications and access control using per-device security keys or X.509 certificates.
- Monitoring of device connectivity and device identity management events.

In terms of message ingestion, IoT Hub is similar to Event Hubs. However, it was specifically designed for managing IoT device connectivity, not just message ingestion. For more information, see [Comparison of Azure IoT Hub and Azure Event Hubs](/azure/iot-hub/iot-hub-compare-event-hubs).

## Kafka on HDInsight

[Apache Kafka](https://kafka.apache.org/) is an open-source distributed streaming platform that can be used to build real-time data pipelines and streaming applications. Kafka also provides message broker functionality similar to a message queue, where you can publish and subscribe to named data streams. It is horizontally scalable, fault-tolerant, and extremely fast. [Kafka on HDInsight](/azure/hdinsight/kafka/apache-kafka-get-started) provides a Kafka as a managed, highly scalable, and highly available service in Azure.

Some common use cases for Kafka are:

- **Messaging**. Because it supports the publish-subscribe message pattern, Kafka is often used as a message broker.
- **Activity tracking**. Because Kafka provides in-order logging of records, it can be used to track and re-create activities, such as user actions on a web site.
- **Aggregation**. Using stream processing, you can aggregate information from different streams to combine and centralize the information into operational data.
- **Transformation**. Using stream processing, you can combine and enrich data from multiple input topics into one or more output topics.

## Key selection criteria

To narrow the choices, start by answering these questions:

- Do you need two-way communication between your IoT devices and Azure? If so, choose IoT Hub.

- Do you need to manage access for individual devices and be able to revoke access to a specific device? If yes, choose IoT Hub.

## Capability matrix

The following tables summarize the key differences in capabilities.

| Capability | IoT Hub | Event Hubs | Kafka on HDInsight |
| --- | --- | --- | --- |
| Cloud-to-device communications | Yes | No | No |
| Device-initiated file upload | Yes | No | No |
| Device state information | [Device twins](/azure/iot-hub/iot-hub-devguide-device-twins) | No | No |
| Protocol support | MQTT, AMQP, HTTPS <sup>1</sup> | AMQP, HTTPS, [Kafka Protocol](/azure/event-hubs/event-hubs-for-kafka-ecosystem-overview) | [Kafka Protocol](https://cwiki.apache.org/confluence/display/KAFKA/A+Guide+To+The+Kafka+Protocol) |
| Security | Per-device identity; revocable access control. | Shared access policies; limited revocation through publisher policies. | Authentication using SASL; pluggable authorization; integration with external authentication services supported. |

[1] You can also use [Azure IoT protocol gateway](/azure/iot-hub/iot-hub-protocol-gateway) as a custom gateway to enable protocol adaptation for IoT Hub.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Zoiner Tejada](https://www.linkedin.com/in/zoinertejada) | CEO and Architect

## Next steps

- [Comparison of Azure IoT Hub and Azure Event Hubs](/azure/iot-hub/iot-hub-compare-event-hubs)
- [Choose a real-time analytics and streaming processing technology on Azure](/azure/stream-analytics/streaming-technologies)
- [Explore fundamentals of real-time analytics](/training/modules/explore-fundamentals-stream-processing)

## Related resources

- [Choose a stream processing technology](stream-processing.md)
- [Real time processing](../big-data/real-time-processing.yml)
- [Real-time analytics on big data architecture](../../solution-ideas/articles/real-time-analytics.yml)

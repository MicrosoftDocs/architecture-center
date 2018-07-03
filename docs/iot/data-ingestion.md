# Ingesting messages from IoT devices into the cloud

This chapter describes how to get data from IoT devices into the cloud.

## Requirements 

**High scale ingestion**. Even a moderately sized IoT solution generates a lot of data. For our basic reference implementation, we targeted 10,000 devices, with each device sending an event every 5 seconds, for a total throughput of 2000 events/second. That's on the low end for an IoT scenario. Even if you start with a small number of devices, that number can grow over time. The price of success is ever greater demands on the system.

**Low latency**. Many IoT solutions need to operate in near-real-time, which means minimizing the latency introduced by message ingestion and processing.

**Multiple event receivers**. Typically you will process the same device data in multiple ways, using more than one data processing pipeline. The previous chapter introduced the concept of hot, warm, and cold paths. These paths will consume the data at different rates. The hot path typically uses stream processing, while the cold path uses batch processing.

**Durable storage**. Messages should be retained for a period of time, so they can be reprocessed. 

**Device authentication**. The cloud gateway should only accept connections from authenticated devices. There may be thousands or tens of thousands of devices. If devices share the same credentials, and one device is compromised, then all the devices are compromised. Instead, every device should have unique credentials, making it possible to revoke individual devices.


## Technology choices

For most solutions, we recommend [Azure IoT Hub](https://docs.microsoft.com/en-us/azure/iot-hub/about-iot-hub), which is specifically designed for IoT scenarios. It provides some important capabilities that most IoT solutions require:

- High-scale event ingestion
- At-least-once delivery semantics
- Multiple independent event consumers, using the same programming model as Azure Event Hubs. 
- Support for cloud-to-device messages.
- Per device authentication and security, including the ability to revoke individual devices.
- Monitoring of device connectivity.
- The ability to route events to different outputs based on filtering criteria
- Ability to capture events directly into storage.

Azure Event Hubs and Apache Kafka are also viable options, as both of these technologies support event streaming at high scale. However, they lack some of the other features listed above, particularly support for per-device authentication. 

For more information about choosing between IoT Hub and Event Hubs, see:

- [Connecting IoT Devices to Azure: IoT Hub and Event Hubs](https://docs.microsoft.com/en-us/azure/iot-hub/iot-hub-compare-event-hubs)
- [Choose between Azure services that deliver messages](https://docs.microsoft.com/en-us/azure/event-grid/compare-messaging-services)

IoT Hub has a built-in endpoint that is compatible with the Azure Event Hubs API. Messages can also be [captured](https://docs.microsoft.com/en-us/azure/iot-hub/iot-hub-devguide-messages-read-custom) directly into blob storage.

Generally you should use the Event Hubs endpoint for stream processing (hot and warm path), and blob storage for batch processing cold path).

![](./_images/iot-hub-routing.png)

When using the Event Hubs endpoint, it's important to understand the streaming model: 

- Event consumers (readers) read the event stream independently at their own pace. Although multiple consumers can read a stream, each reads the stream independently. A consumer is responsible for keeping track of its current position in the stream.

- A consumer writes its current position to persistent storage at some predefined interval. That way, if the consumer experiences a fault, a new instance can restart at the last recorded position. This process is called checkpointing. In practice, you rarely need to write any checkpointing code, because it's handled by client SDKs, or by using built-in integration features of Azure. For example, Azure Stream Analytics can read from Event Hubs, which doesn't require writing any code.

- An event hub uses partitions to increase throughput. Horizontal scale is achieved by assigning a separate reader to each partition and reading the partitions in parallel. Incoming messages are partitioned based on the device ID. All of the messages from a particular device will always arrive on the same partition, but a single partition will have messages from multiple devices.

For more information, see [Event Hubs features overview](https://docs.microsoft.com/en-us/azure/event-hubs/event-hubs-features).

## Scalability considerations

When you look at throughput, you need to consider how fast IoT Hub can ingest messages, and how fast you can process the messages as they arrive. 

### Ingestion

Each IoT hub is provisioned with a certain number of units in a specific tier. The tier and number of units determine the maximum daily quota of messages that devices can send to the hub. For more information, see [IoT Hub quotas and throttling](https://docs.microsoft.com/en-us/azure/iot-hub/iot-hub-devguide-quotas-throttling).

You can scale up a hub without interrupting existing operations. However, IoT Hub does not currently support auto-scaling. You should monitor the [quota metrics](https://docs.microsoft.com/en-us/rest/api/iothub/iothubresource/getquotametrics) for the hub, and manually scale the hub if needed. 

You can open a support request to increase the maximum quota for a hub. If you still need more throughput than a single IoT Hub instance can provide, you will need to create multiple IoT Hub instances. You can use the IoT Hub Device Provisioning Service to automate the process of assigning devices to hubs, without needing to pre-allocate devices to hubs. For more information, see [Provision devices across load-balanced IoT hubs](https://docs.microsoft.com/en-us/azure/iot-dps/tutorial-provision-multiple-hubs). 

Another approach is to use a field gateway to reduce the volume of data from each device.

### Processing

When using Event Hubs to process messages, the number of parallel readers may be a bottleneck. The maximum rate that you can process messages is determined by how fast one reader can read over a single partition. Make sure to create enough IoT Hub partitions for your expected load. Use load testing to validate your throughput. In your load tests, scale to your expected message rate and number of devices.

Processing speed is less of a concern for the cold path, because by definition the cold path doesn't need to process in real time.

## Device protocols

Compared with traditional web applications, the IoT space involves a bewildering assortment of protocols. Often, the choice is dictated by the power and network requirements of the devices, or by the capabilities of existing devices that are already deployed in the field.

In this guidance, we assume that devices can connect securely to the Internet, or else connect to a field gateway that can. Given that, we can categorize protocols according to the [Internet protocol suite](https://en.wikipedia.org/wiki/Internet_protocol_suite):

- Link layer (WiFi, ethernet, ZigBee)
- Internet layer (IPv4, IPv6, 6LoWPAN)
- Transport Layer (UDP, TCP)
- Application Layer (HTTP, MQTT, CoAP, XMPP, AMQP)

The link layer and internet layer are concerned with how devices physically send data packets over the internet. As such, they don't directly affect the cloud backend. However, the choice of transport layer and application protocol will have implications for the backend. Azure IoT Hub natively supports the MQTT, AMQP, and HTTPS/1.1 protocols.

**HTTP/1.1** uses a synchronous request/response model. It is document-centric, using content types to define the representation. 

- Because it is relatively heavy weight and uses synchronous requests, HTTP/1.1 is not an optimal protocol for streaming messages at high throughput. 
- HTTP/1.1 does not support server push. For cloud-to-device messages, you would need to use either device polling or Web Sockets.
- One advantage of HTTP is that it's a ubiquitous protocol. 

**MQTT** uses an asynchronous publish/subscribe model. For IoT scenarios, MQTT has a number of advantages for over HTTP:

- MQTT is a very lightweight protocol compared to HTTP. It scales well and is power efficient.
- MQTT uses persistent connections, so a device can connect once and send a stream of messages. 
- MQTT supports quality-of-service (QoS) for unreliable network environments. 
- MQTT supports two-way communication, so it can be used for cloud-to-device messages. 

**AMQP** also supports asynchronous publish/subscribe messaging and bi-directional communication. Comparing AMQP to MQTT:

- AMQP is not as lightweight as MQTT.
- AMQP supports multiplexing message from multiple devices over the same TLS connection. This is useful if you are using a field gateway that establishes a single connection for multiple devices.

MQTT and AMQP are both more efficient for low-latency ingestion than HTTP. If you are using IoT Hub for ingestion, the general recommendation is to use MQTT, unless you need the multiplexing capabilities that AMQP offers.  

One use case for HTTP is for devices that connect infrequently and send a large batch of messages. In this scenario, you might use an HTTP REST endpoint to send each batchdata, rather than using a message broker for ingestion. Note that IoT Hub supports this scenario, using the [file upload feature](https://docs.microsoft.com/en-us/azure/iot-hub/iot-hub-devguide-file-upload).

Two other protocols are worth mentioning in connection to IoT, although IoT Hub currently does not have native support for them.

**HTTP/2**. The HTTP/2 protocol males several improvements over HTTP/1.1. Particularly relevant to IoT scenarios:

- Binary compression of headers, which are more efficient to transmit.
- Support for server push.
- Support for multiplexing requests asynchronously over a single TCP connection. 

That means a device can send a stream of messages over the same TCP connection and receive 

**CoAP**. The protocols discussed so far all use TCP, but TCP sessions are expensive to establish. This can drain battery life if a device does not maintain a persistent connection &mdash; for example, if the device periodically goes to sleep and then wakes up. CoAP was designed for low-power devices and constrained networks. Semantically, it's similar to HTTP, supporting GET, PUT, POST, and DELETE verbs, but it uses UDP instead of TCP. CoAP supports asynchronous requests and response, and uses binary-encoded for headers. That makes it a good choice for power constrained devices or congested WiFi or cellular networks, where TCP will have trouble maintaining a session

These aren't the only application-level protocols commonly found in IoT &mdash; others include STOMP, XMPP, and DDS &mdash; but it gives a picture of the overall landscape. 

If your devices use a protocol that isn't natively supported by IoT Hub, you will need do some protocol translation. Often that can be done with a field gateway. If it's not practical to deploy a field gateway, you can deploy a [protocol gateway](https://docs.microsoft.com/en-us/azure/iot-hub/iot-hub-protocol-gateway) to Azure instead. A protocol gateway is a custom cloud gateway that sits in front of IoT Hub and performs protocol translation.

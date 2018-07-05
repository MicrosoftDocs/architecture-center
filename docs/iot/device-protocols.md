# Device protocols for IoT

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

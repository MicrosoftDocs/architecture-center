## Using field gateways in IoT solutions

Many IoT devices are too constrained to connect directly to the Internet. This includes:

- Devices with limited energy supply, CPU, or storage. 
- Devices with limited battery life.
- Devices that do not support a full IP stack. For example, sensors often use a wireless personal area network protocol such as Zigbee or Bluetooth Low Energy.
- Legacy devices with outdated communication protocols.

In many IoT projects, the devices already exists in the field, and it may not be practical or cost effective to upgrade them. The solution needs to work with the existing devices. 

In that case, devices typically connect to a gateway that acts as bridge between the devices and the cloud. This type of gateway, called a *field gateway* or *device gateway*, is often a dedicated hardware appliance. Usually it's located close to the devices. For example, in a connected factory scenario, the field gateway might be installed on the factory floor. In a connected vehicle scenario, the devices are sensors in the car, and the field gateway is installed inside the vehicle. Usually several devices share the same field gateway.

Even when devices are Internet-capable, there are other reasons to use a field gateway, depending on your solution:

- Devices may not have adequate security or authentication protocols, such as X.509 certificates or trusted platform modules (TPMs).
- Your solution may include heterogeneous devices that support different protocols or message formats, making it complex to ingest the messages directly at the cloud gateway.
- There might be too many devices for your network to handle the number of simultaneous connections.
- Devices might generate a large volume of data, which must be filtered or aggregated before it reaches the cloud.

In its simplest form, a field gateway acts as proxy, doing nothing else besides forwarding the device messages to the cloud endpoint. However, most field gateways provide additional functionality.

Security:

- Encrypt the data that is sent to the cloud.
- Manage authentication and device credentials.

Message processing:

- Perform protocol translation.
- Aggregate or filter data. For example, a sensor might send telemetry readings every second, but the gateway might poll the value once every 30 seconds.
- Optimize network traffic by using batching or compression.
- Add a timestamp to messages, for devices that don’t have a precise or accurate clock. 

Stream processing:

- Use a rules engine or stream processing engine to analyze the stream. For example, the gateway might run an anomaly detection algorithm, and send only anomalous readings to the cloud.
- Perform time-critical processing that needs very low latency, such as raising alerts in real time.   

Resiliency: 

- Store device messages when the network is unavailable, so they can be sent later.
- Perform mission-critical processing that can't afford to be interrupted by network connectivity issues.


## Issues and considerations

A gateway can become a single point of failure. The gateway should be able to bootstrap and resume if there is a power outage. You might deploy redundant gateways, so the system can fail over if one gateway fails.

The gateway should be extensible. For example, over the lifetime of an IoT solution, you may need to support new network protocols or process the data in new ways. 

Consider how you will manage the gateway. For example:

- Updates. Can you push patch, updates, or configuration changes to the gateway remotely, or do you need to send a technician to the field?
- Monitoring. The gateway should be able to report its own status and the status of the devices. It should log any anomalous activity.

The gateway must be secure. If the gateway is compromised, all of the device data may be compromised.

- Prevent unauthorized requests to the gateway (from outside) using PKI or another mechanism.
- Protect private keys using TPM.
- Secure connections between devices and the gateway.
- Prevent unauthorized devices from connecting to the gateway, using PKI or another mechanism.

Consider how you will manage device identities. In IoT Hub, every device has an identity, which is stored in a [registry](https://docs.microsoft.com/en-us/azure/iot-hub/iot-hub-devguide-identity-registry) within IoT Hub. The device authenticates with IoT Hub based on credentials in the registry. 

- Devices manage their own identities. The field gateway acts as a proxy, passing messages from the devices to the cloud.

- The field gateway manages identities for each device, including credentials and authentication.

- The field gateway has an identity. IoT Hub sees the field gateway as a "device" and doesn't know anything about the actual devices that are upstream from the field gateway. In this case, the message payload should include the device ID, otherwise there's no way to distinguish the messages. For more information, see [How an IoT Edge device can be used as a gateway](https://docs.microsoft.com/en-us/azure/iot-edge/iot-edge-as-gateway).
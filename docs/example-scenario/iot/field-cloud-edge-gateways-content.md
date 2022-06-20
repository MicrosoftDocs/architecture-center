IoT devices can connect to the IoT platform directly, or through *IoT Edge gateways* that implement intelligent capabilities. Edge gateways enable functionality like:
- Aggregating or filtering device events before they're sent to the IoT platform
- Localized decision-making
- [Protocol and identity translation](/azure/iot-edge/iot-edge-as-gateway) on behalf of devices

There are two types of edge gateways, *field* or [IoT Edge](/azure/iot-edge/iot-edge-as-gateway), and *cloud* or [protocol](/azure/iot-hub/iot-hub-protocol-gateway) gateways.

![A diagram illustrating the flow of events, commands, and protocols as they are routed through a field or cloud edge gateway to the Azure IoT Platform.](media/field-edge-gateways.svg)

- IoT Edge *field gateways* are located close to devices on-premises, and connect to the IoT platform to extend cloud capabilities into devices. IoT Edge devices can act as communication enablers, local device control systems, and data processors for the IoT platform. IoT Edge devices can run cloud workflows on-premises by using [Edge modules](/azure/iot-edge/iot-edge-modules), and can communicate with devices even in offline scenarios.

- *Protocol* or *cloud gateways* enable connecting existing and diverse device populations to IoT solutions by hosting device instances and enabling communication between devices and the IoT platform. Cloud gateways can do protocol and identity translation to and from the IoT platform, and can execute additional logic on behalf of devices.

## Next steps
- For detailed documentation on using IoT Edge as a Field Gateway, refer to the following links:
    - [Using IoT Edge As a Field Gateway](/azure/iot-edge/iot-edge-as-gateway?view=iotedge-2018-06)
    - How to configure an [IoT Edge Gateway](/azure/iot-edge/how-to-create-transparent-gateway?view=iotedge-2018-06)
- For detailed documentation using Azure IoT Hub as a Cloud Gateway, refer to the following links:
	- What is [Azure's Cloud Gateway](../../guide/iiot-guidance/iiot-architecture.yml#cloud-gateway)?
	- What is [Azure IoT Hub](/azure/iot-hub/about-iot-hub)?
	- How do I add [additional protocol support](/azure/iot-hub/iot-hub-protocol-gateway) for Azure IoT Hub?

## Related resources

- For overall guidance, refer to the following links:
    - [IoT Solutions Conceptual Overview](./introduction-to-solutions.yml)
    - [IoT Reference Architecture](../../reference-architectures/iot.yml)

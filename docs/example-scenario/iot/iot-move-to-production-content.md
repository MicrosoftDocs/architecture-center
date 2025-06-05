This article provides a list of key considerations for transitioning an Azure IoT Hub-based solution to a production environment.

## Use deployment stamps

Deployment stamps are discrete units of core solution components that support a defined number of devices. A single unit is known as a *stamp* or *scale unit*. A stamp might consist of a set device population, an IoT hub, an event hub or other routing endpoint, and a processing component. Each stamp supports a defined device population. You choose the maximum number of devices that the stamp can hold. As the device population grows, you add stamp instances instead of independently scaling up different parts of the solution.

If you move a single instance of your IoT Hub-based solution to production instead of adding stamps, you might encounter the following limitations:

- **Scale limits.** Your single instance can experience scaling limits. For example, your solution might use services that have limits on the number of inbound connections, host names, Transmission Control Protocol sockets, or other resources.

- **Non-linear scaling or cost.** Your solution components might not scale linearly with the number of requests or the volume of ingested data. Instead, some components might experience performance degradation or increased costs after a threshold is reached. In such cases, scaling out by adding stamps might be a more effective strategy than increasing capacity.

- **Separation of customers.** You might need to isolate specific customers' data from other customers' data. You can group customers that have higher resource demands on different stamps.

- **Single and multitenant instances.** You might have several large customers who need their own independent instances of your solution. Or you might have a pool of smaller customers who can share a multitenant deployment.

- **Complex deployment requirements.** You might need to deploy updates to your service in a controlled manner and deploy to different stamps at different times.

- **Update frequency.** You might have customers who are tolerant of frequent system updates, while other customers might be risk-averse and want infrequent updates to your service.

- **Geographical or geopolitical restrictions.** To reduce latency or comply with data sovereignty requirements, you can deploy some of your customers into specific regions.

To avoid the previous problems, consider grouping your service into multiple stamps. Stamps operate independently of each other and can be deployed and updated independently. A single geographical region might contain a single stamp or might contain multiple stamps to enable horizontal scale-out within the region. Each stamp contains a subset of your customers.

For more information, see [Deployment Stamps pattern](/azure/architecture/patterns/deployment-stamp).

## Use back-off when a transient fault occurs

All applications that communicate with remote services and resources must be designed to handle transient faults. This need is especially crucial in cloud environments, where connectivity increases the likelihood of encountering these faults. Transient faults include:

- Momentary loss of network connectivity to components and services.
- Temporary unavailability of a service.
- Time-outs that occur when a service is busy.
- Collisions that occur when devices transmit simultaneously.

These faults are often self-correcting, and if the action is repeated after a suitable delay, it's likely to succeed. However, determining the appropriate intervals between retries is difficult. Typical strategies use the following types of retry intervals:

- **Exponential back-off.** The application waits a short time before the first retry, then progressively increases the wait time between subsequent attempts. For example, it might retry the operation after 3 seconds, 12 seconds, or 30 seconds.

- **Regular intervals.** The application waits for the same period of time between each attempt. For example, it might retry the operation every 3 seconds.

- **Immediate retry.** Sometimes a transient fault is brief and can occur because of events like a network packet collision or a spike in a hardware component. In this scenario, retrying the operation immediately is appropriate. If the fault clears by the time the application assembles and sends the next request, the operation can succeed. However, there should never be more than one immediate retry attempt. If the immediate retry fails, switch to alternative strategies, such as exponential back-off or fallback actions.

- **Randomization.** Any of the previous retry strategies might include a randomization element to prevent multiple instances of the client from sending subsequent retry attempts at the same time.

Avoid the following anti-patterns:

- Don't include duplicated layers of retry code in implementations.

- Never implement an endless retry mechanism.

- Never perform an immediate retry more than one time.

- Avoid using a regular retry interval.

- Prevent multiple instances of the same client, or multiple instances of different clients, from sending retries at the same time.

For more information, see [Transient fault handling](/azure/architecture/best-practices/transient-faults).

## Use zero-touch provisioning

Provisioning is the process of enrolling a device into IoT Hub. Provisioning registers a device with IoT Hub and specifies the attestation mechanism that it uses. You can use the [IoT Hub device provisioning service (DPS)](/azure/iot-dps/) or provision directly via IoT Hub Registry Manager APIs. Using DPS provides the advantage of late binding, which allows the removal and reprovisioning of field devices to IoT Hub without changes to the device software.

The following example shows how to implement a test-to-production environment transition workflow by using DPS.

:::image type="complex" border="false" source="./media/late-binding-with-dps.png" alt-text="A diagram that shows how to implement a test-to-production environment transition workflow by using DPS." lightbox="./media/late-binding-with-dps.png":::
   The diagram contains several icons. An arrow points from the Operator process section to the IoT DPS section. A Device provisioning request is sent to IoT DPS from the Device requests hub. Two arrows extend from IoT DPS. One red arrow points to the test hub and one black arrow points to the production hub. Two arrows extend from the Device requests hub. One red arrow points to the test hub and one black arrow points to the production hub.
:::image-end:::

1. The solution developer links both the test and production IoT clouds to the provisioning service.

1. The device implements the DPS protocol to find the IoT hub, if it's no longer provisioned. The device is initially provisioned to the test environment.

1. The device is registered with the test environment, so it connects there and testing occurs.

1. The developer reprovisions the device to the production environment and removes it from the test hub. The test hub rejects the device the next time that it reconnects.

1. The device connects and renegotiates the provisioning flow. DPS directs the device to the production environment and the device connects and authenticates there.

For more information, see [Overview of IoT Hub device provisioning service](/azure/iot-dps/about-iot-dps#provisioning-process).

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal authors:

- [Matthew Cosner](https://www.linkedin.com/in/matthew-cosner-447843225/) | Principal Software Engineering Manager
- [Ansley Yeo](https://www.linkedin.com/in/ansleyyeo/) | Principal Program Manager

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next step

- [Browse Azure architectures](/azure/architecture/browse/)

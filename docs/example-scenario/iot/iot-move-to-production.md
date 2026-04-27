---
title: Move an IoT Hub-Based Solution from Test to Production
description: Learn best practices for moving an IoT Hub-based solution to production, including deployment stamps, transient fault handling, and zero-touch provisioning.
author: dominicbetts
ms.author: dobett
ms.date: 04/21/2026
ms.topic: concept-article
ms.subservice: architecture-guide
ms.custom: arb-iot
---

# Move an IoT Hub-based solution from test to production

This article provides key considerations that help you transition an Azure IoT Hub-based solution to a production environment.

## Use deployment stamps

Deployment stamps are discrete units of core solution components that support a defined number of devices. A single unit is known as a *stamp* or *scale unit*. A stamp might consist of a specific device population, an IoT hub, an event hub or other routing endpoint, and a processing component. Each stamp supports a defined device population. You choose the maximum number of devices that the stamp can hold. As the device population grows, you add stamp instances instead of independently scaling up different parts of the solution.

If you move a single instance of your IoT Hub-based solution to production instead of adding stamps, you might encounter the following limitations:

- **Scaling limits:** Your single instance can experience scaling limits. For example, your solution might use services that limit the number of inbound connections, host names, Transmission Control Protocol (TCP) sockets, or other resources.

- **Nonlinear scaling or cost:** Your solution components might not scale linearly with the number of requests or the volume of ingested data. Instead, some components might experience performance degradation or increased costs after they reach a threshold. In these scenarios, you might find that scaling out by adding stamps is more effective than increasing capacity.

- **Separation of customers:** You might need to isolate specific customers' data from other customers' data. You can group customers that have higher resource demands on different stamps.

- **Single-tenant and multitenant instances:** You might have several large customers that need their own independent instances of your solution. Or you might have a pool of smaller customers that can share a multitenant deployment.

- **Complex deployment requirements:** You might need to deploy updates to your service in a controlled manner and deploy updates to different stamps at different times.

- **Update frequency:** You might have customers that can tolerate frequent system updates, while other customers might want infrequent updates to your service.

- **Geographical or geopolitical restrictions:** To reduce latency or to comply with data sovereignty requirements, you can deploy some of your customers into specific regions.

To avoid these problems, consider grouping your service into multiple stamps. Stamps operate independently of each other so that you can deploy and update them independently. A single geographical region might contain a single stamp or multiple stamps to enable horizontal scale-out within the region. Each stamp contains a subset of your customers.

For more information, see [Deployment Stamps pattern](/azure/architecture/patterns/deployment-stamp).

## Use back-off when a transient fault occurs

You must design all applications that communicate with remote services and resources to handle transient faults. This capability is especially crucial in cloud environments where connectivity increases the likelihood that you encounter these faults. The following list provides examples of transient faults:

- Momentary loss of network connectivity to components and services
- Temporary unavailability of a service
- Timeouts that occur when a service is busy
- Collisions that occur when devices transmit simultaneously

Transient faults typically self-correct. If you repeat the action after a suitable delay, it's likely to succeed. However, determining the appropriate intervals between retries is difficult. Typical strategies use the following types of retry intervals:

- **Exponential back-off:** The application waits a short time before the first retry and then progressively increases the wait time between subsequent attempts. For example, it might retry the operation after 3 seconds, 12 seconds, and 30 seconds.

- **Regular intervals:** The application waits for the same period of time between each attempt. For example, it might retry the operation every 3 seconds.

- **Immediate retry:** Sometimes a transient fault is brief and can occur because of events like a network packet collision or a spike in a hardware component. In this scenario, you can retry the operation immediately. If the fault clears by the time the application assembles and sends the next request, the operation can succeed. However, an application should never attempt more than one immediate retry. If the immediate retry fails, switch to alternative strategies, such as exponential back-off or fallback actions.

- **Randomization:** Any of the preceding retry strategies might include a randomization element to prevent multiple instances of the client from sending subsequent retry attempts at the same time.

We recommend that you take the following actions to avoid antipatterns:

- Don't include duplicated layers of retry code in implementations.

- Never implement an endless retry mechanism.

- Never perform an immediate retry more than once.

- Avoid using a regular retry interval.

- Prevent multiple instances of the same client or multiple instances of different clients from sending retries at the same time.

For more information, see [Transient fault handling](/azure/architecture/best-practices/transient-faults).

## Use zero-touch provisioning

Provisioning enrolls a device into IoT Hub. Provisioning registers a device with IoT Hub and specifies the attestation mechanism that it uses. You can use the [IoT Hub device provisioning service](/azure/iot-dps/) or provision directly via IoT Hub registry manager APIs. The device provisioning service provides the advantage of late binding, which allows you to remove and reprovision field devices to IoT Hub without changing the device software.

For production deployments that support large device fleets, use the IoT Hub device provisioning service as a foundational onboarding pattern. The device provisioning service provides secure, zero-touch provisioning and late binding of devices to IoT Hub instances. You can reprovision devices across environments or scale horizontally without firmware updates. When you incorporate the device provisioning service from the beginning, your solution can:

- Distribute device populations across multiple hubs.

- Support regional deployments.

- Isolate customer environments.

- Transition devices across deployment stamps without requiring device reprovisioning or manufacturing changes later in the life cycle.

For more information, see [Best practices for large-scale IoT device deployments](/azure/iot-dps/concepts-deploy-at-scale).

The device provisioning service also simplifies device transitions between test and production environments. The following example shows how to use the device provisioning service to implement a test-to-production environment transition workflow.

:::image type="complex" border="false" source="./media/late-binding-with-device-provisioning-service.png" alt-text="A diagram that shows how to use the device provisioning service to implement a test-to-production environment transition workflow." lightbox="./media/late-binding-with-device-provisioning-service.png":::
   The diagram consists of icons that represent IoT Hub device provisioning service, a test hub, a production hub, and a provisioned endpoint. An arrow points from a box labeled operator process to the IoT Hub device provisioning service icon. Another arrow that represents device provisioning requests points from the endpoint to the IoT Hub device provisioning service icon. Arrows point from the IoT Hub device provisioning service icon to the test hub and to the production hub. Arrows also point from the endpoint to the test hub and to the production hub.
:::image-end:::

1. The solution developer links the test and production IoT clouds to the provisioning service.

1. If the IoT hub isn't provisioned, the device implements the device provisioning service protocol to find the IoT hub. The device is initially provisioned to the test environment.

1. The device is registered with the test environment, so it connects to that environment and testing occurs.

1. The developer reprovisions the device to the production environment and removes it from the test hub. The test hub rejects the device the next time that it reconnects.

1. The device connects and renegotiates the provisioning flow. The device provisioning service directs the device to the production environment, and the device connects and authenticates in that environment.

For more information, see [Overview of the IoT Hub device provisioning service](/azure/iot-dps/about-iot-dps#provisioning-process).

## Prepare for upcoming identity and life cycle management capabilities

IoT Hub evolves to support device life cycle and credential management capabilities through Azure Device Registry integration and Microsoft-backed operational certificate issuance.

Migration of existing IoT Hub deployments into these new identity and certificate life cycle management models isn't supported in preview. However, you can prepare for adoption by implementing the following architectural practices:

- Use the device provisioning service for device onboarding instead of direct hub registry enrollment.
- Colocate IoT Hub and device provisioning service resources within the same Azure region.
- Separate onboarding credentials from runtime authentication when possible.
- Avoid embedding IoT Hub-specific connection metadata in device firmware.

These practices align device onboarding flows with Device Registry-based identity projection and certificate life cycle workflows. They can reduce future onboarding or reprovisioning requirements when you adopt these capabilities.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal authors:

- [Dominic Betts](https://www.linkedin.com/in/dominicbetts/) | Senior Content Developer
- [Matthew Cosner](https://www.linkedin.com/in/matthew-cosner-447843225/) | Principal Software Engineering Manager
- [Ansley Yeo](https://www.linkedin.com/in/ansleyyeo/) | Principal Program Manager

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next step

- [Browse Azure architectures](/azure/architecture/browse/)

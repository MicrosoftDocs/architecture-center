---
title: Scale out an Azure IoT solution
description: Learn how to scale out your Azure IoT solution to support millions of devices.
author: MikeBazMSFT
ms.author: micbaz
ms.date: 04/14/2023
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
products:
  - azure-iot
  - azure-iot-dps
  - azure-iot-hub
  - azure-iot-sdk
categories:
  - iot
---

# Scale out an Azure IoT solution

Scaling an IoT solution to support millions, or even tens or hundreds of millions, of devices isn't a straightforward task. There are many different factors to consider and different ways to solve the issues that arise at those scales.

This article summarizes these concerns and provides ways you can address them in a successful deployment. For this article, we focus only on Azure platform as a service (PaaS) services. The two primary services are:

- [Azure IoT Hub](/azure/iot-hub/), a managed service hosted in the cloud that acts as a central message hub for communication between an IoT application and its attached devices.
- [Azure IoT Hub device provisioning service (DPS)](/azure/iot-dps/), a helper service for IoT Hub that enables zero-touch, just-in-time provisioning to the correct IoT hub without requiring human intervention.

Other related services are available too, such as [Device Update for IoT Hub](/azure/iot-hub-device-update/). You can use Device Update for IoT Hub to deploy over-the-air (OTA) updates for your IoT devices. This article touches on those services as well, but its primary focus is IoT Hub and DPS.

Most Azure IoT services have service quotas and limits with respect to the amount of data that's allowed to flow to the service in a set time period. Depending on the type, limits might be expressed as:

- Discrete operations per second
- Connections per second
- New parallel operations per second

These limits are listed in the [Azure documentation](/azure/azure-resource-manager/management/azure-subscription-service-limits) by service. For example, there's a soft (adjustable) limit of [1,000,000 device registrations](/azure/azure-resource-manager/management/azure-subscription-service-limits#:~:text=Maximum%20number%20of%20registrations) per DPS instance. These limits, combined with your specific requirements, guide your design choices.

Azure IoT services are regional, even the services that have global endpoints. So the decisions you make for device location, data location, and metadata location are important inputs in your design.

## General resiliency design

Before reviewing service-specific resiliency concepts, let's first review shared resiliency concepts that apply across all services and implementations. Any production-distributed solution, whether it's on-premises or in the cloud, must be able to recover from transient (temporary) faults. Transient faults are sometimes considered more likely in a cloud solution because of:

- Reliance on an external provider.
- Reliance on the network connectivity between the device and cloud services.
- Implementation limits of cloud services.

Different factors can affect the network connectivity of a device:

- **The power source of a device**. Battery-powered devices or devices powered by transient sources, such as solar or wind, might have less network connectivity than full-time line-powered devices.
- **The location of a device**. Devices that are in urban factory settings likely have better network connectivity than devices that are in isolated field environments.
- **The location stability of a device**. Mobile devices likely have less network connectivity than fixed-location devices.

Furthermore, all these concerns also affect the timing of device availability and connectivity. For example, devices that are line-powered but common in dense, urban environments (such as smart speakers) might see a large number of devices go offline all at once, and then come back online all at once. Possible scenarios include:

- A blackout, during which 1 million devices might all go offline at the same time and come back online simultaneously due to power grid loss and reconnection.
- A short-timeframe, large-scale onboarding, such as "[Black Friday](https://www.merriam-webster.com/dictionary/Black%20Friday)" or Christmas, when many consumers are powering on devices for the first time in a relatively short period of time.
- Scheduled device updates, when many devices receive an update in a short time window and all of them reboot with the new update at approximately the same time.

Because of the "many devices booting at once" scenario, cloud service concerns can affect even scenarios with assumed near-100% network connectivity, such as throttling (limiting the traffic allowed to a service).

Although these scenarios might be considered as purely consumer scenarios, the same issues can arise in industrial scenarios. For example, consider a blackout scenario with connected, line-powered thermostats reporting back to a real-estate management company.

As described at the Azure Architecture Center, [transient fault handling](/azure/architecture/best-practices/transient-faults) requires that you have a retry capability built into your device code. There are multiple retry strategies (for example, exponential backoff with randomization, also known as *exponential backoff with jitter*) described in [Transient fault handling](/azure/architecture/best-practices/transient-faults). This article refers to those patterns without any further explanation. So refer to that page if you aren't familiar with them.

When you consider scaling cloud services, it’s important to remember the [difference between](/azure/app-service/manage-scale-up) *scaling up* and *scaling out*. Scaling up refers to making instances larger so that they can handle a larger workload in the existing instances. Scaling out refers to adding more instances. As mentioned earlier, this article focuses on scaling out.

## Common anti-patterns

Before we explain how to solve problems in these large-scale scenarios, let's first review some scalability anti-patterns that we've seen. Common anti-patterns include:

- Failure to include OTA update or field configuration capabilities
- Failure to use an appropriate high-availability solution for services
- Hard-coded Azure IoT Hub device provisioning service ID scopes and endpoint addresses (URLs)
- Failure of devices to include appropriate retry mechanisms for provisioning failures
- Attempting a full reprovision at every boot, without persistence of the results and without understanding the implications of doing so for the specific device use case

## Scaling out IoT Hub device provisioning service

The [DPS documentation](/azure/iot-dps/how-to-reprovision#send-a-provisioning-request-from-the-device) includes the following statement:

   *We recommend not provisioning on every reboot of the device, as it can cause some issues when reprovisioning several thousands or millions of devices at once. Instead, you should attempt to use the Device Registration Status Lookup API and try to connect with that information to IoT Hub.*

For small use cases, it might seem reasonable to provision at every reboot because it's the shortest path to deployment. However, when scaling up to millions of devices, DPS can become a bottleneck given [its default limit of 200 registrations per minute per service instance](/azure/iot-dps/about-iot-dps#quotas-and-limits). Even device registration status lookup can be a bottleneck, because it has a limit of 5-10 polling operations per second. Provisioning results are usually a static mapping to an IoT hub. So, unless your requirements include automated reprovisioning requests, it's best to perform them only on demand. Although this limit is a soft limit, and it can be increased on a case-by-case basis by [contacting Microsoft Support](/azure/iot-dps/about-iot-dps#quotas-and-limits), the increase isn't to the scale of tens of thousands of devices per minute. So scaling out to multiple DPS instances is the only way to support these kinds of scenarios.

There's also a soft limit of [10 DPS instances per Azure subscription](/azure/iot-dps/about-iot-dps#quotas-and-limits). This limit also can be adjusted on a case-by-case basis but changing the limit might require [proper governance procedures](https://aka.ms/FTAISVGovernance) to be in place for Azure subscription management.

Another limit is the soft limit of [a maximum of 1 million device registrations per service instance](/azure/iot-dps/about-iot-dps#quotas-and-limits). Although this is a soft limit, an undocumented and non-specific hard limit applies in practical terms. For example, for a scale of 5 million or more devices, realistically, the implementation requires multiple DPS instances to support the level of scalability that’s required.

Service instances for DPS are geographically located, but by default have a global public endpoint. Specific instances are accessed through [ID scope](/azure/iot-dps/concepts-service#id-scope). Because instances are in specific regions and each instance has its own ID scope, you should be able to configure ID scope for your devices. There are several ways you can approach this situation. Your options can be summarized in two broad categories: zero-touch provisioning and low-touch provisioning.

### Zero-touch provisioning

For zero-touch (automated) provisioning, the proven best practice is for the device to request a DPS ID scope from a web API, which understands and balances devices across the horizontally scaled-out DPS instances. This action makes the web app a critical part of the provisioning process and so it must be scalable and highly available. More information on this design is presented later in this article.

There are two primary variations on this design. The first version uses a custom provisioning API that manages the mapping of the device to the appropriate DPS pool, which in turn maps (through standard DPS [load balancing mechanisms](/azure/iot-dps/how-to-use-allocation-policies)) to the appropriate IoT Hub instance:

:::image type="content" source="media/zero-touch-provisioning-direct-dps-access.png" alt-text="This diagram shows an example of zero-touch automated provisioning with direct DPS access." lightbox="media/zero-touch-provisioning-direct-dps-access.png" border="false":::

1. The device makes a request to a provisioning API hosted in an Azure App Service to request a DPS ID scope. The provisioning API checks with its persistent database to see which instance is best to assign the device to, based on existing device inventory, and returns the DPS ID scope. In this case, the database proposed is an Azure Cosmos DB instance with multi-master write enabled (for cross-region high availability) that stores each device's assigned DPS. This database can then be used for tracking utilization of the DPS instances for all appropriate metrics (such as provision requests per minute, total provisioned devices, and so on). This database also allows a reprovisioning to be supplied with the same DPS ID scope when appropriate. The provisioning API should be authenticated in some way to prevent inappropriate provisioning requests from being serviced.
1. The device then makes a request against DPS with the assigned ID scope. DPS returns details to the device for which IoT hub it should be assigned to.
1. The device then should store the ID scope and IoT hub connection information in persistent storage, ideally in a secured storage location (because the ID scope is part of the authentication against the DPS instance). The device then uses this IoT hub connection information for further requests into the system.

The second design moves the DPS call to the provisioning API. In this model, the device authentication against DPS is contained in the provisioning API, as is most of the retry logic. This process allows more advanced queuing scenarios and potentially simpler provisioning code in the device itself.

:::image type="content" source="media/zero-touch-provisioning-isolated-dps-access.png" alt-text="This diagram shows an example of zero-touch automated provisioning with isolated DPS access." lightbox="media/zero-touch-provisioning-isolated-dps-access.png" border="false":::

1. The device makes a request to a provisioning API that’s hosted in an instance of Azure App Service. The provisioning API checks with its persistent database to see which instance is best to assign the device to based on existing device inventory, and then it determines the DPS ID scope. In this case, the database that’s proposed is an Azure Cosmos DB instance with multi-master write enabled (for cross-region high availability) that stores each device's assigned DPS. This database can then be used for tracking utilization of the DPS instances for all appropriate metrics (such as provision requests per minute, total provisioned devices, and so on). This database also allows a reprovisioning to be supplied by using the same DPS ID scope when appropriate. The provisioning API should be authenticated in some way to prevent inappropriate provisioning requests from being serviced.
1. The provisioning API performs the DPS provisioning process with the assigned ID scope, effectively acting as a DPS proxy.
1. The DPS results are forwarded to the device.
1. The device stores the IoT hub connection information in persistent storage, ideally in a secured storage location because the ID scope is part of the authentication against the DPS instance. The device uses this IoT hub connection information for later requests into the system.

### Low-touch provisioning

In some cases, such as in consumer-facing scenarios or with field deployment team devices, a common choice is to offer low-touch (user-assisted) provisioning. Examples of low-touch provisioning include a mobile application on an installer’s phone or a web-based application on a device gateway. In this case, the proven best practice is to perform the same operations as in the zero-touch provisioning process, but the provisioning application transfers the details to the device.

:::image type="content" source="media/low-touch-provisioning-direct-dps-access.png" alt-text="This diagram shows an example of low-touch (user-assisted) provisioning with direct DPS access." lightbox="media/low-touch-provisioning-direct-dps-access.png" border="false":::

1. The end administrator launches a device configuration app, which connects to the device.
1. The configuration app connects to a provisioning API that’s hosted in an instance of Azure App Service to request a DPS ID scope. The provisioning API checks its persistent database to see which instance is best to assign the device to based on existing device inventory, and returns the DPS ID scope. In this case, the database proposed is an Azure Cosmos DB instance with multi-master write enabled (for cross-region high availability) that stores each device's assigned DPS. This database can then be used for tracking utilization of the DPS instances for all appropriate metrics (such as provision requests per minute, total provisioned devices, and so on). This database also allows a reprovisioning to be supplied with the same DPS ID scope when appropriate. The provisioning API should be authenticated in some way to prevent inappropriate provisioning requests from being serviced.
1. The app returns the provisioning ID scope to the device.
1. The device makes a request against DPS with the assigned ID scope. DPS returns details to the device for which IoT hub it should be assigned to.
1. The device persists the ID scope and IoT hub connection information to persistent storage, ideally in a secured storage location because the ID scope is part of the authentication against the DPS instance. The device uses this IoT hub connection information for further requests into the system.

There are other possible variations not detailed in this article. For example, the architecture in the last diagram can be modified by moving the DPS call to the provisioning API, as shown in the second diagram. The goal is to make sure each tier is scalable, configurable, and readily deployable.

## More device best practices

- **Estimate workloads across different parts of the device lifecycle and scenarios within the lifecycle**. Device registration workloads can vary greatly between development phases (pilot, development, production, decommissioning, and end-of-life). In some cases, they can also vary based on external factors, such as the previously mentioned blackout scenario.
- **Support reprovisioning on demand**. This option can be offered through a device command or an administrative user request.
- **Ensure good retry logic strategy**. The device must have appropriate retry algorithms built-in to the device code for both initial provisioning and later reprovisioning, such as the previously mentioned "exponential backoff with randomization." These scenarios might be different for the two different use cases. Initial provisioning, by definition, might need to be more aggressive in the retry process than reprovisioning, depending on the use case. When throttled, DPS returns an [HTTP 429 ("Too many requests")](https://http.cat/429) error code, like most Azure services. The Azure Architecture Center has guidance about [retry](/azure/architecture/patterns/retry) and, more importantly, [anti-patterns to avoid with respect to retry scenarios](/azure/architecture/example-scenario/iot/iot-move-to-production#:~:text=Avoid%20also%20the%20following%20anti%2Dpatterns%3A).
- **Support OTA updates**. Two simple update models are the use of device twin properties with [automatic device management](/azure/iot-hub/iot-hub-automatic-device-management) and the use of simple device commands. For more sophisticated update scenarios and reporting, see the preview of the [Azure Device Update Service](/azure/iot-hub-device-update/).
- **Architect for certificate changes at all layers and all certificate uses**. This recommendation is tied to the OTA update best practice. Certificate rotation must be considered. The IoT Hub DPS documentation touches on  scenario [from a device identity certificate](/azure/iot-dps/how-to-roll-certificates) viewpoint. However, it's important to remember as part of a device solution that other certificates are being used, such as for IoT Hub access, App Service access, and Azure Storage account access. The [root certificate change across the Azure platform](/azure/security/fundamentals/tls-certificate-changes) shows that you must anticipate changes at all layers. Also, use certificate pinning with caution, especially when certificates are outside of the device manufacturer’s control.
- **Consider a reasonable "default" state**. To resolve initial provisioning failures, have a reasonable disconnected or unprovisioned configuration, depending on the circumstances. If the device has a heavy interaction component as part of initial provisioning, the provision process can occur in the background while the user performs other provisioning tasks. In any case, implied in the use of a default is the use of an appropriate retry pattern and the proper use of the [circuit breaker architectural](/azure/architecture/patterns/circuit-breaker) pattern.
- **Include endpoint configuration capabilities where appropriate**. When the ability to configure the ID scope is in place in your solution, you can also allow configuration of the DPS endpoint or the custom provisioning service endpoint. The DPS endpoint isn't expected to change, but because you can change it on the device, you have greater flexibility. For example, consider the case of automated validation of the device provisioning process through integration testing without direct Azure access, or the possibility of future provisioning scenarios not in place today, such as through a provisioning proxy service.
- **Use the Azure IoT SDK for provisioning**. Whether the DPS calls are on the device itself or in a custom provisioning API, using the [Azure IoT SDK](/azure/iot-develop/about-iot-sdks) means you get some best practices in the implementation "for free," and it allows cleaner support experiences. As the SDKs are all published open source, it's possible to review how they work and to suggest changes.

## Scale stamp considerations

The previous figures all show an architecture pattern commonly referred to as the *scale stamp* or *deployment stamp* pattern, as described in [Deployment stamp patterns](/azure/architecture/patterns/deployment-stamp):

   *The deployment stamp pattern involves provisioning, managing, and monitoring a heterogeneous group of resources to host and operate multiple workloads or tenants. Each individual copy is called a stamp, or sometimes a service unit or scale unit. In a multi-tenant environment, every stamp or scale unit can serve a predefined number of tenants. Multiple stamps can be deployed to scale the solution almost linearly and serve an increasing number of tenants. This approach can improve the scalability of your solution, allow you to deploy instances across multiple regions, and separate your customer data.*

Many factors drive the composition of each scale stamp and the number of scale stamps. These factors include service limits, software as a service (SaaS) considerations, and high availability and disaster recovery concerns.

### Service limits

The first considerations involve the IoT Hub and DPS limits as mentioned previously.

- [IoT Hub has limits](/azure/azure-resource-manager/management/azure-subscription-service-limits#iot-hub-limits) at the instance level and the subscription level. For example, in the S1 Standard SKU, there's currently a limit of 80 million messages per day (400,000 messages per unit and 200 units). This limit is a per-instance limit. IoT Hub also has a limit of 50 IoT Hub instances per Azure subscription.
- [DPS also has limits](/azure/iot-dps/about-iot-dps#quotas-and-limits) at the instance level and the subscription level. For example, there's a limit of 1 million device registrations per DPS instance, and a limit of 10 instances per Azure subscription.

As described previously, some of these limits (such as the number of device registrations per DPS instance) are soft limits. Microsoft Support can increase them [on a case-by-case basis](/azure/iot-dps/about-iot-dps#quotas-and-limits). Some of these limits (such as the maximum number of linked IoT Hhbs for a particular DPS instance) are hard limits, meaning they can't be increased. For limits, which are soft limits with IoT Hub and DPS, generally the hard limits aren't documented and are handled case-by-case. However, it's reasonable to expect that the hard limits are a relatively low multiplier of the soft limits.

Experience suggests that for many solutions, the first throttling concerns appear with DPS, given the relatively low soft limit of 200 provisioning requests per minute. Therefore, the architectures given in the figures all include a preprovisioning, load-balancing instance of App Service.

### SaaS considerations

The next consideration applies only to the model of an independent software vendor (ISV) that’s using a SaaS. In that case, it's necessary to consider how customer data is segregated for each software customer. The customer might not be the actual end user. An example is a smart TV platform. The platform developer's customer is a television vendor, but the end user is the consumer who purchases the TV. This scenario leads to a natural segregation of DPS and IoT Hub instances. So the provisioning service must also have a customer identity that’s indicated through a unique endpoint or as part of the device authentication process.

### High availability and disaster recovery

Another consideration involves high availability and disaster recovery. IoT Hub is a geo-redundant service, and DPS stores its data in a single region. Although it might seem like regional redundancy is restricted in this scenario, it's important to realize that a single IoT hub can be linked to multiple DPS instances. This scenario allows for regional redundancy because the DPS instances can be deployed across regions in geographically oriented stamps. Similarly, the Azure App Service instance in the first figure can be deployed in multiple regions with a tool like [Azure Traffic Manager](/azure/traffic-manager/traffic-manager-overview) or the new [cross-region load balancer](/azure/load-balancer/cross-region-overview).

## Provisioning API considerations

The provisioning API described is a key best practice for scalability and resiliency. As described previously, this API needs a backing metadata store like Azure Cosmos DB. At these scale levels, it's best to implement a globally available and resilient design pattern. The [geode pattern](/azure/architecture/patterns/geodes) is a good pattern for this API and backing data store. The Azure Cosmos DB built-in multi-master, geo-redundant capabilities and latency guarantees make it an excellent choice for this scenario.

The key responsibilities of this API include:

- **Serve the DPS ID scope**. This interface can be a GET request. Remember that physical devices or the management application connect to this interface.
- **Support the device lifecycle**. A device might need to be reprovisioned or an unexpected event might occur. At a minimum, it's key to maintain the DeviceID value and assigned DPS for a device. When the device ID and DPS are consistent, you can deprovision from the assigned DPS and reprovision on another DPS. Or if a device's lifecycle is over, you can completely remove it from the system.
- **Load balance systems**. By using the same metadata regarding DeviceID and DPS, it's simpler to determine the current load on each subsystem, and then use that information to better balance devices across the horizontally scaled-out components.
- **Uphold system security**. As mentioned earlier, the provisioning API should authenticate each request. The recommended best practice is to [use a unique X.509 certificate per device](/azure/iot-dps/concepts-x509-attestation). The certificate can authenticate both against the provisioning API and against the DPS instance, if the architecture supports it. Other methods, like fleet certificates and tokens, are available but are considered less secure. How you implement it and the security implications of an implementation depend on whether you choose to use a zero-touch option or a low-touch option.

## Monitoring

An important part of your overall deployment is to monitor the solution from end to end to make sure that the system performs appropriately. Because this article is explicitly focused on architecture and design and not on the operational aspects of the solution, discussing monitoring in detail is out of scope. However, at a high level, there are monitoring tools built into Azure through [Azure Monitor](/azure/azure-monitor/) to ensure that the solution isn't hitting limits. For details, see these articles:

- [Monitoring Azure IoT Hub](/azure/iot-hub/monitor-iot-hub)
- [Diagnose and troubleshoot disconnects with Azure IoT Hub DPS](/azure/iot-dps/how-to-troubleshoot-dps)
- [Monitor Azure App Service performance - Azure Monitor](/azure/azure-monitor/app/azure-web-apps)

You can use these tools individually or as part of a more sophisticated SIEM solution like [Microsoft Sentinel](/azure/sentinel/overview).

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

**Principal author:**

- [Michael C. Bazarewsky](https://www.linkedin.com/in/mikebaz/) | Senior Customer Engineer

**Other contributors:**

- [Alberto Gorni](https://www.linkedin.com/in/gornialberto/) | Senior Customer Engineer
- [Jesus Barranco](https://www.linkedin.com/in/jesusbar/) | Principal Program Manager
- [David Crook](https://www.linkedin.com/in/drcrook/) | Principal Customer Engineer

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Azure IoT Hub developer guide](/azure/iot-hub/iot-hub-devguide)
- [Overview of Well-Architected Framework for IoT](/azure/architecture/framework/iot/iot-overview)
- [Choose an Internet of Things (IoT) solution in Azure](/azure/architecture/example-scenario/iot/iot-central-iot-hub-cheat-sheet)

## Related resources

- [Get started with Azure IoT solutions](../../reference-architectures/iot/iot-architecture-overview.md)
- [Azure IoT reference architecture](../../reference-architectures/iot.yml)
- [Industrial IoT Patterns](../iiot-patterns/iiot-patterns-overview.yml)

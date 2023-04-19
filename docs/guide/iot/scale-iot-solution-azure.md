---
title: Scale out an Azure IoT solution to support millions of devices
description: Learn how to scale out your Azure IoT solution to support millions of devices.
author: MikeBazMSFT
ms.author: micbaz
ms.date: 04/18/2023
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

# Scale out an Azure IoT solution to support millions of devices

This article describes how to scale an Internet of Things (IoT) solution with a scale-out pattern. The scale-out pattern solves scaling challenges by adding instances to a deployment, rather than increasing instance size. The implementation guidance here shows you how to scale an IoT solution with millions of devices and account for the service and subscription limits in Azure. The article outlines the low-touch and zero-touch deployment models of the scale-out pattern that you can adopt depending on your needs. For more information, see these articles:

- [Best practices for large-scale Microsoft Azure IoT device deployments](/azure/iot-dps/concepts-deploy-at-scale)
- [Azure IoT Hub](/azure/iot-hub/)
- [Azure IoT Hub device provisioning service (DPS)](/azure/iot-dps/)

:::image type="content" source="media/iot-steps_highres.png" alt-text="A diagram that shows the main steps you follow when scaling out your Azure IoT solution." lightbox="media/iot-steps_highres.png" border="false":::

## Gather requirements

You should always gather requirements before implementing a new IoT solution. Starting with the requirements helps ensure the implementation meets your business objectives. The business objectives and operational environment should drive the requirements you need to gather. At a minimum, you should know the following requirements.

**Know the types of devices you want to deploy**. IoT encompasses a wide range of solutions, from simple microcontrollers (MCUs) to midlevel system-on-chip (SOC) and microprocessor (MPU) solutions, to full PC-level designs. The device-side software capabilities directly influence the design of the solution.

**Know how many devices you need to deploy**. Some of the basic principles of implementing IoT solutions apply at all scales. Knowing the scale helps avoid designing a solution that is more complicated than necessary. A solution for 1,000 devices will have some fundamental differences from a solution for 1 million devices. A proof-of-concept (PoC) solution for 10,000 devices might not scale appropriately to 10 million devices if the target scale wasn't considered at the start of the solution design.

Knowing how many devices you need to deploy helps you pick the right Azure IoT service. The scaling for IoT Hub and for IoT Hub device provisioning service (DPS) are different. By design, a single DPS instance can route to multiple IoT Hub instances. So the scale of each service needs to be considered individually with respect to the number of devices. However, limits don't exist in a vacuum. If limits are a concern on one service, they're usually a concern on others. So service limits should be considered as distinct, but related, quotas.

**Document the anticipated device locations**. Include not just physical location, but also power availability and internet connectivity. A solution that's deployed in a single geography (such as only in North America) is designed differently from a global solution. Likewise, an industrial IoT solution deployed in factories with full-time power differs from a fleet management solution that's deployed in motor vehicles with variable power and location. Also, the protocol you use and bandwidth available for device communications, to a gateway or directly to cloud services, affect design scalability at each layer. Hidden in this aspect is connectivity availability. Are the devices expected to remain connected to Azure, or do they run in a disconnected mode for extended periods?

**Investigate data locality requirements**. There might be legal, compliance, or customer requirements on where you can store data (such as telemetry) or metadata (data about the data, such as what devices exist) for the solution. These restrictions, if they exist, are a key input to the solution's geographical design.

**Determine data exchange requirements**. A solution that sends basic telemetry such as “current temperature” once an hour is different from a solution that uploads 1-MB sample files once every 10 minutes. A solution that's primarily a one-way, device-to-cloud (D2C) solution differs from a bidirectional device-to-cloud and cloud-to-device (C2D) solution. Also, product scalability limitations treat message size and message quantity as different dimensions.

**Document expected high availability and disaster recovery requirements**. Like any production solution, full IoT solution designs include availability (uptime) requirements. The design needs to cover both planned maintenance scenarios and unplanned downtime, including user error, environmental factors, and solution bugs. Such designs also need to have a documented [recovery point objective](/azure/cloud-adoption-framework/manage/considerations/protect#recovery-point-objectives-rpo) (RPO) and [recovery time objective](/azure/cloud-adoption-framework/manage/considerations/protect#recovery-time-objectives-rto) (RTO) if a disaster occurs, such as a permanent region loss or malicious actors. Because this article focuses on device scale, there’s only a limited amount of information around high availability and disaster recovery (HA/DR) concerns.

**Decide on a customer tenancy model (if appropriate)**. In a multitenant independent software vendor (ISV) solution, where the solution developer is creating a solution for external customers, the design must take into account how customer data is segregated and managed. The Azure Architecture Center discusses [general patterns](/azure/architecture/guide/multitenant/considerations/tenancy-models) and has [IoT-specific guidance](/azure/architecture/guide/multitenant/approaches/iot).

## Understand Azure IoT concepts

Part of creating the solution is choosing which Azure IoT components (and possibly other supporting Azure services) you use as part of the solution, including the supporting services. A large amount of your effort comes from an architecture viewpoint, which is the focus of this document. Properly using the Azure IoT Hub and Azure IoT Hub DPS services can help you scale your solutions to millions of devices.

### Azure IoT Hub

Azure IoT Hub is a managed service hosted in the cloud that acts as a central message hub for communication between an IoT application and its attached devices. It can be used alone or with Azure IoT Hub DPS.

Azure IoT Hub scales based on the combination of functionality desired and the number of messages per day or data per day desired. Three inputs are used for selecting the scaling of an instance:

- The [tier](/azure/iot-hub/iot-hub-scaling#basic-and-standard-tiers) – free, basic, or standard – determines what capabilities are available. A production instance doesn't use the free tier because it's limited in scale and intended for introduction development scenarios only. Most solutions use the standard tier to get the full capabilities of IoT Hub.
- The [size](/azure/iot-hub/iot-hub-scaling#tier-editions-and-units) determines the message and data throughput base unit for device-to-cloud messages for the IoT hub. The maximum size for an instance of IoT hub is size 3, which supports 300 million messages per day and 1,114.4 GB of data per day, per unit.
- The unit count determines the multiplier for the scale on size. For example, three units support three times the scale of one unit. The limit on size 1 or 2 hub instances is 200 units, and the limit on size 3 hub instances is 10 units.

Other than the daily limits tied to the size and unit count, and the general functionality limits tied to the tier, there are per-second limits on throughput. And there's a limit of 1 million devices per IoT Hub instance as a [soft limit](/azure/azure-resource-manager/management/azure-subscription-service-limits#managing-limits). Although it's a soft limit, there's also a hard limit. Even if you intend to request a limit increase, you should design with the soft limit as your design limit to avoid issues in the future. The data exchange requirements help guide the solution here. For more information, see [other limits](/azure/iot-hub/iot-hub-devguide-quotas-throttling#other-limits).

The requirements for your solution drive the necessary size and number of IoT hubs as a starting point. If you use IoT Hub DPS, Azure helps you distribute your workloads across multiple IoT Hub instances.

### Azure IoT Hub device provisioning service

Azure IoT Hub device provisioning service (DPS) is a helper service for IoT Hub that enables zero-touch, just-in-time provisioning to the right IoT hub without requiring human intervention. It has a soft limit of [10 DPS instances per Azure subscription](/azure/iot-dps/about-iot-dps#quotas-and-limits). You can adjust this limit on a case-by-case basis, but changing the limit might require [proper governance procedures](https://aka.ms/FTAISVGovernance) to be in place for Azure subscription management.

It also has a [soft limit of 1 million registrations](/azure/iot-dps/about-iot-dps#quotas-and-limits) per service instance. Although it's a [soft limit](/azure/azure-resource-manager/management/azure-subscription-service-limits#managing-limits), the service has a hard limit as well. Just like with the IoT hub device limits, you should design with the soft limit as your design limit to avoid issues in the future.

Service instances for DPS are geographically located, but [by default](/azure/iot-dps/virtual-network-support#private-endpoint-limitations) have a global public endpoint. Specific instances are accessed through [ID scope](/azure/iot-dps/concepts-service#id-scope). Because instances are in specific regions and each instance has its own ID scope, you should be able to configure ID scope for your devices.

## Understand shared resiliency concepts

A few critical shared resiliency concepts that you need to consider are transient fault handling, device location impact, and, for ISVs, software as a service (SaaS) data resiliency.

**Understand transient fault handling.** Any production distributed solution, whether it's on-premises or in the cloud, must be able to recover from transient (temporary) faults. Transient faults are sometimes considered more likely in a cloud solution because of:

- Reliance on an external provider.
- Reliance on the network connectivity between the device and cloud services.
- Implementation limits of cloud services.

As described at the Azure Architecture Center, transient fault handling requires that you have a retry capability built into your device code. There are multiple retry strategies (for example, exponential backoff with randomization, also known as *exponential backoff with jitter*) described in [Transient fault handling](/azure/architecture/best-practices/transient-faults). This article refers to those patterns without any further explanation. So refer to that page if you aren't familiar with them.

Different factors can affect the network connectivity of a device:

- **The power source of a device**. Battery-powered devices or devices powered by transient sources, such as solar or wind, might have less network connectivity than full-time line-powered devices.
- **The deployment location of a device**. Devices that are in urban factory settings likely have better network connectivity than devices that are in isolated field environments.
- **The location stability of a device**. Mobile devices likely have less network connectivity than fixed-location devices.

All these concerns also affect the timing of device availability and connectivity. For example, devices that are line-powered but common in dense, urban environments (such as smart speakers) might see a large number of devices go offline all at once, and then come back online all at once. Possible scenarios include:

- A blackout, during which 1 million devices might all go offline at the same time and come back online simultaneously due to power grid loss and reconnection. This scenario applies in both consumer scenarios (such as smart speakers) and business and industrial IoT scenarios (such as connected, line-powered thermostats reporting to a real-estate management company).
- A short-timeframe, large-scale onboarding, such as [Black Friday](https://www.merriam-webster.com/dictionary/Black%20Friday) or Christmas, when many consumers are powering on devices for the first time in a relatively short period of time.
- Scheduled device updates, when many devices receive an update in a short time window and all of them reboot with the new update at approximately the same time.

Because of the "many devices booting at once" scenario, cloud service concerns can affect even scenarios with assumed near-100% network connectivity, such as throttling (limiting the traffic allowed to a service).

Beyond network and quota issues, it’s also necessary to consider Azure service outages. They could be service outages or regional outages. Whereas some services (such as IoT Hub) are geo-redundant, other services (such as DPS) store their data in a single region. Although it might seem like it restricts regional redundancy, it’s important to realize that you can link a single IoT hub to multiple DPS instances.

If regional redundancy is a concern, use the [geode pattern](/azure/architecture/patterns/geodes), which is where you host a heterogeneous group of resources across different geographies. Similarly, a *deployment stamp* (also known as a *scale stamp*) applies this pattern to operate multiple workloads or tenants. For more information, see [Deployment stamp patterns](/azure/architecture/patterns/deployment-stamp). The article includes [IoT-specific examples](/azure/architecture/example-scenario/iot/application-stamps) for deployment stamps and references them in the [multitenant documentation](/azure/architecture/guide/multitenant/approaches/iot).

**Understand device location impact.** When architects select components, they must also understand that most Azure services are [regional](https://azure.microsoft.com/explore/global-infrastructure/data-residency/#select-geography:~:text=Data%20storage%20for%20regional%20services), even the ones like DPS with global endpoints. [Exceptions](https://azure.microsoft.com/explore/global-infrastructure/data-residency/#more-information:~:text=Data%20storage%20for%20non%2Dregional%20services) include [Azure Traffic Manager](/azure/traffic-manager/traffic-manager-overview) and Azure Active Directory. So the decisions you make for device location, data location, and metadata location (data about data: for example, Azure resource groups) are important inputs in your design.

- **Device location**. The requirements for device location affect your regional selection because it affects transactional latency.
- **Data location**. Data location is tied to device location, which is also subject to compliance concerns. For example, a solution storing data for a state in the United States might require data storage in the US [geography](https://azure.microsoft.com/explore/global-infrastructure/geographies/#overview). Data locality requirements might also drive this need.
- **Metadata location**. Although device location doesn't usually affect metadata location, because devices are interacting with solution data and not solution metadata, compliance and cost concerns affect metadata location. In many cases, convenience dictates that the metadata location is the same as the data location for regional services.

The Azure Cloud Adoption Framework includes [guidance on regional selection](/azure/cloud-adoption-framework/migrate/azure-best-practices/multiple-regions).

**Understand independent software vendor (ISV) SaaS concerns.** As an ISV offering SaaS, it's important to meet customers' expectations for availability and resiliency. ISVs must architect Azure services to be highly available, and they must consider the cost of resiliency and redundancy when billing the customer.

Segregate the cost of goods sold (COGS) based on customer data segregation for each software customer. This distinction is important when the end user isn't the same as the customer. For example, in a smart TV platform, the platform vendor's customer might be the television vendor, but the end user is the purchaser of the television. This segregation, driven by the customer tenancy model from the requirements, requires separate DPS and IoT Hub instances. The provisioning service must also have a unique customer identity, which can be indicated through a unique endpoint or device authentication process. For more information, see [IoT multitenant guidance](/azure/architecture/guide/multitenant/approaches/iot).

## Scale out components with supporting services

When discussing scaling IoT solutions, it’s appropriate to look at each service and how they might interrelate. You can scale your IOT solution across multiple DPS instances or using Azure IOT Hub.

### Scaling out across multiple DPS instances

Given DPS service limits, it’s often necessary to expand to multiple DPS instances. There are several ways you can approach device provisionings across multiple DPS instances, which break down into two broad categories: zero-touch and low-touch provisioning.

All the following approaches apply the previously described “stamp” concept for resiliency and for scaling out. This approach includes deploying Azure App Service in multiple regions with a tool such as [Azure Traffic Manager](/azure/traffic-manager/traffic-manager-overview) or the new [cross-region load balancer](/azure/load-balancer/cross-region-overview). For simplicity, it isn't shown in the following diagrams.

**(1) Zero-touch provisioning with multiple DPS instances:** For zero-touch (automated) provisioning, a proven strategy is for the device to request a DPS ID scope from a web API, which understands and balances devices across the horizontally scaled-out DPS instances. This action makes the web app a critical part of the provisioning process, so it must be scalable and highly available. There are three primary variations to this design.

The following diagram illustrates the first option: using a custom provisioning API that manages how to map the device to the appropriate DPS pool, which in turn maps (through standard DPS [load balancing mechanisms](/azure/iot-dps/how-to-use-allocation-policies)) to the appropriate IoT Hub instance:

:::image type="content" source="media/zero-touch-provisioning-direct-dps-access.png" alt-text="A diagram that shows an example of zero-touch automated provisioning with direct DPS access." lightbox="media/zero-touch-provisioning-direct-dps-access.png" border="false":::

1. The device makes a request to a provisioning API hosted in Azure App Service to request a DPS ID scope. The provisioning API checks with its persistent database to see which instance is best to assign the device to, based on existing device inventory, and returns the DPS ID scope. In this case, the database proposed is an Azure Cosmos DB instance with multi-master write enabled (for cross-region high availability) that stores each device's assigned DPS. You can then use this database for tracking DPS instances utilization for all appropriate metrics (such as provision requests per minute, total provisioned devices, and so on). This database also lets you supply a reprovisioning with the same DPS ID scope when appropriate. Authenticate the provisioning API to prevent inappropriate provisioning requests.
1. The device makes a request against DPS with the assigned ID scope. DPS returns details to the device for which IoT hub it should be assigned to.
1. The device stores the ID scope and IoT hub connection information in persistent storage, ideally in a secured storage location (because the ID scope is part of the authentication against the DPS instance). The device then uses this IoT hub connection information for further requests into the system.

This design requires the device software to include the DPS SDK and manage the DPS enrollment process, which is the typical design for an Azure IoT device. But in a microcontroller environment, where device software size is a critical component of the design, it might not be acceptable, which would lead to another design.

**(2) Zero-touch provisioning with a provisioning API:** The second design moves the DPS call to the provisioning API. In this model, the device authentication against DPS is contained in the provisioning API, as is most of the retry logic. This process allows more advanced queuing scenarios and potentially simpler provisioning code in the device itself. It also allows for caching the assigned IoT hub to facilitate faster cloud-to-device messaging. The messages are sent without needing to interrogate DPS for the assigned Hub information:

:::image type="content" source="media/zero-touch-provisioning-isolated-dps-access.png" alt-text="A diagram that shows an example of zero-touch automated provisioning with isolated DPS access." lightbox="media/zero-touch-provisioning-isolated-dps-access.png" border="false":::

1. The device makes a request to a provisioning API that’s hosted in an instance of Azure App Service. The provisioning API checks with its persistent database to see which instance is best to assign the device to based on existing device inventory, and then it determines the DPS ID scope. In this case, the database that’s proposed is an Azure Cosmos DB instance with multi-master write enabled (for cross-region high availability) that stores each device's assigned DPS. You can then use this database for tracking use of the DPS instances for all appropriate metrics (such as provision requests per minute, total provisioned devices, and so on). The database also allows you to supply a reprovision request by using the same DPS ID scope when appropriate. Authenticate the provisioning API in some way to prevent inappropriate provisioning requests. You can likely do this by using the same authentication that the provisioning service uses against DPS, for example, with a private key for an issued certificate. But other options are possible. For example, FTA has worked with a customer that uses hardware unique identifiers as part of its service authentication process. The device manufacturing partner regularly supplies a list of unique identifiers to the device vendor to load into a database, which references the service behind the custom provisioning API.
1. The provisioning API performs the DPS provisioning process with the assigned ID scope, effectively acting as a DPS proxy.
1. The DPS results are forwarded to the device.
1. The device stores the IoT hub connection information in persistent storage, ideally in a secured storage location because the ID scope is part of the authentication against the DPS instance. The device uses this IoT hub connection information for later requests into the system.

This design avoids the need to reference the DPS SDK or the DPS service. It also avoids the need for storing or maintaining a DPS scope on the device. It allows for transfer of ownership scenarios as a result because the provisioning service can direct to the appropriate final customer DPS instance. However, it causes the provisioning API to somewhat duplicate DPS in concept, which might not be ideal.

**(3) Zero-touch provisioning with transfer of ownership:** A third possible zero-touch provisioning design is to use a factory-configured DPS instance as a starting point, and then redirect as necessary to other DPS instances. This design allows for provisioning without a custom provisioning API but it requires a management application to track DPS instances and supply redirection as necessary.

The management application requirements include tracking which DPS should be the active DPS for each specific device. You can use this approach for “transfer of ownership” scenarios, where the device vendor transfers ownership of the device from the vendor to the end device customer.

1. The device connects to the factory-configured DPS instance and requests an initial provisioning process.
1. The device receives an initial configuration, including the desired target DPS instance.
1. The device connects to the desired target DPS instance and requests provisioning.
1. The device then stores the IoT hub connection information in persistent storage, ideally in a secured storage location (because the ID scope is part of the authentication against the DPS instance). The device utilizes this IoT hub connection information for further requests into the system.

:::image type="content" source="media/zero-touch-provisioning-transfer-of-ownership.png" alt-text="A diagram that shows an example of zero-touch provisioning with transfer of ownership." lightbox="media/zero-touch-provisioning-transfer-of-ownership.png" border="false":::

**(4) Low-touch provisioning with multiple DPS instances** In some cases, such as in consumer-facing scenarios or with field deployment team devices, a common choice is to offer low-touch (user-assisted) provisioning. Examples of low-touch provisioning include a mobile application on an installer’s phone or a web-based application on a device gateway. In this case, the proven approach is to perform the same operations as in the zero-touch provisioning process, but the provisioning application transfers the details to the device.

:::image type="content" source="media/low-touch-provisioning-direct-dps-access.png" alt-text="A diagram that shows an example of low-touch (user-assisted) provisioning with direct DPS access." lightbox="media/low-touch-provisioning-direct-dps-access.png" border="false":::

1. The administrator launches a device configuration app, which connects to the device.
1. The configuration app connects to a provisioning API that’s hosted in an instance of Azure App Service to request a DPS ID scope. The provisioning API checks its persistent database to see which instance is best to assign the device to based on existing device inventory, and returns the DPS ID scope. In this case, the database proposed is an Azure Cosmos DB instance with multi-master write enabled (for cross-region high availability) that stores each device's assigned DPS. This database can then be used for tracking utilization of the DPS instances for all appropriate metrics (such as provision requests per minute and total provisioned devices). This database also allows a reprovisioning to be supplied with the same DPS ID scope when appropriate. The provisioning API should be authenticated in some way to prevent inappropriate provisioning requests from being serviced.
1. The app returns the provisioning ID scope to the device.
1. The device makes a request against DPS with the assigned ID scope. DPS returns details to the device for which IoT hub it should be assigned to.
1. The device persists the ID scope and IoT hub connection information to persistent storage, ideally in a secured storage location because the ID scope is part of the authentication against the DPS instance. The device uses this IoT hub connection information for further requests into the system.

There are other possible variations not detailed in this article. For example, you can configure the architecture shown here by moving the DPS call to the provisioning API, as shown in [Zero-touch provisioning with a provisioning API](#zero-touch-provisioning-with-a-provisioning-api). The goal is to make sure each tier is scalable, configurable, and readily deployable.

**General DPS provisioning guidance:** You should apply the following recommendations to your DPS deployment. The represent general best practices for this Azure service:

**Don’t provision on every boot**. The [DPS documentation](/azure/iot-dps/how-to-reprovision#send-a-provisioning-request-from-the-device) specifies that the best practice isn't to provision on every boot. For small use cases, it might seem reasonable to provision at every boot because that’s the shortest path to deployment. However, when scaling up to millions of devices, DPS can become a bottleneck, given [its default limit of 1,000 registrations per minute per service instance](/azure/iot-dps/about-iot-dps#quotas-and-limits). Even device registration status lookup can be a bottleneck because it has a limit of 5 to 10 polling operations per second. Provisioning results are usually a static mapping to an IoT hub. So, unless your requirements include automated reprovisioning requests, it's best to perform them only on demand. Although this limit is a soft limit and you can increase it on a case-by-case basis by [contacting Microsoft Support](/azure/iot-dps/about-iot-dps#quotas-and-limits), the increase isn't to the scale of tens of thousands of devices per minute. So scaling out to multiple DPS instances might be the only way to support such scenarios, depending on the anticipated traffic.

**Use a staggered provisioning schedule**. One recommendation for mitigating some of the time-based limitations is using a [staggered provisioning schedule](/azure/iot-dps/concepts-deploy-at-scale#device-deployment-using-a-staggered-provisioning-schedule). For an initial provisioning, depending on the deployment requirements, this schedule might be based on a random offset of a few seconds, or it might be a maximum of many minutes. 

**Always query status before requesting provisioning**. As a best practice, devices should always query their status before requesting provisioning by using the [Device Registration Status Lookup API](/rest/api/iot-dps/service/individual-enrollment/query). This call [doesn't currently count as a billed item](/azure/iot-dps/about-iot-dps#billable-service-operations-and-pricing), and the [limit is independent of the registration limit](/azure/iot-dps/about-iot-dps#quotas-and-limits). The query operation is relatively quick compared to a provision request, which means that the device can validate its status and move on to the normal device workload more quickly. The appropriate device registration logic is documented in the [large-scale deployment documentation](/azure/iot-dps/concepts-deploy-at-scale).

**Follow provisioning API considerations**. Several of the designs proposed here include a provisioning API. The provisioning API needs a backing metadata store such as Azure Cosmos DB. At these scale levels, it's best to implement a globally available and resilient design pattern, which is a good pattern for this API and backing data store. The built-in multi-master, geo-redundant capabilities and latency guarantees in Azure Cosmos DB make it an excellent choice for this scenario. The key responsibilities of this API include:

- Serve the DPS ID scope. This interface could be a GET request. Remember that physical devices or the management application are connecting to this interface.
- Support the device lifecycle. A device might need to be reprovisioned, or some other unexpected event can happen. At a minimum, it's key to maintain the device ID and assigned DPS for a device. In this way, you can deprovision from the assigned DPS and reprovision on another. Or, if a device’s lifecycle is over, you can completely remove it from the system.
- Load balance systems. By using the same metadata regarding device ID and DPS, it's simpler to understand the current load on each subsystem and apply that information to better balance devices across the horizontally scaled-out components.
- Uphold system security. As mentioned earlier, the provisioning API should authenticate each request. The recommended best practice is to [use a unique X.509 certificate per device](/azure/iot-dps/concepts-x509-attestation), which can authenticate both against the provisioning API and against the DPS instance, if the architecture supports it. Other methods, such as fleet certificates and tokens, are available but considered less secure. How you specifically implement, along with the security implications of your implementation, depend on whether you select a zero-touch or a low-touch option.

### Scaling out Azure IoT Hub

Compared to scaling out DPS, scaling out Azure IoT Hub is relatively straightforward. As mentioned earlier, one of the benefits of DPS is that an instance can be linked to many IoT Hub instances. If DPS is used as is recommended for all Azure IoT solutions, scaling out IoT Hub is a matter of:

1. Creating a new instance of the IoT Hub service.
1. Configuring the new instance with appropriate routing and other details.
1. Linking the new instance to the appropriate DPS instances.
1. If necessary, reconfiguring the [DPS allocation policy](/azure/iot-dps/how-to-use-allocation-policies) or your [custom allocation policy](/azure/iot-dps/concepts-custom-allocation).

## Design device software

There are many best practices to follow and device-side considerations for scalable device design. Some of them are directly derived from anti-patterns experienced in the field. This section describes concepts that are key to a successfully scaled deployment.

**Estimate workloads across different parts of the device lifecycle and scenarios within the lifecycle**. Device registration workloads can vary greatly between development phases (pilot, development, production, decommissioning, end of life). In some cases, they can also vary based on external factors such as the previously mentioned blackout scenario. Designing for the “worst case” workload helps ensure success at scale.

**Support reprovisioning on demand**. You can offer this feature through a device command and an administrative user request, which is mentioned in the [product documentation](/azure/iot-dps/concepts-deploy-at-scale#reprovisioning-devices). This option lets you transfer ownership scenarios and factory default scenarios.

**Don’t reprovision when it’s not necessary**. It’s unusual for an active, working device in the field to need reprovisioning because provisioning information is relatively static. Don’t reprovision without a good reason.

**Check provisioning status if you must reprovision often, for example at every device boot**. If the device provisioning status is in doubt, begin by [querying the provisioning status](/rest/api/iot-dps/service/individual-enrollment/query) first. The query operation is handled against a different quota than a provisioning operation and is a faster operation than a provisioning operation. This query allows the device to validate the provisioning status before proceeding. You might see a case, for example, when a device doesn't have available persistent storage to store the provisioning results.

**Ensure a good retry logic strategy**. The device must have appropriate retry algorithms built in to the device code for both initial provisioning and later reprovisioning, such as the previously mentioned "exponential backoff with randomization." These scenarios might be different for the two use cases. Initial provisioning, by definition, might need to be more aggressive in the retry process than reprovisioning, depending on the use case. When throttled, DPS returns an [HTTP 429 ("Too many requests")](https://http.cat/429) error code, like most Azure services. The Azure Architecture Center has guidance about [retry](/azure/architecture/patterns/retry) and, more importantly, [anti patterns to avoid with respect to retry scenarios](/azure/architecture/example-scenario/iot/iot-move-to-production#:~:text=Avoid%20also%20the%20following%20anti%2Dpatterns%3A). The DPS documentation also has information on how to know what the service is recommending for a retry interval and how to calculate an appropriate jitter as part of its scaling guidance. The device location stability and connectivity access also influence the appropriate retry strategy. For example, if a device is known to be offline for periods of time, and the device can detect that it's offline, there’s no point in retrying online operations while the device is offline.

**Support over-the-air (OTA) updates**. Two simple update models are the use of device twin properties with [automatic device management](/azure/iot-hub/iot-hub-automatic-device-management) and the use of simple device commands. For more sophisticated update scenarios and reporting, see the preview of the [Azure Device Update service](/azure/iot-hub-device-update/). OTA updates allow for correcting defects in device code and for fundamental service reconfiguration (for example, DPS ID scope) if necessary.

**Architect for certificate changes at all layers and all certificate uses**. This recommendation is tied to the OTA update best practice. You must consider certificate rotation. The IoT Hub DPS documentation touches on this scenario [from a device identity certificate](/azure/iot-dps/how-to-roll-certificates) viewpoint. However, it's important to remember as part of a device solution that other certificates are being used, such as for IoT Hub access, App Service access, and Azure Storage account access. The [root certificate change across the Azure platform](/azure/security/fundamentals/tls-certificate-changes) shows that you must anticipate changes at all layers. Also, use certificate pinning with caution, especially when certificates are outside the device manufacturer’s control.

**Consider a reasonable "default" state**. To resolve initial provisioning failures, have a reasonable disconnected or unprovisioned configuration, depending on the circumstances. If the device has a heavy interaction component as part of initial provisioning, the provision process can occur in the background while the user performs other provisioning tasks. In any case, implied in the use of a default is the use of an appropriate retry pattern and the proper use of the [circuit breaker architectural](/azure/architecture/patterns/circuit-breaker) pattern.

**Include endpoint configuration capabilities where appropriate**. Allow configuration of the DPS ID scope, the DPS endpoint, or the custom provisioning service endpoint. The DPS endpoint isn't expected to change, but because you can change it on the device, you have greater flexibility. For example, consider the case of automated validation of the device provisioning process through integration testing without direct Azure access. Or consider the possibility of future provisioning scenarios not in place today, such as through a provisioning proxy service.

**Use the Azure IoT SDKs for provisioning**. Whether the DPS calls are on the device itself or in a custom provisioning API, using the Azure IoT SDKs means you get some best practices in the implementation "for free," and it allows cleaner support experiences. Because the SDKs are all published open source, it's possible to review how they work and to suggest changes. A combination of which device hardware you select and the available runtime or runtimes on the device primarily drive which SDK you select.

## Deploy devices

Device deployment is a key part of the device lifecycle, but it's outside the scope of this article because it’s dependent on the use case. The previously referenced discussion points around “transfer of ownership” might apply to the deployment and the patterns that involve a provisioning application (for example, a mobile application), but you select it based on the IoT device type in use.

## Monitor devices

An important part of your overall deployment is to monitor the solution from end to end to make sure that the system performs appropriately. Because this article is explicitly focused on architecture and design and not on the operational aspects of the solution, discussing monitoring in detail is out of scope. However, at a high level, monitoring tools are built into Azure through [Azure Monitor](/azure/azure-monitor/) to ensure that the solution isn't hitting limits. For details, see these articles:

- [Monitoring Azure IoT Hub](/azure/iot-hub/monitor-iot-hub)
- [Diagnose and troubleshoot disconnects with Azure IoT Hub DPS](/azure/iot-dps/how-to-troubleshoot-dps)
- [Monitor Azure App Service performance - Azure Monitor](/azure/azure-monitor/app/azure-web-apps)

You can use these tools individually or as part of a more sophisticated SIEM solution like [Microsoft Sentinel](/azure/sentinel/overview).

The [documentation](/azure/iot-dps/concepts-deploy-at-scale#monitoring-devices) includes the following monitoring patterns for monitoring the usage of DPS over time:

- Create an application to query each enrollment group on a DPS instance, get the total devices registered to that group, and then aggregate the numbers from across various enrollment groups. This number provides an exact count of the devices that are currently registered via DPS and can be used to monitor the state of the service.
- Monitor device registrations over a specific period. For instance, monitor registration rates for a DPS instance over the prior five days. This approach provides only an approximate figure and is capped to a set time period.

## Conclusion

Scaling up an IoT solution to support millions, or even tens or hundreds of millions, of devices isn't a straightforward task. There are many factors to consider and various ways to solve the issues that arise at those scales. This article summarizes the concerns and supplies approaches for how to address those concerns in a successful deployment.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

**Principal author:**

- [Michael C. Bazarewsky](https://www.linkedin.com/in/mikebaz/) | Senior Customer Engineer, Microsoft Azure CXP G&I

**Other contributors:**

- [David Crook](https://www.linkedin.com/in/drcrook/) | Principal Customer Engineer, Microsoft Azure CXP G&I
- [Alberto Gorni](https://www.linkedin.com/in/gornialberto/) | Senior Customer Engineer

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- Review the product group guidance for [best practices for large-scale Microsoft Azure IoT device deployments](/azure/iot-dps/concepts-deploy-at-scale)
- Review [recovery information](/azure/cloud-adoption-framework/manage/considerations/protect) in the Cloud Adoption Framework

## Related resources

- [Move an IoT solution from test to production](/azure/architecture/example-scenario/iot/iot-move-to-production)
- [Retry general guidance](/azure/architecture/best-practices/transient-faults)
- [Protect and recover in cloud management](/azure/cloud-adoption-framework/manage/considerations/protect)

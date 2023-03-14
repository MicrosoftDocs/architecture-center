---
title: Architectural approaches for IoT in a multitenant solution
titleSuffix: Azure Architecture Center
description: This article describes approaches for supporting multitenancy in your IoT solution.
author: drcrook1
ms.author: dacrook
ms.date: 03/15/2023
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
products:
  - azure
  - azure-iot
  - azure-iot-central
  - azure-iot-dps
  - azure-iot-hub
categories:
  - iot
ms.category:
  - fcp
ms.custom:
  - guide
  - fcp
---

# Architectural approaches for IoT in a multitenant solution

Multitenant IoT solutions come in many different flavors and sizes. You might have many requirements and constraints, ranging from infrastructure ownership, to customer data isolation, to compliance. It can be challenging to define a pattern that meets all of these design constraints, and doing so often requires considering multiple dimensions. This article describes several approaches commonly used to solve multitenancy considerations for IoT-based solutions. This document includes example multitenant architectures that leverage common components, according to the [IoT Reference Architecture](/azure/architecture/reference-architectures/iot).

## Key considerations and requirements

These considerations and requirements are presented in the order in which they're typically prioritized for a solution's design.

### Governance and compliance

Governance and compliance considerations might require that you use a particular pattern or set of IoT resources. Not all IoT services have the same certifications or capabilities. If you need to meet specific compliance standards, you might need to select specific services. Information on governance and compliance is covered in a [dedicated article on that topic](governance-compliance.md).

Governance in IoT can also take additional forms, such as device ownership and management. Does the customer own the device or does the solution provider?  Who owns the management of those devices?  These considerations and implications are unique to each solution provider and can lead to different choices in the technology, deployment pattern, and multi-tenancy pattern that you use.

### Scale

It's important to plan your solution's scale. Scale is often considered across these three dimensions:

* **Quantity of devices**: All Azure device management services - [Azure IoT Central](/azure/iot-central/core/concepts-quotas-limits), [Azure IoT Hub Device Provisioning Service (DPS)](/azure/iot-dps/about-iot-dps#quotas-and-limits), and [Azure IoT Hub](/azure/iot-hub/iot-hub-devguide-quotas-throttling) - have limitations on the number of devices supported in a single instance.

   > [!TIP]
   > Refer to the [high scale documentation](https://aka.ms/ScalingIoT), if you plan to deploy a very large number of devices.

* **Device throughput**: Different devices, even in the same solution, might have different throughput requirements. "Throughput" in this context refers to both the number of messages over a period of time and the size of the messages. For example, in a smart-building solution, thermostats will likely report data at a lower frequency than elevators, while in a connected-vehicle solution, vehicle camera recording data messages will likely be larger than navigation telemetry messages. If your messages are throttled with respect to frequency, you might need to scale out to more instances of a particular service, but if they are throttled with respect to size, you might need to scale up to larger instances of a particular service.

* **Tenants**: A single tenant's scale might be small, but when multiplied by the number of tenants, it can quickly grow.

### Performance and reliability

#### Tenant isolation

Fully shared solutions can have [noisy neighbors](/azure/architecture/antipatterns/noisy-neighbor). In the cases of IoT Hub and IoT Central, this can result in HTTP 429 ("Too Many Requests") response codes, which are hard failures that can cause a cascading effect. For more information, see [Quotas and Throttling](/azure/iot-hub/iot-hub-devguide-quotas-throttling).

In fully multitenant solutions, these effects can cascade. When customers share IoT Hubs or IoT Central applications, then all customers on the shared infrastructure will begin receiving errors. Because IoT Hub and IoT Central are commonly the entry points for data to the cloud, other downstream systems that depend on this data are likely to fail as well. Often, the most common occurrence for this to happen is when a message quota limit has been exceeded. In this situation, the fastest and simplest fix for IoT Hub solutions is to upgrade the IoT Hub SKU, increase the number of IoT Hub units, or both. For IoT Central solutions, the solution automatically scales as necessary, up to the [documented number of messages supported](/azure/iot-central/core/concepts-quotas-limits).

You can isolate and distribute tenants across the IoT control, management, and communications planes by using DPS's [custom allocation policies](/azure/iot-dps/tutorial-custom-allocation-policies). Further, when you follow the guidance for [high-scale IoT solutions](https://aka.ms/ScalingIoT), you can manage additional allocation distribution at the DPS load-balancer level.

#### Data storage, query, usage, and retention

IoT solutions tend to be very data-intensive, both when streaming and at rest. For more information on managing data in multitenant solutions, see [Architectural approaches for storage and data in multitenant solutions](storage-data.yml).

## Approaches to consider

All the considerations that you'd normally make in an IoT architecture, for all the primary components (such as management, ingestion, processing, storage, security, and so on), are all choices you still must make when pursuing a multi-tenant solution. The primary difference is how you arrange and utilize the components to support multi-tenancy. For example, common decision points for storage might be deciding whether to use SQL Server or Azure Data Explorer, or perhaps on the ingestion and management tier, you'd choose between IoT Hub and IoT Central.

Most IoT solutions fit within a [root architecture pattern](#root-architecture-patterns), which is a combination of the deployment target, tenancy model, and deployment pattern. These factors are determined by the key requirements and considerations described above.

One of the largest decision points needing to be made, within the IoT space, is to select between an application-platform-as-a-service (aPaaS) and platform-as-a-service (PaaS) approaches.  For more information, see [Compare Internet of Things (IoT) solution approaches (PaaS vs. aPaaS)](/azure/architecture/example-scenario/iot/iot-central-iot-hub-cheat-sheet).

This is the common "build vs. buy" dilemma that many organizations face in many projects. It's important to evaluate the advantages and disadvantages of both options.

### Concepts and considerations for aPaaS solutions

A typical aPaaS solution using [Azure IoT Central](/azure/iot-central/core/overview-iot-central), as the core of the solution, might use the following Azure PaaS and aPaaS services:

* [Azure Event Hubs](/azure/event-hubs/event-hubs-about) as a cross-platform, enterprise-grade messaging and data-flow engine.
* [Azure Logic Apps](/azure/logic-apps/logic-apps-overview) as an integration platform-as-a-service, or iPaaS, offering.
* [Azure Data Explorer](/azure/data-explorer/data-explorer-overview) as a data analytics platform.
* [Power BI](/power-bi/fundamentals/power-bi-overview) as a visualization and reporting platform.

:::image type="content" source="media/iot/simple-saas.png" alt-text="An I O T architecture showing tenants sharing an I O T Central environment, Azure Data Explorer, Power B I, and Azure Logic Apps." border="false":::

In the previous diagram, the tenants share an IoT Central environment, Azure Data Explorer, Power BI, and Azure Logic Apps.

This approach is generally the fastest way to get a solution to market. It's a high scale service that supports multitenancy by using [organizations](/azure/iot-central/core/howto-create-organizations).

It's important to understand that because IoT Central is an aPaaS offering, there are certain decisions that are outside of an implementer's control. These decisions include:

* IoT Central uses Azure Active Directory as its identity provider.
* IoT Central deployments are achieved using both control and data plane operations, which combine declarative documents with imperative code.
* In a multitenant pattern, both the IoT Central [maximum node limit](/azure/iot-central/core/howto-create-organizations#limits) (which applies to both parents and leaves) and the maximum tree depth, might force a service provider to have multiple IoT Central instances. In that case, you should consider following the [Deployment Stamp pattern](/azure/architecture/patterns/deployment-stamp).
* IoT Central imposes [API call limits](/azure/iot-central/core/howto-query-with-rest-api#limits), which might impact large implementations.

### Concepts and considerations for PaaS solutions

A PaaS-based approach might use the following Azure services:

* [Azure IoT Hub](/azure/iot-hub/iot-concepts-and-iot-hub) as the core device configuration and communications platform.
* [Azure IoT Device Provisioning Service](/azure/iot-dps/about-iot-dps) as the device deployment and initial configuration platform.
* [Azure Data Explorer](/azure/data-explorer/) for storing and analyzing warm and cold path time series data from IoT devices.
* [Azure Stream Analytics](/azure/architecture/reference-architectures/data/stream-processing-stream-analytics) for analyzing hot path data from IoT devices.
* [Azure IoT Edge](/azure/iot-edge/about-iot-edge) for running artificial intelligence (AI), third-party services, or your own business logic on IoT Edge devices.

:::image type="content" source="media/iot/simple-paas-saas.png" alt-text="Diagram that shows an I O T solution. Each tenant connects to a shared web app, which receives data from I O T Hubs and a function app. Devices connect to the Device Provisioning Service and to I O T Hubs." border="false":::

In the previous diagram, each tenant connects to a shared web app, which receives data from IoT Hubs and a function app. Devices connect to the Device Provisioning Service and to IoT Hubs.

This approach requires more developer effort to create, deploy, and maintain the solution (versus an aPaaS approach). Fewer capabilities are prebuilt for the implementer's convenience. This means that this approach also offers more control, because fewer assumptions are embedded in the underlying platform.

## Root architecture patterns

The following table lists common patterns for multitenant IoT solutions.  Each pattern includes the following information:

* The name of the **Pattern**, which is based on the combination of the target, model, and deployment type.
* The **Deployment target**, representing the Azure Subscription to deploy resources to.
* The **Tenancy model** being referenced by the pattern, as described at [Multitenancy models](/azure/architecture/guide/multitenant/considerations/tenancy-models)
* The **Deployment pattern**, referring to a simple deployment with minimal deployment considerations, a [Geode pattern](/azure/architecture/patterns/geodes), or a [Deployment Stamp pattern](/azure/architecture/patterns/deployment-stamp).

| Pattern | Deployment target | Tenancy model | Deployment pattern |
|---|---|---|---|
| [Simple SaaS](#simple-saas) | Service provider's subscription | Fully multitenant | Simple |
| [Horizontal SaaS](#horizontal-saas) | Service provider's subscription | Horizontally partitioned | Deployment Stamp |
| [Single-tenant automated](#single-tenant-automated) | Either service provider's or customer's subscription | Single tenant per customer | Simple |

### Simple SaaS

:::image type="content" source="media/iot/simple-saas.png" alt-text="Diagram that shows an I O T architecture. Tenants share an I O T Central environment, Azure Data Explorer, Power B I, and Azure Logic Apps." border="false":::

| Deployment Target | Tenancy Model | Deployment Pattern |
|---|---|---|
| Service provider's subscription | Fully multitenant | Simple |

The *Simple SaaS* approach is the simplest implementation for a SaaS IoT Solution.  As the previous diagram shows, all of the infrastructure is shared, and the infrastructure has no geographic or scale stamping applied. Often, the infrastructure resides within a single Azure subscription.

[Azure IoT Central](/azure/iot-central/core/overview-iot-central) supports the concept of [organizations](/azure/iot-central/core/howto-create-organizations). Organizations enable a solution provider to easily segregate tenants in a secure, hierarchical manner, while sharing the basic application design across all the tenants.

Communications to systems outside of IoT Central, such as for longer-term data analysis, along a cold path or connectivity with business operations, is done through other Microsoft PaaS and aPaaS offerings. These additional offerings might include the following services:

* [Azure Event Hubs](/azure/event-hubs/event-hubs-about) as a cross-platform, enterprise-grade messaging and data flow engine.
* [Azure Logic Apps](/azure/logic-apps/logic-apps-overview) as an integration platform-as-a-service, or iPaaS.
* [Azure Data Explorer](/azure/data-explorer/data-explorer-overview) as a data analytics platform.
* [Power BI](/power-bi/fundamentals/power-bi-overview) as a visualization and reporting platform.

If you compare the *Simple SaaS* approach with the [*Single tenant automated*](#single-tenant-automated) aPaaS model, many characteristics are similar.  The primary difference between the two models is that in the  *Single tenant automated* model, you deploy a distinct IoT Central instance for each tenant, while in the *Simple SaaS with aPaaS* model, you instead deploy a shared instance for multiple customers, and you create an IoT Central organization for each tenant.

As you're sharing a multitenanted data tier in this model, you'll need to implement row-level security, as described in [Architectural approaches for storage and data in multitenant solutions](storage-data.yml), in order to isolate the customer data.

**Benefits**:

* Easier to manage and operate relative to the other approaches presented here.

**Risks**:

* This approach might not easily [scale to very high numbers of devices, messages, or tenants](#scale).

* Because all of the services and components are shared, a failure in any component might affect all of your tenants. This is a risk to your solution's reliability and high availability.

* It's important to consider how you manage the compliance, operations, tenant lifecycle, and security of sub-fleets of devices. These considerations become important because of the shared nature of this solution type at the control, management, and communications planes.

### Horizontal SaaS

| Deployment target | Tenancy model | Deployment pattern |
|---|---|---|
| Service provider's subscription | Horizontally partitioned | Deployment Stamp |

A common scalability approach is to [horizontally partition the solution](../considerations/tenancy-models.yml#horizontally-partitioned-deployments). This means you have some shared components and some per-customer components.

Within an IoT solution, there are many components that can be horizontally partitioned. The horizontally partitioned subsystems are typically arranged using a [deployment stamp pattern](/azure/architecture/patterns/deployment-stamp) which integrates with the greater solution.

#### Example horizontal SaaS

The below architectural example partitions IoT Central per end customer, which serves as the device management, device communications, and administrations portal.  This is often done in such a way that the end customer who consumes the solution has full control over adding, removing, and updating devices themselves, without the intervention of the software vendor. The rest of the solution follows a standard shared infrastructure pattern, which solves for hot path analysis, business integrations, SaaS management, and device analysis needs.

:::image type="content" source="media/iot/horizontal-saas.png" alt-text="Diagram of an I O T solution. Each tenant has their own I O T Central organization, which sends telemetry to a shared function app and makes it available to the tenants' business users through a web app." border="false":::

Each tenant has their own IoT Central organization, which sends telemetry to a shared function app and makes it available to the tenants' business users through a web app.

**Benefits**:

* Generally easy to manage and operate, although additional management might be required for single-tenant components.
* Flexible scaling options, because layers are scaled as necessary.
* Impact of component failures is reduced. While a failure of a shared component impacts all customers, horizontally scaled components only impact the customers that are associated with specific scale instances.
* Improved per-tenant consumption insights for partitioned components.
* Partitioned components provide easier per-tenant customizations.

**Risks**:

* Consider the [scale](#scale) of the solution, especially for any shared components.
* Reliability and high availability are potentially impacted. A single failure in the shared components might affect all the tenants at once.
* The per-tenant partitioned component customization requires long-term DevOps and management considerations.

**Below are the most common components that are typically suitable for horizontal partitioning.**

#### Databases

You might choose to partition the databases. Often it's the telemetry and device data stores that are partitioned. Frequently, multiple data stores are used for different specific purposes, such as warm versus archival storage, or for tenancy subscription status information. 

Separate the databases for each tenant, for the following benefits:

* Support compliance standards. Each tenant's data is isolated across instances of the data store.
* Remediate noisy neighbor issues.

#### Device management, communications, and administration

Azure IoT Hub Device Provisioning Service, IoT Hub, and IoT Central applications can often be deployed as horizontally partitioned components. If you follow this approach, you need to have an additional service to redirect devices to the appropriate Device Provisioning Service for that particular tenant's management, control, and telemetry plane. For more information, see the whitepaper, [Scaling out an Azure IoT solution to support millions of devices](https://aka.ms/ScalingIoT).

This is often done to enable the end customers to manage and control their own fleets of devices that are more directly and fully isolated.

If the device communications plane is horizontally partitioned, telemetry data must be enriched with data for the source tenant, such that the stream processor knows which tenant rules to apply to the data stream. For example, if a telemetry message generates a notification in the stream processor, the stream processor will need to determine the proper notification path for the associated tenant.

#### Stream processing

By partitioning stream processing, you enable per-tenant customizations of the analysis within the stream processors.

### Single-tenant automated

A single-tenant automated approach is based on a similar decision process and design to an [enterprise solution](/azure/architecture/example-scenario/iot/iot-central-iot-hub-cheat-sheet).

:::image type="content" source="media/iot/single-tenant-automated.png" alt-text="Diagram that shows an I O T architecture for three tenants. Each tenant has their own identical, isolated environment with an I O T Central organization and other components dedicated to them." border="false":::

Each tenant has its own identical, isolated environment, with an IoT Central organization and other components dedicated to them.

| Deployment Target | Tenancy Model | Deployment Pattern |
|---|---|---|
| Either service provider's or customer's subscription | Single tenant per customer | Simple |

A critical decision point in this approach is choosing which Azure subscription the components should be deployed to. If the components are deployed to your subscription, you have more control and better visibility into the cost of the solution, but it requires you to own more of the solution's security and governance concerns. Conversely, if the solution is deployed in your customer's subscription, the customer is ultimately responsible for the security and governance of the deployment.

This pattern supports a high degree of scalability. This is because tenant and subscription requirements are generally the limiting factors in most solutions. Therefore, isolate each tenant to give a large scope for scaling each tenant's workload, without substantial effort on your part, as the solution developer.

This pattern also generally has low latency, when compared to other patterns, because you are able to deploy the solution components based on your customers' geography. Geographical affinity allows for shorter network paths between an IoT device and your Azure deployment.

If necessary, you can extend the automated deployment to support improved latency or scale, by allowing the quick deployment of extra instances of the solution, for a customer in existing or new geographies.

The *single-tenant automated* approach is similar to the [*simple SaaS*](#simple-saas) aPaaS model. The primary difference between the two models is that in the *single-tenant automated* approach, you deploy a distinct IoT Central instance for each tenant, while in the *simple SaaS* with aPaaS model, you deploy a shared instance of IoT Central with multiple IoT Central organizations.

**Benefits**:

* Relatively easy to manage and operate.
* Tenant isolation is essentially guaranteed.

**Risks**:

* Initial automation can be complicated for new development staff.
* Security of cross-customer credentials for higher-level deployment management must be enforced, or the compromises can extend across customers.
* Costs are expected to be higher, because the scale benefits of a shared infrastructure across customers are not available.
* If the solution provider owns the maintenance of each instance, you might have many instances to maintain.

### Increase the scale of SaaS

When you expand the scale of a solution to very large deployments, there are specific challenges that arise based on service limits, geographic concerns, and other factors. For more information on large-scale IoT deployment architectures, see [Scaling out an Azure IoT solution to support millions of devices](https://aka.ms/ScalingIoT).

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

 - [Michael C. Bazarewsky](http://linkedin.com/in/mikebaz) | Senior Customer Engineer, FastTrack for Azure
 - [David Crook](http://linkedin.com/in/drcrook) | Principal Customer Engineer, FastTrack for Azure
 
Other contributors:

 - [John Downs](http://linkedin.com/in/john-downs) | Principal Customer Engineer, FastTrack for Azure
 - [Arsen Vladimirskiy](http://linkedin.com/in/arsenv) | Principal Customer Engineer, FastTrack for Azure

## Next steps

* Review guidance for [multitenancy and Azure Cosmos DB](../service/cosmos-db.md).
* Learn about [hot, warm, and cold data paths with IoT on Azure](https://techcommunity.microsoft.com/t5/fasttrack-for-azure/hot-warm-and-cold-data-paths-with-iot-on-azure/ba-p/2336035).
* Refer to the [Azure IoT reference architectures](/azure/architecture/reference-architectures/iot).
* Review documentation on how to [Scale IoT solutions with deployment stamps](../../../example-scenario/iot/application-stamps.yml).

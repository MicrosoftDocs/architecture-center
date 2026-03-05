---
title: IoT Hub-Based Multitenant Solution Architectural Approaches
description: Learn about architectural approaches for Azure IoT Hub-based multitenant solutions to build scalable, secure, and efficient solutions.
author: MikeBazMSFT
ms.author: micbaz
ms.date: 02/17/2026
ms.topic: concept-article
ms.subservice: architecture-guide
ms.custom:
  - arb-saas
  - arb-iot
---

# IoT Hub-based multitenant solution architectural approaches

This article describes several common approaches for addressing multitenancy considerations in Azure IoT Hub-based solutions. Multitenant IoT Hub-based solutions vary. You might have requirements and constraints that span infrastructure ownership, customer data isolation, and compliance requirements. Defining a pattern that meets all these design constraints can be a challenge and often requires you to review several parts of the system to find an approach that fits.

## Key considerations and requirements

These considerations and requirements follow the order in which you typically prioritize them when you design a solution.

### Governance and compliance

Governance and compliance considerations might require you to use a specific pattern or a set of Internet of Things (IoT) resources. IoT services differ in certifications and capabilities, so meeting specific compliance standards might require you to select specific services. For more information, see [Architectural approaches for governance and compliance in multitenant solutions](governance-compliance.md).

Governance in IoT also includes decisions about device ownership and device management. You need to determine whether the customer or the solution provider owns the devices and who manages them. These decisions vary across solution providers and influence your choices for technology, deployment patterns, and multitenancy patterns.

### Scale

Plan your solution's scale across these three areas:

- **Device quantity:** All Azure device management services, including [Azure IoT Central](/azure/iot-central/core/concepts-quotas-limits), [Azure IoT Hub Device Provisioning Service](/azure/iot-dps/about-iot-dps#quotas-and-limits), and [IoT Hub](/azure/iot-hub/iot-hub-devguide-quotas-throttling), limit the number of devices that they support in a single instance.

   > [!TIP]
   > If you plan to deploy many devices, see [Scale out an IoT Hub solution to support millions of devices](../../iot/scale-iot-solution-azure.md).

- **Device throughput:** Different devices, even in the same solution, might have different throughput requirements. In this context, *throughput* refers to the number of messages over a period of time and the size of the messages. Consider the following examples:

  - In a smart-building solution, thermostats typically report data at a lower frequency than elevators.

  - In a connected-vehicle solution, vehicle camera data messages are typically larger than navigation telemetry messages.
  
  If Azure throttles your messages because of their frequency, consider scaling out to more service instances. If Azure throttles your messages because of their size, consider scaling up to larger service instances.

- **Tenants:** One tenant has limited scale, but many tenants together scale quickly.

### Performance and reliability

Consider the following performance and reliability requirements.

#### Tenant isolation

Fully shared solutions can have [noisy neighbors](../../../antipatterns/noisy-neighbor/noisy-neighbor.yml). In IoT Hub and Azure IoT Central, noisy neighbors can result in HTTP 429 (*Too Many Requests*) response codes. These codes are hard failures that can trigger cascading effects across your solution. For more information, see [Quotas and throttling](/azure/iot-hub/iot-hub-devguide-quotas-throttling).

In fully multitenant solutions, these effects can cascade. When customers share IoT Hub or Azure IoT Central applications, all customers on the shared infrastructure receive errors. Because IoT Hub and Azure IoT Central commonly serve as entry points for cloud data, downstream systems that depend on this data are also likely to fail. These errors often occur when a customer exceeds a message-quota limit. In this situation, the simplest fix for IoT Hub solutions is to upgrade the IoT Hub SKU, increase the number of IoT Hub units, or use both options. For Azure IoT Central solutions, the system scales automatically as needed, up to the [documented number of messages supported](/azure/iot-central/core/concepts-quotas-limits).

You can isolate and distribute tenants across the IoT control, management, and communications planes by using IoT Hub Device Provisioning Service [custom allocation policies](/azure/iot-dps/tutorial-custom-allocation-policies). When you follow the guidance for [high-scale IoT solutions](../../iot/scale-iot-solution-azure.md), you can manage other allocation distributions at the IoT Hub Device Provisioning Service load-balancer level.

#### Data storage, query, usage, and retention

IoT solutions are often data-intensive when streaming and at rest. For more information, see [Architectural approaches for storage and data in multitenant solutions](storage-data.md).

### Security

IoT solutions often have security considerations at multiple layers, especially in solutions that you deploy in a cloud-modified [Purdue Enterprise Reference Architecture](https://en.wikipedia.org/wiki/Purdue_Enterprise_Reference_Architecture) or [Industry 4.0](https://techcommunity.microsoft.com/blog/azureinfrastructureblog/extending-operational-technology-to-azure/3265466) environment. Your design approach affects which network layers and boundaries exist. After you select the physical design, you can select the security implementation. You can use the following tools in any approach:

- [Microsoft Defender for IoT](/azure/defender-for-iot/organizations/overview) is a comprehensive IoT monitoring solution that provides [per-device EIoT licenses and OT site licenses](https://www.microsoft.com/security/business/endpoint-security/microsoft-defender-iot-pricing) for each customer device or site. The approach that you select determines whether the Microsoft 365 named user licensing scenario fits your needs. If it doesn't, you can use the per-device or site license options. Both options operate independently from Microsoft 365 tenant licenses.

- You can use [Azure Firewall](/azure/firewall/overview) or a non-Microsoft firewall appliance to isolate network layers and monitor network traffic. Your design approach determines where workloads have network isolation versus a shared network, which is described later in this article.

- [Azure IoT Edge](/azure/iot-edge/about-iot-edge) supports deploying workloads to the edge to enforce security boundaries and process data closer to devices.

Most of these security topics apply in a multitenant solution in the same way that they apply in a single-tenant solution, with variations based on your approach. User and application identity often differ substantially in an overall IoT solution. For more information about identity considerations in multitenant solutions, see [Architectural approaches for identity in multitenant solutions](identity.md).

## Approaches to consider

The considerations and choices for primary components, like management, ingestion, processing, storage, and security, are the same for single-tenant and multitenant IoT solutions. The primary difference is how you arrange and use these components to support multitenancy. The following decision points are common:

- For storage, choose whether to use SQL Server or Azure Data Explorer.

- For the ingestion and management tier, choose between IoT Hub and Azure IoT Central.

Most IoT solutions fit within a [root architecture pattern](#root-architecture-patterns), which combines the deployment target, tenancy model, and deployment pattern. The key requirements and considerations described previously determine these factors.

One of the key decision points for IoT solutions is whether to use an application platform as a service (aPaaS) or a platform as a service (PaaS) approach. For more information, see [Compare IoT solution approaches](/azure/iot/iot-services-and-technologies).

This choice is the common *build versus buy* decision that many organizations face in a wide range of projects.  Evaluate the advantages and disadvantages of both options.

### Concepts and considerations for aPaaS solutions

A typical aPaaS solution that uses [Azure IoT Central](/azure/iot-central/core/overview-iot-central) as the core of the solution might use the following Azure PaaS and aPaaS services:

- [Azure Event Hubs](/azure/event-hubs/event-hubs-about) as a cross-platform, enterprise-grade messaging and data-flow engine

- [Azure Logic Apps](/azure/logic-apps/logic-apps-overview) as an integration platform as a service (iPaaS) offering

- [Azure Data Explorer](/azure/data-explorer/data-explorer-overview) as a data analytics platform

- [Power BI](/power-bi/fundamentals/power-bi-overview) as a visualization and reporting platform

:::image type="complex" border="false" source="media/iot/simple-saas.png" alt-text="Diagram of an IoT Hub-based multitenant architecture that shows tenants sharing an Azure IoT Central environment, Azure Data Explorer, Power BI, and Logic Apps." lightbox="media/iot/simple-saas.png":::
   Diagram that shows a platform owner subscription that has three tenants. Each tenant connects via an arrow to a shared Azure IoT Central organizations environment. A double-sided arrow connects an IoT device and Azure IoT Central. An arrow points from the shared tenant section to the Azure Data Explorer section and then from the Azure Data Explorer section to Power BI. Another arrow points from the shared tenant section to Logic Apps and then from Logic Apps to Power BI.
:::image-end:::

In the previous diagram, the tenants share Azure IoT Central, Azure Data Explorer, Power BI, and Logic Apps.

This approach typically provides a shorter deployment timeline. It's a high-scale service that supports multitenancy through [organizations](/azure/iot-central/core/howto-create-organizations).

Azure IoT Central is an aPaaS offering, so some architectural decisions are outside your control as the implementer. The following decisions are predefined:

- Azure IoT Central uses Microsoft Entra ID as its identity provider.

- Azure IoT Central deployments use both control-plane and data-plane operations, and these operations combine declarative documents with imperative code.

- The [maximum node limit](/azure/iot-central/core/howto-create-organizations#limits) and maximum tree depth in an Azure IoT Central-based multitenant pattern might require service providers to have multiple Azure IoT Central instances. In that case, consider the [Deployment Stamps pattern](../../../patterns/deployment-stamp.yml).

- Azure IoT Central imposes [API call limits](/azure/iot-central/core/howto-query-with-rest-api#limits), which might affect large implementations.

### Concepts and considerations for PaaS solutions

A PaaS-based approach might use the following Azure services:

- [IoT Hub](/azure/iot-hub/iot-concepts-and-iot-hub) as the core device configuration and communications platform

- [IoT Hub Device Provisioning Service](/azure/iot-dps/about-iot-dps) as the device deployment and initial configuration platform

- [Azure Data Explorer](/azure/data-explorer/data-explorer-overview) to store and analyze warm and cold path time-series data from IoT devices

- [Azure Stream Analytics](../../../reference-architectures/data/stream-processing-stream-analytics.yml) to analyze hot path data from IoT devices

- [IoT Edge](/azure/iot-edge/about-iot-edge) to run AI, non-Microsoft services, or your own business logic on IoT Edge devices

:::image type="complex" border="false" source="media/iot/simple-paas-saas.png" alt-text="Diagram that shows an IoT solution. Each tenant connects to a shared web app, which receives data from hubs and an Azure Functions app. Devices connect to IoT Hub Device Provisioning Service and IoT Hub." lightbox="media/iot/simple-paas-saas.png":::
   The diagram shows a platform-owner subscription. Double-sided arrows point from the device ecosystem to IoT Hub Device Provisioning Service, IoT hubs, and function apps. Arrows point downward from IoT Hub Device Provisioning Service to the IoT hubs. Double-sided arrows connect the IoT hubs and function apps. An arrow points from the IoT hubs to Azure Data Explorer. Arrows point from Azure Data Explorer to the web app section and to Azure Cosmos DB. Another arrow points from the function apps to Azure  Cosmos DB and then from Azure Cosmos DB to the web app section. Three tenants connect to the web app section via arrows.
:::image-end:::

In the previous diagram, each tenant connects to a shared web app, which receives data from IoT Hub and an Azure Functions app. Devices connect to IoT Hub Device Provisioning Service and to IoT Hub.

This approach requires more developer effort to create, deploy, and maintain the solution than an aPaaS approach. It includes fewer prebuilt capabilities. This approach also provides more control because fewer assumptions are built into the platform.

## Root architecture patterns

The following table lists common patterns for multitenant IoT solutions. Each pattern includes the following information:

- The name of the **pattern**, which is based on the combination of the target, model, and deployment type

- The **deployment target**, which represents the Azure subscription where you deploy resources

- The **tenancy model** that the pattern references, as described in [Multitenancy models](../considerations/tenancy-models.md)

- The **deployment pattern**, which refers to a basic deployment with minimal deployment considerations, a [geode pattern](../../../patterns/geodes.yml), or a [deployment stamps pattern](../../../patterns/deployment-stamp.yml)

| Pattern | Deployment target | Tenancy model | Deployment pattern |
|---|---|---|---|
| [Simple software as a service (SaaS)](#simple-saas) | The service provider's subscription | Fully multitenant | Simple |
| [Horizontal SaaS](#horizontal-saas) | The service provider's subscription | Horizontally partitioned | Deployment Stamps |
| [Single-tenant automated](#single-tenant-automated) | The service provider's or the customer's subscription | One tenant for each customer | Simple |

### Simple SaaS

:::image type="complex" border="false" source="media/iot/simple-saas.png" alt-text="Diagram that shows an IoT architecture. Tenants share an Azure IoT Central environment, Azure Data Explorer, Power BI, and Logic Apps." lightbox="media/iot/simple-saas.png":::
   Diagram that shows a platform owner subscription that contains three tenants. Each tenant connects to a shared Azure IoT Central organizations environment. IoT devices connect to the Azure IoT Central environment. Data flows from Azure IoT Central to Azure Data Explorer, then to Power BI for visualization. Logic Apps connects to the Azure IoT Central environment for integration workflows.
:::image-end:::

| Deployment target | Tenancy model | Deployment pattern |
|---|---|---|
| Service provider's subscription | Fully multitenant | Simple |

The *Simple SaaS* approach is the simplest implementation for a SaaS IoT solution. As shown in the previous diagram, all infrastructure serves all tenants, with no geographic or scale stamping applied. The infrastructure often resides within a single Azure subscription.

Azure IoT Central supports the concept of organizations. Organizations let a solution provider segregate tenants in a secure, hierarchical way while sharing the basic application design across all tenants.

Communications to systems outside of Azure IoT Central, like for longer-term data analysis along a cold path or for connections with business operations, rely on other Microsoft PaaS and aPaaS offerings. These offerings might include the following services:

- Event Hubs as a cross-platform, enterprise-grade messaging and data flow engine

- Logic Apps as an integration platform as a service (iPaaS)

- Azure Data Explorer as a data analytics platform

- Power BI as a visualization and reporting platform

When you compare the *Simple SaaS* approach with the *[single-tenant automated](#single-tenant-automated)* aPaaS model, many characteristics match. The primary differences between the two models involve how each model deploys Azure IoT Central:

- In the *single-tenant automated* model, you deploy a distinct Azure IoT Central instance for each tenant.

- In the *Simple SaaS with aPaaS* model, you deploy a shared instance for multiple customers, and you create an Azure IoT Central organization for each tenant.

Because this model uses a shared multitenant data tier, you must implement row-level security to isolate customer data. For more information, see [Architectural approaches for storage and data in multitenant solutions](storage-data.md).

**Benefits:**

- Simplified management and operations compared to the other approaches in this article

**Risks:**

- Limited scalability for large numbers of devices, messages, or tenants, as described in [Scale](#scale)

- Shared services and components across tenants, so a failure in any component can affect all tenants and reduce reliability and availability

- Increased complexity for compliance, operations, tenant life cycle, and device subfleet security because this solution type shares control, management, and communications planes across customers

### Horizontal SaaS

| Deployment target | Tenancy model | Deployment pattern |
|---|---|---|
| Service provider's subscription | Horizontally partitioned | Deployment Stamps |

A common scalability approach is to [horizontally partition your solution](../considerations/tenancy-models.md#horizontally-partitioned-deployments). This approach uses a combination of shared components and tenant-specific components.

Within an IoT solution, many components support horizontal partitioning. The horizontally partitioned subsystems are typically arranged by using a [deployment stamps pattern](../../../patterns/deployment-stamp.yml) that integrates with the greater solution.

#### Example horizontal SaaS

The following architectural example partitions Azure IoT Central for each customer, where it functions as the device management, device communications, and administration portal. This partitioning gives the customer full control over adding, removing, and updating their devices without involvement from the software vendor. The rest of the solution uses a standard shared infrastructure pattern that supports hot-path analysis, business integrations, SaaS management, and device analysis.

:::image type="complex" border="false" source="media/iot/horizontal-saas.png" alt-text="Diagram of an IoT solution. Each tenant has their own Azure IoT Central organization, which sends telemetry to a shared function app and makes it available to the tenants' business users through a web app." lightbox="media/iot/horizontal-saas.png":::
   Diagram that shows three key sections: tenants' device administrators, subscriptions, and tenants' business users. Three arrows point from tenants' device administrators to individual tenant subscriptions that contain Azure IoT Central. Double-sided arrows point from Azure IoT Central to the Functions app. An arrow points from the Functions app to Azure Data Explorer and from Azure Data Explorer to the web app. An arrow points from the tenants' business users to the web app.
:::image-end:::

Each tenant has their own Azure IoT Central organization, which sends telemetry to a shared function app and exposes that data to the tenants' business users through a web app.

**Benefits:**

- Simplified management and operations, with extra oversight required only for single-tenant components.

- Flexible scaling options because each layer can scale independently.

- Reduced impact from component failures. A failure in a shared component affects all customers, while failures in horizontally scaled components affect only the customers associated with specific scale instances.

- Improved per-tenant consumption insights for partitioned components.

- Easier per-tenant customizations for partitioned components.

**Risks:**

- Solution [scale](#scale), especially for any shared components

- Single points of failure (SPoFs) in shared components, which can affect all tenants and reduce reliability and availability

- Long-term development operations (DevOps) and management overhead for per-tenant customizations in partitioned components

The following components are typically suitable for horizontal partitioning.

#### Databases

You might choose to partition the databases. In many cases, you partition the telemetry and device data stores. Organizations often use multiple data stores for different purposes, like warm versus archival storage or storing tenant subscription status information.

Separate the databases for each tenant to gain the following benefits:

- Meet compliance standards. Each tenant's data is isolated across instances of the data store.

- Remediate noisy neighbor problems.

#### Device management, communications, and administration

You can often deploy IoT Hub Device Provisioning Service, IoT Hub, and Azure IoT Central applications as horizontally partitioned components. In this approach, you need another service to redirect devices to the right IoT Hub Device Provisioning Service instance for that tenant's management, control, and telemetry plane.

This approach is often used when tenants need to manage and control their own device fleets, which remain directly and fully isolated.

If the device communications plane uses horizontal partitioning, telemetry data must include information that identifies the source tenant. This information lets the stream processor determine which tenant-specific rules apply to the data stream. For example, if a telemetry message generates a notification, the processor must determine the correct notification path for the associated tenant.

#### Stream processing

When you partition stream processing, you create a structure that lets each tenant customize the analysis within the stream processors.

### Single-tenant automated

A single-tenant automated approach follows a decision process and design similar to an [enterprise solution](/azure/iot/iot-services-and-technologies).

:::image type="complex" border="false" source="media/iot/single-tenant-automated.png" alt-text="Diagram that shows an IoT architecture for three tenants. Each tenant has their own identical, isolated environment with an Azure IoT Central organization and other dedicated components." lightbox="media/iot/single-tenant-automated.png":::
   Diagram that shows three separate tenant subscriptions or isolated environments. Each tenant has a dedicated Azure IoT Central application. IoT devices for each tenant connect to their respective Azure IoT Central instance. Each tenant environment includes dedicated instances of Azure Data Explorer for data storage and analysis. Each tenant has a dedicated Power BI workspace for visualization. Logic Apps provides integration capabilities within each tenant environment. All components remain isolated per tenant with no shared infrastructure between tenants.
:::image-end:::

Each tenant has its own identical, isolated environment, with an Azure IoT Central organization and other components dedicated to that tenant.

| Deployment target | Tenancy model | Deployment pattern |
|---|---|---|
| Either the service provider's or customer's subscription | One tenant for each customer | Simple |

A critical decision point in this approach is choosing which Azure subscription to deploy the components to. Deploying the components to your subscription gives you more control and improved visibility into solution costs, but it also requires you to own more of the solution's security and governance concerns. Conversely, if you deploy the solution in your customer's subscription, your customer manages the security and governance of the deployment.

This pattern supports a high degree of scalability because tenant and subscription requirements typically define the limits in most solutions. Isolating each tenant increases the available scaling scope for that tenant's workload without requiring substantial effort from you as the solution developer.

This pattern also generally has low latency compared to other patterns because you can deploy the solution components based on your customers' geography. Geographic affinity allows for shorter network paths between an IoT device and your Azure deployment.

If necessary, you can extend the automated deployment to improve latency or scale by supporting fast deployment of extra solution instances in existing or new geographies.

The *single-tenant automated* approach is similar to the *[Simple SaaS](#simple-saas)* aPaaS model. The primary difference between the two models is that in the *single-tenant automated* approach, you deploy a distinct Azure IoT Central instance for each tenant, while in the *Simple SaaS with aPaaS* model, you deploy a shared instance of Azure IoT Central with multiple Azure IoT Central organizations.

**Benefits:**

- Easier management and operation
- Guaranteed tenant isolation

**Risks:**

- Complex initial automation for new development staff

- Cross-customer credential exposure if higher-level deployment management doesn't enforce security boundaries

- Higher costs because shared-infrastructure scale benefits aren't available

- Increased maintenance effort when the solution provider manages each instance

### Increase the scale of SaaS

When you expand the scale of a solution to large deployments, specific challenges occur based on service limits, geographic concerns, and other factors. For more information about large-scale IoT deployment architectures, see [Scale out an Azure IoT solution to support millions of devices](/azure/architecture/guide/iot/scale-iot-solution-azure).

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal authors:

- [Michael C. Bazarewsky](https://www.linkedin.com/in/mikebaz) | Senior Customer Engineer, FastTrack for Azure
- [David Crook](https://www.linkedin.com/in/drcrook) | Principal Customer Engineer, FastTrack for Azure

Other contributors:

- [John Downs](https://www.linkedin.com/in/john-downs/) | Principal Software Engineer, Azure Patterns & Practices
- [Arsen Vladimirskiy](https://www.linkedin.com/in/arsenv) | Principal Customer Engineer, FastTrack for Azure
- [Rade Zheng](https://www.linkedin.com/in/rade-zheng-9483a411/) | Cloud Solution Architect

## Next step

- [Hot, warm, and cold data paths with IoT on Azure](https://techcommunity.microsoft.com/blog/fasttrackforazureblog/hot-warm-and-cold-data-paths-with-iot-on-azure/2336035)

## Related resource

- [Multitenancy and Azure Cosmos DB](../service/cosmos-db.md)

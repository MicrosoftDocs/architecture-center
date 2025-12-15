---
title: Architectural Approaches for Messaging in Multitenant Solutions
description: Learn architectural approaches for messaging in multitenant solutions, including shared systems, sharding, and dedicated messaging.
author: johndowns
ms.author: pnp
ms.date: 11/24/2025
ms.topic: concept-article
ms.subservice: architecture-guide
ms.custom: arb-saas
---

# Architectural approaches for messaging in multitenant solutions

Distributed applications that include multiple internal and external services require asynchronous messaging and event-driven communication. When you design your multitenant solution, you must decide how to share or partition messages that belong to different tenants.

You can share a messaging system or event-streaming service across all tenants to reduce operational cost and management complexity. Alternatively, you can use a dedicated messaging system for each tenant to get better data isolation, reduce the risk of data leakage, eliminate the [noisy neighbor problem](../../../antipatterns/noisy-neighbor/noisy-neighbor.yml), and charge Azure costs back to your tenants more easily.

This article helps solution architects decide how to use messaging or eventing infrastructure in a multitenant solution.

## Messages, data points, and discrete events

You must understand the difference between services that deliver an event and systems that send a message. An *event* is a lightweight notification of a condition or state change. An event typically describes something that already happened. A *message* contains raw data that a service produces to be consumed or stored elsewhere. Messages are implicit instructions or requests.

The following table describes key messaging types and example multitenant solutions that might use that type of entity.

| Entity type | Contents | Examples |
|-|-|-|
| Discrete events | Information about specific actions that the publishing application carries out | <ul><li> A music-sharing platform tracks a music track that a user in a specific tenant listens to. </li><br><li> A manufacturing software as a service (SaaS) application pushes real-time information to customers and external parties about equipment maintenance, system health, and contract updates. </li></ul> |
| Series events | Informational data points in an ongoing, continuous stream | <ul><li> A multitenant building control system receives telemetry events, like temperature or humidity readings, from sensors that belong to multiple customers. </li><br><li>A client-side script on a webpage collects user actions and sends them to a click-analytics solution. </li></ul> |
| Messages | Information that a receiving service needs to run steps in a workflow or a processing chain | <ul><li> A business-to-business (B2B) finance application receives a message to begin processing a tenant's banking records. </li><br><li> A customer of a business-to-consumer (B2C) email service initiates a data records compliance request that must be processed gradually over several days. </li></ul> |

For more information, see [Choose the right Azure messaging service for your data](https://azure.microsoft.com/blog/events-data-points-and-messages-choosing-the-right-azure-messaging-service-for-your-data).

Azure provides several messaging services that can support your messaging requirements. These services include [Azure Event Hubs](/azure/event-hubs/event-hubs-about), [Azure Event Grid](/azure/event-grid/overview), and [Azure Service Bus](/azure/service-bus-messaging/service-bus-messaging-overview). For more information, see [Choose between Azure messaging services](/azure/event-grid/compare-messaging-services).

You can also deploy and manage your own messaging service on virtual machines (VMs), containers, or in services like Azure Kubernetes Service (AKS). This approach requires you to deploy, manage, and maintain your messaging infrastructure.

## Key considerations and requirements

The [deployment and tenancy model](../considerations/tenancy-models.md) that you choose for your solution affects security, performance, data isolation, management, and the ability to cross-charge resource costs to tenants. When you do this analysis, also consider the model that you select for your messaging and eventing infrastructure. The following sections describe key decisions that you must make when you plan for a messaging system in your multitenant solution.

### Scale

When you plan messaging or eventing infrastructure, consider the number of tenants, complexity of message flows and `eventstream`, volume of messages, expected traffic profile, and isolation level.

First, plan for capacity and establish the maximum throughput capacity for the messaging system. This planning helps you properly handle the expected volume of messages under regular and peak traffic.

When your solution handles many tenants and has a separate messaging system for each tenant, apply a consistent strategy to automate the deployment, monitoring, alerting, and scaling of each infrastructure.

For example, you can deploy a messaging system for a tenant during the provisioning process by using an infrastructure as code (IaC) tool like Terraform, Bicep, or Azure Resource Manager templates (ARM templates) and a DevOps system like Azure DevOps or GitHub Actions. For more information, see [Architectural approaches for the deployment and configuration of multitenant solutions](/azure/architecture/guide/multitenant/approaches/deployment-configuration).

You can size the messaging system with a maximum throughput in messages per unit of time. If the system supports dynamic autoscaling, it can automatically increase or decrease its capacity based on traffic conditions and metrics to meet the expected service-level agreement (SLA).

### Performance predictability and reliability

For only a few tenants, a single messaging system can meet functional throughput requirements and reduce the total cost of ownership (TCO). A multitenant application might share the same messaging entities, like queues and topics, across multiple customers. Alternatively, you might use a dedicated set of components for each tenant to increase tenant isolation. But a shared messaging infrastructure across multiple tenants can expose the entire solution to the [noisy neighbor problem](../../../antipatterns/noisy-neighbor/noisy-neighbor.yml). The activity of one tenant can disrupt other tenants' performance and operability.

In this case, you should properly size the messaging system to sustain the expected traffic load at peak time. Ideally, the system should support autoscaling, which dynamically scales out when traffic increases and scales in when traffic decreases. A dedicated messaging system for each tenant can also mitigate the noisy neighbor risk, but managing many messaging systems increases solution complexity.

A multitenant application can use a hybrid approach. In this approach, core services use the same set of queues and topics in a single, shared messaging system to implement internal, asynchronous communications. In contrast, other services can adopt a dedicated group of messaging entities or even a dedicated messaging system for each tenant to mitigate the noisy neighbor problem and guarantee data isolation.

### Management and operations complexity

From the start, plan how you intend to operate, monitor, and maintain your messaging and eventing infrastructure and how your multitenancy approach affects your operations and processes. For example, consider the following factors:

- When you share a messaging system across multiple tenants, define how your solution collects and reports the usage metrics for each tenant or how it throttles the number of messages that each tenant can send or receive.

- Determine how to migrate tenants when they need to move to a different type of messaging service, a different deployment, or another region.
- When your messaging system uses a platform as a service (PaaS) offering, account for the following considerations:
  - Customize the pricing tier for each tenant based on the features and shared or dedicated isolation level that the tenant requests.

  - Create tenant-specific managed identities and Azure role assignments to assign the proper permissions only to the messaging entities that the tenant should access. For example, see [Authenticate a managed identity with Microsoft Entra ID to access Service Bus resources](/azure/service-bus-messaging/service-bus-managed-service-identity).
- When you host the messaging system that your application uses in a dedicated set of VMs or containers, one for each tenant, define how to deploy, upgrade, monitor, and scale out these systems.

### Cost

Generally, the higher the density of tenants to your deployment infrastructure, the lower the cost to provision that infrastructure. But shared infrastructure increases the likelihood of problems like the [noisy neighbor problem](../../../antipatterns/noisy-neighbor/noisy-neighbor.yml). Carefully consider the trade-offs.

## Approaches and patterns to consider

When you plan a multitenant solution that involves messaging, consider the level of isolation between tenants. Review the following considerations and observations:

- **Encryption keys:** If tenants need their own key to encrypt and decrypt messages, confirm how the messaging service supports key isolation. For example, if you use Service Bus, you might need to create a separate Service Bus Premium namespace for each tenant that needs their own keys. This separation lets you use [customer-managed keys (CMKs)](/azure/service-bus-messaging/configure-customer-managed-key).

- **Business continuity:** Identify tenants that need a high level of recoverability and business continuity. Consider zone redundancy, geo-redundancy, and geo-disaster recovery capabilities for these tenants where available.
- **Worker processing:** When you use separate queue resources or a dedicated messaging system for each tenant, you can adopt a separate pool of worker processes for each tenant. This approach increases the data isolation level and reduces the complexity of managing multiple messaging entities.

  Each instance of the processing system can adopt different credentials, like a connection string, service principal, or managed identity, to access the dedicated messaging system. This approach provides better security and isolation between tenants, but it increases identity management complexity.

### Shared messaging system

You might deploy a shared messaging system, like a single Service Bus namespace, and share it across all your tenants.

:::image type="complex" border="false" source="media/messaging/shared-messaging-system.png" alt-text="Diagram that shows a single shared multitenant messaging system for all tenants." lightbox="media/messaging/shared-messaging-system.png":::
The diagram shows three tenants, tenant A, B, and C. They all point to shared resources, which include a web server and messaging resources.
:::image-end:::

This approach provides the highest density of tenants to the infrastructure and reduces the overall TCO. It often reduces management overhead because you only need to manage and secure a single messaging system or resource.

But when you share a resource or an entire infrastructure across multiple tenants, consider the following limitations:

- Consider the constraints, scaling capabilities, quotas, and limits of the resource. For example, the maximum number of [Event Hubs in a single namespace](/azure/event-hubs/event-hubs-quotas), or the maximum throughput limits, might eventually become a blocker when your architecture grows to support more tenants.

- The [noisy neighbor problem](/azure/architecture/antipatterns/noisy-neighbor/noisy-neighbor) might become a factor when you share a resource across multiple tenants, especially if you have busy tenants or tenants that generate higher traffic than others. To mitigate these effects, consider the [Throttling pattern](/azure/architecture/patterns/throttling) or the [Rate Limiting pattern](/azure/architecture/patterns/rate-limiting-pattern). For example, you can limit the maximum number of messages that a single tenant can send or receive within a period of time.
- You might struggle to monitor the activity and [measure the resource consumption](../considerations/measure-consumption.md) for an individual tenant. Some services, like specific tiers of Service Bus, charge for messaging operations. When you share a namespace across multiple tenants, your application should track the number of messaging operations that each tenant generates and their associated chargeback costs. Other services don't provide the same level of detail.

Tenants might have different requirements for security, intra-region resiliency, disaster recovery, or location. If these requirements don't match your messaging system configuration, you might not accommodate them with only a single resource.

### Use the Sharding pattern

The [Sharding pattern](../../../patterns/sharding.yml) involves deploying multiple messaging systems, also called *shards*. Each shard contains one or more tenants' messaging entities, like queues and topics. Unlike deployment stamps, shards don't imply that you duplicate the entire infrastructure. You might shard messaging systems without also duplicating or sharding other infrastructure in your solution.

![Diagram showing a sharded messaging system. One messaging system contains the queues for tenants A and B, and the other contains the queues for tenant C.](media/messaging/sharding.png)

Every messaging system or *shard* can have different characteristics in terms of reliability, SKU, and location. For example, you can shard your tenants across multiple messaging systems with different characteristics based on their location or needs in terms of performance, reliability, data protection, or business continuity.

When you use the Sharding pattern, you need to use a [sharding strategy](/azure/architecture/patterns/sharding#sharding-strategies) to map a given tenant to the messaging system that contains its queues. The [lookup strategy](/azure/architecture/patterns/sharding#sharding-strategies) uses a map to individuate the target messaging system based on the tenant name or ID. Multiple tenants might share the same shard, but the messaging entities that a single tenant uses aren't spread across multiple shards. You can implement the map with a single dictionary that maps the tenant's name to the name or reference of the target messaging system. You can store the map in a distributed cache that's available to all the instances of a multitenant application, or in a persistent store like a table in a relational database or a table in a storage account.

The Sharding pattern can scale to support a high volume of tenants. Depending on your workload, you might achieve a high density of tenants to shards, which can reduce cost. You can also use the Sharding pattern to address [Azure subscription and service quotas, limits, and constraints](/azure/azure-resource-manager/management/azure-subscription-service-limits).

### Use a multitenant app with dedicated messaging system for each tenant

Another common approach is to deploy a single multitenant application with dedicated messaging systems for each tenant. In this tenancy model, you have some shared components, like computing resources, while you provision and manage other services by using a single-tenant, dedicated deployment approach. For example, you can build a single application tier and then deploy individual messaging systems for each tenant, as shown in the following illustration.

![Diagram showing different messaging systems for each tenant.](media/messaging/dedicated-messaging-systems.png)

If most of the load on your system is from specific components that you can deploy separately for each tenant, use a horizontally partitioned deployment to help mitigate noisy neighbor problems. For example, you might need to use a separate messaging or `eventstream` system for each tenant because a single instance isn't enough to keep up with traffic that multiple tenants generate. When you use a dedicated messaging system for each tenant, a large volume of messages or events from a single tenant might affect the shared components but not other tenants' messaging systems.

Because you provision dedicated resources for each tenant, the cost for this approach can be higher than a shared hosting model. However, it's easier to charge back resource costs of a dedicated system to the tenant that uses it when adopting this tenancy model. This approach allows you to achieve high density for other services, such as computing resources, and reduces these components' costs.

With a horizontally partitioned deployment, you need to adopt an automated process to deploy and manage a multitenant application's services, especially services that a single tenant uses.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [Paolo Salvatori](https://www.linkedin.com/in/paolo-salvatori) | Principal Customer Engineer, FastTrack for Azure

Other contributors:

- [John Downs](https://www.linkedin.com/in/john-downs/) | Principal Software Engineer, Azure Patterns & Practices
- [Clemens Vasters](https://www.linkedin.com/in/clemensv) | Principal Architect, Messaging Services and Standards
- [Arsen Vladimirskiy](https://www.linkedin.com/in/arsenv) | Principal Customer Engineer, FastTrack for Azure

## Next steps

For more information about messaging design patterns, see the following resources:

- [Claim-Check pattern](/azure/architecture/patterns/claim-check)
- [Competing Consumers pattern](/azure/architecture/patterns/competing-consumers)
- [Event Sourcing pattern](/azure/architecture/patterns/event-sourcing)
- [Pipes and Filters pattern](/azure/architecture/patterns/pipes-and-filters)
- [Publisher-Subscriber pattern](/azure/architecture/patterns/publisher-subscriber)
- [Sequential Convoy pattern](/azure/architecture/patterns/sequential-convoy)

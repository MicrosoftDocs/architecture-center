This reference architecture integrates enterprise backend systems, using message broker and events to decouple services for greater scalability and reliability. The backend systems may include software as a service (SaaS) systems, Azure services, and existing web services in your enterprise.

![Reference architecture for enterprise integration using queues and events](./_images/enterprise-integration-message-broker-events.png)

*Download a [Visio file](https://arch-center.azureedge.net/queues-events-content.vsdx) of this architecture*.

## Architecture

The architecture shown here builds on a simpler architecture that is shown in [Basic enterprise integration][basic-enterprise-integration]. That architecture uses [Logic Apps][logic-apps] to orchestrate workflows and [API Management][apim] to create catalogs of APIs.

This version of the architecture adds two components that help make the system more reliable and scalable:

- **[Azure Service Bus][service-bus]**. Service Bus is a secure, reliable message broker.

- **[Azure Event Grid][event-grid]**. Event Grid is an event routing service. It uses a [publish/subscribe](../../patterns/publisher-subscriber.md) (pub/sub) eventing model.

Asynchronous communication using a message broker provides a number of advantages over making direct, synchronous calls to backend services:

- Provides load-leveling to handle bursts in workloads, using the [Queue-Based Load Leveling pattern](../../patterns/queue-based-load-leveling.md).
- Provides for broadcasting of messages to multiple consumers using [Publisher-Subscriber pattern](../../patterns/publisher-subscriber.md).
- Reliably tracks the progress of long-running workflows that involve multiple steps or multiple applications.
- Helps to decouple applications.
- Integrates with existing message-based systems.
- Allows work to be queued when a backend system is not available.

Event Grid enables the various components in the system to react to events as they happen, rather than relying on polling or scheduled tasks. As with a message queue and topics, it helps decouple applications and services. An application or service can publish events, and any interested subscribers will be notified. New subscribers can be added without updating the sender.

Many Azure services support sending events to Event Grid. For example, a logic app can listen for an event when new files are added to a blob store. This pattern enables reactive workflows, where uploading a file or putting a message on a queue kicks off a series of processes. The processes might be executed in parallel or in a specific sequence.

## Recommendations

The recommendations described in [Basic enterprise integration][basic-enterprise-integration] apply to this architecture. The following recommendations also apply:

### Service Bus

Service Bus has two delivery modes, *pull* or *push*. In the pull model, the receiver continuously polls for new messages. Polling can be inefficient, especially if you have many queues that each receive a few messages, or if there a lot of time between messages. In the push model, Service Bus sends an event through Event Grid when there are new messages. The receiver subscribes to the event. When the event is triggered, the receiver pulls the next batch of messages from Service Bus.

When you create a logic app to consume Service Bus messages, we recommend using the push model with Event Grid integration. It's often more cost efficient, because the logic app doesn't need to poll Service Bus. For more information, see [Azure Service Bus to Event Grid integration overview](/azure/service-bus-messaging/service-bus-to-event-grid-integration-concept). Currently, Service Bus [Premium tier](https://azure.microsoft.com/pricing/details/service-bus/) is required for Event Grid notifications.

Use [PeekLock](/azure/service-bus-messaging/service-bus-messaging-overview#queues) for accessing a group of messages. When you use PeekLock, the logic app can perform steps to validate each message before completing or abandoning the message. This approach protects against accidental message loss.

### Event Grid

When an Event Grid trigger fires, it means *at least one* event happened. For example, when a logic app gets an Event Grid triggers for a Service Bus message, it should assume that several messages might be available to process.

## Scalability considerations

To achieve higher scalability, the Service Bus Premium tier can scale out the number of messaging units. Premium tier configurations can have one, two, or four messaging units. For more information about scaling Service Bus, see [Best practices for performance improvements by using Service Bus Messaging](/azure/service-bus-messaging/service-bus-performance-improvements).

## Availability considerations

Review the SLA for each service:

- [API Management SLA][apim-sla]
- [Event Grid SLA][event-grid-sla]
- [Logic Apps SLA][logic-apps-sla]
- [Service Bus SLA][sb-sla]

To enable failover if a serious outage occurs, consider implementing geo-disaster recovery in Service Bus Premium. For more information, see [Azure Service Bus geo-disaster recovery](/azure/service-bus-messaging/service-bus-geo-dr).

## DevOps considerations

See DevOps considerations in [Basic Enterprise Integration reference architecture](./basic-enterprise-integration.yml#devops-considerations)

## Security considerations

To secure Service Bus, use shared access signature (SAS). You can grant a user access to Service Bus resources with specific rights by using [SAS authentication](/azure/service-bus-messaging/service-bus-sas). For more information, see [Service Bus authentication and authorization](/azure/service-bus-messaging/service-bus-authentication-and-authorization).

If you need to expose a Service Bus queue or topic as an HTTP endpoint, for example, to post new messages, use API Management to secure the queue by fronting the endpoint. You can then secure the endpoint with certificates or OAuth authentication as appropriate. The easiest way to secure an endpoint is using a logic app with an HTTP request/response trigger as an intermediary.

The Event Grid service secures event delivery through a validation code. If you use Logic Apps to consume the event, validation is automatically performed. For more information, see [Event Grid security and authentication](/azure/event-grid/security-authentication).

## Cost Considerations

In general, use the [Azure pricing calculator][azure-pricing-calculator] to estimate costs. Here are some other considerations.

### API Management

You are charged for all API Management instances when they are running. If you have scaled up and don't need that level of performance all the time, manually scale down or configure [autoscaling][apim-autoscale].

### Logic Apps

Logic Apps uses a [serverless](/azure/logic-apps/logic-apps-serverless-overview) model. Billing is calculated based on action and connector execution. For more information, see [Logic Apps pricing](https://azure.microsoft.com/pricing/details/logic-apps/).

### Service Bus queues, topics and subscriptions

Service Bus queues and subscriptions support both push and pull models for delivering messages. In the pull model, every polling request is metered as an action. Even with long polling at 30 secs (default), cost can be high. Unless you need real-time delivery of messages, consider using the push model.

Service Bus queues are included in all tiers (Basic, standard, and premium tiers). While Service Bus topics and subscriptions are available in standard and premium tiers. For more information, see [Azure Service Bus pricing][service-bus-pricing].

### Event Grid

Event Grid uses a serverless model. Billing is calculated based on the number of operations (event executions). Operations include ingress of events to Domains or Topics, advanced matches, delivery attempts, and management calls. Usage of up to 100,000 operations is free of charge.

For more information, see [Event Grid pricing](https://azure.microsoft.com/pricing/details/event-grid/).

For more information, see the cost section in [Microsoft Azure Well-Architected Framework][aaf-cost].

## Next steps

- [Basic enterprise integration on Azure](./basic-enterprise-integration.yml)
- [Enterprise business intelligence](../data/enterprise-bi-synapse.yml)
- [Custom Business Processes](../../solution-ideas/articles/custom-business-processes.yml)

[aaf-cost]: /azure/architecture/framework/cost/overview
[apim]: /azure/api-management
[apim-sla]: https://azure.microsoft.com/support/legal/sla/api-management
[apim-autoscale]: /azure/api-management/api-management-howto-autoscale
[azure-pricing-calculator]: https://azure.microsoft.com/pricing/calculator
[event-grid]: /azure/event-grid
[event-grid-sla]: https://azure.microsoft.com/support/legal/sla/event-grid
[logic-apps]: /azure/logic-apps/logic-apps-overview
[logic-apps-sla]: https://azure.microsoft.com/support/legal/sla/logic-apps
[sb-sla]: https://azure.microsoft.com/support/legal/sla/service-bus
[service-bus]: /azure/service-bus-messaging
[service-bus-pricing]: https://azure.microsoft.com/pricing/details/service-bus
[basic-enterprise-integration]: ./basic-enterprise-integration.yml

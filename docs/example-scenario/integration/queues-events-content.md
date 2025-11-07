This architecture is based on the [basic enterprise integration][basic-enterprise-integration] architecture but includes how to integrate enterprise back-end systems. This architecture uses message brokers and events to decouple services for greater scalability and reliability. Ensure that you're familiar with the design and components in the basic integration architecture. These elements provide foundational information about the core components of this architecture.

## Architecture

The back-end systems that this design references include software as a service (SaaS) systems, Azure services, message-based services, and existing web services in your enterprise.

:::image type="content" source="./media/enterprise-integration-message-broker-events.svg" alt-text="Diagram that shows a reference architecture for enterprise integration that uses queues and events." border="false" lightbox="./media/enterprise-integration-message-broker-events.svg":::

*Download a [Visio file](https://arch-center.azureedge.net/queues-events.vsdx) of this architecture*.

### Scenario details

The preceding architecture builds on the simpler [basic enterprise integration architecture][basic-enterprise-integration] that uses [Azure Logic Apps][logic-apps] to orchestrate workflows directly with back-end systems and uses [Azure API Management][apim] to create catalogs of APIs.

This version of the architecture adds two components that help make the system more reliable and scalable:

- [Azure Service Bus][service-bus] is a secure, reliable message broker.

- [Azure Event Grid][event-grid] is an event-routing service. It uses a [publish and subscribe](../../patterns/publisher-subscriber.yml) eventing model.

This architecture uses asynchronous communication via a message broker instead of making direct, synchronous calls to back-end services. Asynchronous communication provides the following advantages:

- Uses the [Queue-Based Load Leveling pattern](../../patterns/queue-based-load-leveling.yml) to handle bursts in workloads via load-leveling

- Uses the [Publisher-Subscriber pattern](../../patterns/publisher-subscriber.yml) so that you can broadcast messages to multiple consumers
- Tracks the progress of long-running workflows reliably, even when they involve multiple steps or multiple applications
- Helps to decouple applications
- Integrates with existing message-based systems
- Provides the ability to queue messages when a back-end system isn't available

Use Event Grid so that various components in the system can react to events when they happen, rather than relying on polling or scheduled tasks. Similar to a message queue and topics, Event Grid helps decouple applications and services. If an application or service publishes events, any interested subscribers are notified. You can add new subscribers without updating the sender.

Many Azure services support sending events to Event Grid. For example, a logic app can listen for an event when new files are added to a blob store. This pattern creates reactive workflows in which uploading a file or putting a message on a queue starts a series of processes. The processes might run in parallel or in a specific sequence.

## Recommendations

Consider the following recommendations. For more recommendations, see [Basic enterprise integration architecture][basic-enterprise-integration].

### Service Bus

Service Bus has two delivery models, the *pull* model and the *proxied push* model:

- **Pull model:** The receiver continuously polls for new messages. If you need to manage multiple queues and polling times, polling might be inefficient. But this model can simplify your architecture because it removes extra components and data hops.

- **Proxied push model:** The receiver initially subscribes to a specific event type on an Event Grid topic. When a new message is available, Service Bus raises and sends an event through Event Grid. This event then triggers the receiver to pull the next batch of messages from Service Bus. This model allows systems to receive messages almost in real time but without using resources to continuously poll for new messages. This architecture uses extra components that you must deploy, manage, and secure.

When you create a Standard Logic Apps workflow that consumes Service Bus messages, we recommend that you use the Service Bus built-in connector triggers. The built-in connector triggers abstract most of the pull model configuration without adding extra cost. This capability provides the right balance between cost, surface area management, and security because the connector continuously loops within the Logic Apps runtime engine. For more information, see [Service Bus built-in connector triggers](/azure/connectors/connectors-create-api-servicebus#service-bus-built-in-connector-triggers).

Use [PeekLock mode](/azure/service-bus-messaging/message-transfers-locks-settlement#peeklock) to access a group of messages. When you use PeekLock, the logic app can perform steps to validate each message before completing or abandoning the message. This approach prevents accidental message loss.

### Event Grid

When an Event Grid trigger fires, it means that *at least one* event happened. For example, when a logic app gets an Event Grid trigger for a Service Bus message, there might be several messages available to process.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability helps ensure that your application can meet the commitments that you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

- **Microsoft Entra ID** is a globally distributed, highly available SaaS platform.

- You can deploy **API Management** in several highly available configurations, according to business requirements and cost tolerance. For more information, see [Ensure API Management availability and reliability](/azure/api-management/high-availability).
- The **Logic Apps** Consumption tier supports geo-redundant storage. For more information, see [Business continuity and disaster recovery for Logic Apps](/azure/logic-apps/business-continuity-disaster-recovery-guidance).
- **Event Grid** resource definitions for topics, system topics, domains, and event subscriptions and event data are automatically replicated across [availability zones](/azure/reliability/availability-zones-overview) in a region. When there's a failure in one of the availability zones, Event Grid resources automatically fail over to another availability zone without any human intervention. For more information, see [Cross-region disaster recovery and business continuity](/azure/reliability/reliability-event-grid#cross-region-disaster-recovery-and-business-continuity).
- **Service Bus** Premium supports [geo-disaster recovery](/azure/service-bus-messaging/service-bus-outages-disasters#geo-disaster-recovery) and [availability zones](/azure/service-bus-messaging/service-bus-outages-disasters#availability-zones). Service Bus Standard supports [replication](/azure/service-bus-messaging/service-bus-outages-disasters#protection-against-outages-and-disasters). 

For information about guaranteed availability details of each service, see [SLAs for online services][apim-sla].

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

To help secure Service Bus, pair [Microsoft Entra authentication](/azure/service-bus-messaging/service-bus-authentication-and-authorization#azure-active-directory) with [managed identities](/azure/service-bus-messaging/service-bus-managed-service-identity). Microsoft Entra ID integration for Service Bus resources provides Azure role-based access control (Azure RBAC) for fine-grained control over a client's access to resources. You can use Azure RBAC to grant permissions to a security principal, such as a user, a group, or an application service principal. The application service principal in this scenario is a managed identity.

If you can't use Microsoft Entra ID, use [shared access signature (SAS) authentication](/azure/service-bus-messaging/service-bus-authentication-and-authorization#shared-access-signature) to [grant users access and specific rights](/azure/service-bus-messaging/service-bus-sas) to Service Bus resources.

If you need to expose a Service Bus queue or topic as an HTTP endpoint, for example, to post new messages, use API Management to help secure the queue by fronting the endpoint. You can then use certificates or OAuth authentication to help secure the endpoint. The easiest way to help secure an endpoint is to use a logic app that has an HTTP request or response trigger as an intermediary.

The Event Grid service helps secure event delivery through a validation code. If you use Logic Apps to consume the event, validation is automatic. For more information, see [Event Grid security and authentication](/azure/event-grid/security-authentication).

#### Network security

Consider network security throughout your design.

- You can bind [Service Bus Premium](/azure/service-bus-messaging/network-security) to a virtual network subnet service endpoint. This configuration helps secure the namespace because it only accepts traffic from authorized virtual networks. You can also use [Azure Private Link](/azure/private-link/private-link-overview) to only allow private traffic to your virtual network via [private endpoints](/azure/service-bus-messaging/network-security#private-endpoints).

- You can configure [Logic Apps Standard and Premium](/azure/logic-apps/secure-single-tenant-workflow-virtual-network-private-endpoint) to accept inbound traffic through [private endpoints](/azure/logic-apps/secure-single-tenant-workflow-virtual-network-private-endpoint#set-up-inbound-traffic-through-private-endpoints) and to send outbound traffic through [virtual network integration](/azure/logic-apps/secure-single-tenant-workflow-virtual-network-private-endpoint#set-up-outbound-traffic-using-virtual-network-integration).
- You can use an Azure virtual network to help secure access to your API Management instance and APIs. This method supports [private endpoints](/azure/api-management/virtual-network-concepts#inbound-private-endpoint). For more information, see [Use a virtual network with API Management](/azure/api-management/virtual-network-concepts).

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

Use the [Azure pricing calculator][azure-pricing-calculator] to estimate costs. Here are some other considerations.

#### API Management

You're charged for all API Management instances when they run. If you scale up, and then you no longer need that level of performance, manually scale down or configure [autoscaling][apim-autoscale].

For light usage workloads, consider the [Consumption tier](/azure/api-management/api-management-features), which is a low-cost, serverless option. The Consumption tier is billed per API call. Other tiers are billed per hour.

#### Logic Apps

Logic Apps uses a [serverless model](/azure/logic-apps/logic-apps-serverless-overview). Billing is calculated based on the number of actions and connector calls. For more information, see [Logic Apps pricing](https://azure.microsoft.com/pricing/details/logic-apps/).

#### Service Bus queues, topics, and subscriptions

Service Bus queues and subscriptions support both proxied push and pull models to deliver messages. In the pull model, every polling request is metered as an action. Even if you set long polling to the default of 30 seconds, cost can be high. Unless you need real-time message delivery, consider using the proxied push model.

Service Bus queues are included in all tiers: Basic, Standard, and Premium. Service Bus topics and subscriptions are available in Standard and Premium tiers. For more information, see [Service Bus pricing][service-bus-pricing].

#### Event Grid

Event Grid uses a serverless model. Billing is calculated based on the number of operations. Operations include events that go to domains or topics, advanced matches, delivery attempts, and management calls. Usage of up to 100,000 operations is free of charge.

For more information, see [Event Grid pricing](https://azure.microsoft.com/pricing/details/event-grid/) and [Well-Architected Framework Cost Optimization][aaf-cost].

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

The basic enterprise integration reference architecture provides [guidance about DevOps patterns](../../reference-architectures/enterprise-integration/basic-enterprise-integration.yml#devops), which align to the Well-Architected Framework [Operational Excellence](/azure/well-architected/operational-excellence/checklist) pillar. 

Automate recovery operations as much as possible to help improve operational excellence. With automation in mind, you can combine [Azure log monitoring](/azure/service-bus-messaging/service-bus-insights) with [Azure Automation](/azure/automation/overview) to automate the failover of your Service Bus resources. For an example of automation logic to initiate a failover, see [Failover flow](/azure/service-bus-messaging/service-bus-geo-dr#failover-flow).

### Performance Efficiency

Performance Efficiency refers to your workload's ability to scale to meet user demands efficiently. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

To achieve higher scalability, the Service Bus Premium tier can scale out the number of messaging units. For more information, see [Service Bus Premium and Standard messaging tiers](/azure/service-bus-messaging/service-bus-premium-messaging) and [Autoscaling feature](/azure/service-bus-messaging/automate-update-messaging-units).

For more Service Bus recommendations, see [Best practices for performance improvements by using Service Bus messaging](/azure/service-bus-messaging/service-bus-performance-improvements).

## Next steps

- [Service Bus to Event Grid integration overview](/azure/service-bus-messaging/service-bus-to-event-grid-integration-concept)
- [Tutorial that uses messaging to integrate non-Microsoft systems via NServiceBus](https://docs.particular.net/tutorials/nservicebus-sagas/3-integration/)

## Related resources

- [Basic enterprise integration on Azure](../../reference-architectures/enterprise-integration/basic-enterprise-integration.yml)
- [Use Microsoft Fabric to design an enterprise BI solution](../../example-scenario/analytics/enterprise-bi-microsoft-fabric.yml)


[aaf-cost]: /azure/architecture/framework/cost/overview
[apim]: /azure/api-management
[apim-sla]: https://www.microsoft.com/licensing/docs/view/Service-Level-Agreements-SLA-for-Online-Services
[apim-autoscale]: /azure/api-management/api-management-howto-autoscale
[azure-pricing-calculator]: https://azure.microsoft.com/pricing/calculator
[event-grid]: /azure/event-grid
[event-grid-sla]: https://azure.microsoft.com/support/legal/sla/event-grid
[logic-apps]: /azure/logic-apps/logic-apps-overview
[logic-apps-sla]: https://azure.microsoft.com/support/legal/sla/logic-apps
[sb-sla]: https://azure.microsoft.com/support/legal/sla/service-bus
[service-bus]: /azure/service-bus-messaging
[service-bus-pricing]: https://azure.microsoft.com/pricing/details/service-bus
[basic-enterprise-integration]: ../../reference-architectures/enterprise-integration/basic-enterprise-integration.yml
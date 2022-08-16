---
author: bgener
ms.author: bogenera
ms.topic: include
ms.service: architecture-center
---

| AWS service | Azure service | Description |
|-------------|---------------|-------------|
| [Simple Queue Service (SQS)](https://aws.amazon.com/sqs) | [Queue Storage](https://azure.microsoft.com/services/storage/queues) | Provides a managed message queueing service for communicating between decoupled application components. |
| [Simple Notification Service (SNS)](https://aws.amazon.com/sns) | [Service Bus](https://azure.microsoft.com/services/service-bus) | Supports a set of cloud-based, message-oriented middleware technologies, including reliable message queuing and durable publish/subscribe messaging. |
| [Amazon EventBridge](https://aws.amazon.com/eventbridge) | [Event Grid](https://azure.microsoft.com/services/event-grid) | A fully managed event routing service that allows for uniform event consumption using a publish/subscribe model. |
| [Amazon Kinesis](https://aws.amazon.com/kinesis/) | [Event Hubs](https://azure.microsoft.com/services/event-hubs) | A fully managed, real-time data ingestion service. Stream millions of events per second, from any source, to build dynamic data pipelines and to immediately respond to business challenges. |
| [Amazon MQ](https://docs.aws.amazon.com/amazon-mq) | [Service Bus](/azure/service-bus-messaging/migrate-jms-activemq-to-servicebus) | Service Bus Premium is fully compliant with the Java/Jakarta EE Java Message Service (JMS) 2.0 API. Service Bus Standard supports the JMS 1.1 subset focused on queues. |

### Messaging architectures

<ul class="grid">

[!INCLUDE [Anomaly Detector Process](../../includes/cards/anomaly-detector-process.md)]
[!INCLUDE [Scalable Web App](../../includes/cards/scalable-web-app.md)]
[!INCLUDE [Enterprise integration](../../includes/cards/queues-events.md)]
[!INCLUDE [Ops Automation using Event Grid](../../includes/cards/ops-automation-using-event-grid.md)]

</ul>

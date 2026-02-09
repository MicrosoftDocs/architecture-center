---
title: Comparing AWS and Azure messaging services
description: Compare messaging service differences between Azure and AWS. Know Azure equivalents for Simple Email Service, Simple Queue Service, and messaging components.
author: johnkoukgit
ms.author: johnkoukaras
ms.date: 08/10/2021
ms.topic: concept-article
ms.subservice: cloud-fundamentals
ms.collection: 
 - migration
 - aws-to-azure
---

# Messaging services on Azure and AWS

## Simple Email Service

AWS provides the Simple Email Service (SES) for sending notification, transactional, or marketing emails. In Azure, you can send emails with [Azure Communication Services](https://azure.microsoft.com/products/communication-services) or third-party solutions, like [SendGrid](https://sendgrid.com/partners/azure). Both of these options provide email services that can be incorporated into solutions to cater for various use cases.

## Simple Queue Service

AWS Simple Queue Service (SQS) provides a messaging system for connecting applications, services, and devices within the AWS platform. Azure has two services that provide similar functionality:

- [Queue storage](/azure/storage/queues/storage-quickstart-queues-nodejs?tabs=passwordless%2Croles-azure-portal%2Cenvironment-variable-windows%2Csign-in-azure-cli) is a cloud messaging service that allows communication between application components within Azure.

- [Service Bus](https://azure.microsoft.com/services/service-bus) is a robust messaging system for connecting applications, services, and devices. By using the related [Service Bus relay](/azure/service-bus-relay/relay-what-is-it), Service Bus can also connect to remotely hosted applications and services.

### Integrating between Azure and AWS messaging services

If there is one set of components using Amazon SQS that needs to integrate with another set of components that uses Azure Service Bus, or vice versa, that can be done using the [Messaging Bridge pattern](/azure/architecture/patterns/messaging-bridge).

## Messaging components

| AWS service | Azure service | Description |
|-------------|---------------|-------------|
| [Simple Queue Service (SQS)](https://aws.amazon.com/sqs) | [Queue Storage](https://azure.microsoft.com/services/storage/queues) | Provides a managed message queueing service for communicating between decoupled application components. |
| [Simple Notification Service (SNS)](https://aws.amazon.com/sns) | [Service Bus](https://azure.microsoft.com/services/service-bus) | Supports a set of cloud-based, message-oriented middleware technologies, including reliable message queuing and durable publish/subscribe messaging. |
| [Amazon EventBridge](https://aws.amazon.com/eventbridge) | [Event Grid](https://azure.microsoft.com/services/event-grid) | A fully managed event routing service that allows for uniform event consumption using a publish/subscribe model. |
| [Amazon Kinesis](https://aws.amazon.com/kinesis/) | [Event Hubs](https://azure.microsoft.com/services/event-hubs) | A fully managed, real-time data ingestion service. Stream millions of events per second, from any source, to build dynamic data pipelines and to immediately respond to business challenges. |
| [Amazon MQ](https://docs.aws.amazon.com/amazon-mq) | [Service Bus](/azure/service-bus-messaging/migrate-jms-activemq-to-servicebus) | Service Bus Premium complies with the Java/Jakarta EE Java Message Service (JMS) 2.0 API. Service Bus Standard supports the JMS 1.1 subset focused on queues. |

### Messaging architectures

| Architecture | Description |
|----|----|
| [Scalable web application](/azure/architecture/web-apps/app-service/architectures/baseline-zone-redundant) | Use the proven practices in this reference architecture to improve scalability and performance in an Azure App Service web application. |
| [Enterprise integration by using queues and events](/azure/architecture/example-scenario/integration/queues-events) | A recommended architecture for implementing an enterprise integration pattern with Azure Logic Apps, Azure API Management, Azure Service Bus, and Azure Event Grid. |

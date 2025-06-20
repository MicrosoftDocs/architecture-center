---
title: Comparing AWS and Azure messaging services
description: Compare messaging service differences between Azure and AWS. Know Azure equivalents for Simple Email Service, Simple Queue Service, and messaging components.
author: splitfinity-zz-zz
ms.author: yubaijna
ms.date: 08/10/2021
ms.topic: conceptual
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

[!INCLUDE [Messaging Components](../../includes/aws/messaging.md)]

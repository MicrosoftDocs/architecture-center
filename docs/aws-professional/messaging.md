---
title: Comparing AWS and Azure messaging services
description: A comparison of the differences between messaging services between Azure and AWS
author: doodlemania2
ms.date: 05/21/2020
ms.topic: reference
ms.service: architecture-center
ms.subservice: cloud-fundamentals
---

# Messaging services on Azure and AWS

## Simple Email Service

AWS provides the Simple Email Service (SES) for sending notification, transactional, or marketing emails. In Azure, third-party solutions like [SendGrid](https://sendgrid.com/partners/azure) provide email services.

## Simple Queueing Service

AWS Simple Queueing Service (SQS) provides a messaging system for connecting applications, services, and devices within the AWS platform. Azure has two services that provide similar functionality:

- [Queue storage](/azure/storage/queues/storage-nodejs-how-to-use-queues): a cloud messaging service that allows communication between application components within Azure.

- [Service Bus](https://azure.microsoft.com/services/service-bus): a more robust messaging system for connecting applications, services, and devices. The service supports both message queues and publish-subscribe topics and standard protocols, i.e. HTTP/REST API (synchronous) and AMQP (asynchronous, guaranteed message delivery) to send and receive messages. Using the related [Service Bus relay](/azure/service-bus-relay/relay-what-is-it), Service Bus can also connect to remotely hosted applications and services.

## Messaging components

[!INCLUDE [Messaging Components](../../includes/aws/messaging.md)]
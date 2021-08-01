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

AWS provides the Simple Email Service (SES) which enables devdelopers to support several email use cases including transactional, marketing or mass email communications. In Azure, third-party solutions like [SendGrid](https://sendgrid.com/partners/azure) provide email services which can be incorporated into solutions to cater for various use cases. 

## Simple Queueing Service

AWS Simple Queueing Service (SQS) is a fully managed message queuing service that enables developers to decouple and scale microservices, distributed systems, and serverless applications. Azure has two services that provide similar functionality:

- [Queue storage](/azure/storage/queues/storage-nodejs-how-to-use-queues): a cloud messaging service that allows communication between application components within Azure.

- [Service Bus](https://azure.microsoft.com/services/service-bus): a robust messaging system for connecting applications, services, and devices. Using the related [Service Bus relay](/azure/service-bus-relay/relay-what-is-it), Service Bus can also connect to remotely hosted applications and services.

## Messaging components

[!INCLUDE [Messaging Components](../../includes/aws/messaging.md)]

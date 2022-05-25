---
title: Comparing AWS and Azure messaging services
description: Compare messaging service differences between Azure and AWS. Know Azure equivalents for Simple Email Service, Simple Queueing Service, and messaging components.
author: bgener
categories: azure
ms.author: bogenera
ms.date: 08/10/2021
ms.topic: reference
ms.service: architecture-center
ms.subservice: cloud-fundamentals
azureCategories:
  - databases
  - web
products:
  - azure
  - azure-queue-storage
  - azure-service-bus
---

# Messaging services on Azure and AWS

## Simple Email Service

AWS provides the Simple Email Service (SES) for sending notification, transactional, or marketing emails. In Azure, third-party solutions, like [SendGrid](https://sendgrid.com/partners/azure), provide email services that can be incorporated into solutions to cater for various use cases.

## Simple Queueing Service

AWS Simple Queueing Service (SQS) provides a messaging system for connecting applications, services, and devices within the AWS platform. Azure has two services that provide similar functionality:

- [Queue storage](/azure/storage/queues/storage-nodejs-how-to-use-queues) is a cloud messaging service that allows communication between application components within Azure.

- [Service Bus](https://azure.microsoft.com/services/service-bus) is a robust messaging system for connecting applications, services, and devices. By using the related [Service Bus relay](/azure/service-bus-relay/relay-what-is-it), Service Bus can also connect to remotely hosted applications and services.

## Messaging components

[!INCLUDE [Messaging Components](../../includes/aws/messaging.md)]

---
title: Azure Messaging cost estimates
description: Describes cost strategies for messaging services
author: v-aangie
ms.date: 09/04/2020
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
products:
  - azure-event-grid
ms.custom:
  - article
---

# Azure messaging cost estimates

The messaging services in this article have no up-front cost or termination fees, and you pay only for what you use. In some cases, it's advantageous to combine two messaging services to increase the efficiency of your messaging system. See [Crossover scenarios](../../guide/technology-choices/messaging.md#crossover-scenarios) for examples.

Cost is based on the number of operations or throughput units used depending on the message service. Using the wrong messaging service for the intent can lead to higher costs. Before choosing a service, first, determine the intent and requirements of the messages. Then, consider the tradeoffs between cost and operations/throughput units. For tradeoff examples, see [Technology choices for a message broker](../../guide/technology-choices/messaging.md#technology-choices-for-a-message-broker).

Use the [Azure Pricing calculator](https://azure.microsoft.com/pricing/calculator/) for help creating various cost scenarios.

## Service Bus cost

Connect on-premises and cloud-based applications and services to implement highly secure messaging workflows using Service Bus. Cost is based on messaging operations and number of connections. The Basic tier is the cheapest. If you want more operations and features, choose the Standard or Premium tier. For example, [Service Bus](../../reference-architectures/enterprise-integration/queues-events.yml#service-bus) Premium runs in dedicated resources to provide higher throughput and more consistent performance.

For pricing details, see [Service Bus pricing](https://azure.microsoft.com/pricing/details/service-bus/).

## Event Grid cost

Manage routing of all events from any source to any destination to simplify event-based app development using Event Grid. [Event Grid](../../reference-architectures/serverless/cloud-automation.yml#event-grid) can route a massive number of events per second per region. Cost is based on number of operations performed. Examples of some operations are event ingress, subscription delivery attempts, management calls, and filtering by subject suffix.

For pricing details, see [Event Grid pricing](https://azure.microsoft.com/pricing/details/event-grid/).

## Event Hubs

Stream millions of events per second from any source to build dynamic data pipelines and immediately respond to business challenges using Event Hubs. Cost is based on throughput units. A key difference between Event Grid and Event Hubs is in the way event data is made available to subscribers. For more information, see [Pull model](../../guide/technology-choices/messaging.md#pull-model-1).

For questions and answers on pricing, see [Pricing](/azure/event-hubs/event-hubs-faq#pricing).

For pricing, see [Event Hubs pricing](https://azure.microsoft.com/pricing/details/event-hubs/).

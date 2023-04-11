---
title: Messaging patterns
titleSuffix: Cloud Design Patterns
description: Use these messaging patterns to support cloud applications by using a messaging that connects the components and services in a manner to maximize scalability.
author: martinekuan
ms.author: architectures
ms.date: 07/28/2022
ms.topic: design-pattern
ms.service: architecture-center
ms.subservice: design-pattern
ms.custom:
  - design-pattern
keywords:
  - design pattern
products: azure
categories: featured
---

# Messaging patterns

The distributed nature of cloud applications requires a messaging infrastructure that connects the components and services, ideally in a loosely coupled manner in order to maximize scalability. Asynchronous messaging is widely used, and provides many benefits, but also brings challenges such as the ordering of messages, poison message management, idempotency, and more.

| Pattern | Summary |
| ------- | ------- |
| [Asynchronous Request-Reply](../async-request-reply.yml) | Decouple backend processing from a frontend host, where backend processing needs to be asynchronous, but the frontend still needs a clear response. |
| [Claim Check](../claim-check.yml) | Split a large message into a claim check and a payload to avoid overwhelming a message bus. |
| [Choreography](../choreography.yml) | Have each component of the system participate in the decision-making process about the workflow of a business transaction, instead of relying on a central point of control. |
| [Competing Consumers](../competing-consumers.yml) | Enable multiple concurrent consumers to process messages received on the same messaging channel. |
| [Pipes and Filters](../pipes-and-filters.yml) | Break down a task that performs complex processing into a series of separate elements that can be reused. |
| [Priority Queue](../priority-queue.yml) | Prioritize requests sent to services so that requests with a higher priority are received and processed more quickly than those with a lower priority. |
| [Publisher-Subscriber](../publisher-subscriber.yml) | Enable an application to announce events to multiple interested consumers asynchronously, without coupling the senders to the receivers. |
| [Queue-Based Load Leveling](../queue-based-load-leveling.yml) | Use a queue that acts as a buffer between a task and a service that it invokes in order to smooth intermittent heavy loads. |
| [Saga](../reference-architectures/saga/saga.yml) | It a way to manage data consistency across microservices in distributed transaction scenarios. A saga is a sequence of transactions that updates each service and publishes a message or event to trigger the next transaction step. |
| [Scheduler Agent Supervisor](../scheduler-agent-supervisor.yml) | Coordinate a set of actions across a distributed set of services and other remote resources. |
| [Sequential Convoy](../sequential-convoy.yml) | Process a set of related messages in a defined order, without blocking processing of other groups of messages. |

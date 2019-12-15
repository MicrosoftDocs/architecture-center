---
title: Messaging patterns
titleSuffix: Cloud Design Patterns
description: The distributed nature of cloud applications requires a messaging infrastructure that connects the components and services, ideally in a loosely coupled manner in order to maximize scalability. Asynchronous messaging is widely used, and provides many benefits, but also brings challenges such as the ordering of messages, poison message management, idempotency, and more.
keywords: design pattern
author: dragon119
ms.date: 10/24/2019
ms.topic: design-pattern
ms.service: architecture-center
ms.subservice: cloud-fundamentals
ms.custom: seodec18
---

# Messaging patterns

The distributed nature of cloud applications requires a messaging infrastructure that connects the components and services, ideally in a loosely coupled manner in order to maximize scalability. Asynchronous messaging is widely used, and provides many benefits, but also brings challenges such as the ordering of messages, poison message management, idempotency, and more.

| Pattern | Summary |
| ------- | ------- |
| [Asynchronous Request-Reply](../async-request-reply.md) | Decouple backend processing from a frontend host, where backend processing needs to be asynchronous, but the frontend still needs a clear response. |
| [Claim Check](../claim-check.md) | Split a large message into a claim check and a payload to avoid overwhelming a message bus. | 
| [Choreography](../choreography.md) | Have each component of the system participate in the decision-making process about the workflow of a business transaction, instead of relying on a central point of control. |
| [Competing Consumers](../competing-consumers.md) | Enable multiple concurrent consumers to process messages received on the same messaging channel. |
| [Pipes and Filters](../pipes-and-filters.md) | Break down a task that performs complex processing into a series of separate elements that can be reused. |
| [Priority Queue](../priority-queue.md) | Prioritize requests sent to services so that requests with a higher priority are received and processed more quickly than those with a lower priority. |
| [Publisher-Subscriber](../publisher-subscriber.md) | Enable an application to announce events to multiple interested consumers asynchronously, without coupling the senders to the receivers. |
| [Queue-Based Load Leveling](../queue-based-load-leveling.md) | Use a queue that acts as a buffer between a task and a service that it invokes in order to smooth intermittent heavy loads. |
| [Scheduler Agent Supervisor](../scheduler-agent-supervisor.md) | Coordinate a set of actions across a distributed set of services and other remote resources. |
| [Sequential Convoy](../sequential-convoy.md) | Process a set of related messages in a defined order, without blocking processing of other groups of messages. |

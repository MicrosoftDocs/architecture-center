---
title: Messaging patterns
description: The distributed nature of cloud applications requires a messaging infrastructure that connects the components and services, ideally in a loosely coupled manner in order to maximize scalability. Asynchronous messaging is widely used, and provides many benefits, but also brings challenges such as the ordering of messages, poison message management, idempotency, and more.
keywords: design pattern
author: dragon119
ms.date: 06/23/2017

pnp.series.title: Cloud Design Patterns
---

# Messaging patterns

[!INCLUDE [header](../../_includes/header.md)]

The distributed nature of cloud applications requires a messaging infrastructure that connects the components and services, ideally in a loosely coupled manner in order to maximize scalability. Asynchronous messaging is widely used, and provides many benefits, but also brings challenges such as the ordering of messages, poison message management, idempotency, and more.


|                            Pattern                             |                                                                        Summary                                                                         |
|----------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------|
|        [Competing Consumers](../competing-consumers.md)        |                            Enable multiple concurrent consumers to process messages received on the same messaging channel.                            |
|          [Pipes and Filters](../pipes-and-filters.md)          |                       Break down a task that performs complex processing into a series of separate elements that can be reused.                        |
|             [Priority Queue](../priority-queue.md)             | Prioritize requests sent to services so that requests with a higher priority are received and processed more quickly than those with a lower priority. |
|  [Queue-Based Load Leveling](../queue-based-load-leveling.md)  |              Use a queue that acts as a buffer between a task and a service that it invokes in order to smooth intermittent heavy loads.               |
| [Scheduler Agent Supervisor](../scheduler-agent-supervisor.md) |                              Coordinate a set of actions across a distributed set of services and other remote resources.                              |


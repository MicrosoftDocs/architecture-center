---
title: Performance testing and antipatterns
description: Build scalability solutions for common stressors by learning about performance antipatterns. These are common practices that are likely to cause scalability problems when an application is under pressure.
author: johndowns
ms.author: jodowns
ms.date: 08/23/2021
ms.topic: design-pattern
ms.service: architecture-center
ms.subservice: anti-pattern
ms.custom:
  - article
  - seo-aac-fy21q3
keywords:
  - antipatterns
  - antipattern
  - scalability solutions
  - anti-pattern
  - performance testing
products:
  - azure
categories:
  - management-and-governance
  - security
---

# Performance testing and antipatterns for cloud applications

*Performance antipatterns*, much like design patterns, are common defective processes and implementations within organizations. These are common practices that are likely to cause scalability problems when an application is under pressure. Awareness of these practices can help simplify communicating high-level concepts among software practitioners.

Here is a common scenario: An application behaves well during performance testing. It's released to production and begins to handle real workloads. At that point, it performs poorly, rejecting user requests, stalling, or throwing exceptions. The development team is then faced with two questions:

- Why didn't this behaviour show up during testing?
- How do we fix it?

The answer to the first question is straightforward. It's difficult to simulate real users in a test environment, their behaviour patterns and the volumes of work they might perform. The only completely sure way to understand how a system behaves under load is to observe it in production. To be clear, we don't suggest skipping performance testing. Performance testing is crucial for getting baseline performance metrics. But you must be prepared to observe and correct performance issues in the live system.

The answer to the second question, how to fix the problem, is less straightforward. Several factors might contribute, and sometimes the problem only manifests under certain circumstances. Instrumentation and logging are vital to finding the root cause, but you must also know what to look for.

Based on our engagements with Microsoft Azure customers, we've identified some of the most common performance issues customers see in production. For each antipattern, we describe why the antipattern typically occurs, the symptoms of the antipattern, and techniques for resolving the problem. We also provide a sample code illustrating the antipattern and a suggested scalability solution.

Some of these antipatterns may seem obvious when you read the descriptions, but they occur more often than you might think. Sometimes an application inherits a design that worked on-premises but doesn't scale in the cloud. Or an application might start with a very clean design, but as new features are added, one or more of these antipatterns creeps in. Regardless, this guide will help you to identify and fix these antipatterns.

## Catalog of antipatterns

Here is the list of the antipatterns that we've identified:

| Antipattern | Description |
|-------------|-------------|
| [Busy Database][BusyDatabase] | Offloading too much processing to a data store. |
| [Busy Front End][BusyFrontEnd] | Moving resource-intensive tasks onto background threads. |
| [Chatty I/O][ChattyIO] | Continually sending many small network requests. |
| [Extraneous Fetching][ExtraneousFetching] | Retrieving more data than is needed, resulting in unnecessary I/O. |
| [Improper Instantiation][ImproperInstantiation] | Repeatedly creating and destroying objects that are designed to be shared and reused. |
| [Monolithic Persistence][MonolithicPersistence] | Using the same data store for data with very different usage patterns. |
| [No Caching][NoCaching] | Failing to cache data. |
| [Noisy Neighbor][NoisyNeighbor] | A single tenant uses a disproportionate amount of the resources. |
| [Retry Storm][RetryStorm] | Retrying failed requests to a server too often. |
| [Synchronous I/O][SynchronousIO] | Blocking the calling thread while I/O completes. |

## Next steps

For more about performance tuning, see [Performance tuning a distributed application](../performance/index.md)

<!-- links -->

[BusyDatabase]: ./busy-database/index.md
[BusyFrontEnd]: ./busy-front-end/index.md
[ChattyIO]: ./chatty-io/index.md
[ExtraneousFetching]: ./extraneous-fetching/index.md
[ImproperInstantiation]: ./improper-instantiation/index.md
[MonolithicPersistence]: ./monolithic-persistence/index.md
[NoCaching]: ./no-caching/index.md
[NoisyNeighbor]: ./noisy-neighbor/noisy-neighbor.yml
[RetryStorm]: ./retry-storm/index.md
[SynchronousIO]: ./synchronous-io/index.md

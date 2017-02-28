---
title: Optimize Performance for Cloud Applications
description: 

author: dragon119
manager: christb

pnp.series.title: Optimize Performance
---
# Introduction
[!INCLUDE [header](../_includes/header.md)]

## What not to do if you want your systems to be fast and scalable

Building applications that you can deploy to the cloud by using Azure is relatively simple. Building applications that scale well and run fast under a heavy load in the cloud is more difficult. A common scenario is that an application appears to perform well during performance testing and displays no problems. But once it is released to the cloud, accessed by a large number of concurrent users, and subjected to a much bigger, more random workload it frequently exhibits undesirable behavior (such as rejecting user requests, stalling, or throwing exceptions). The development team is then faced with two questions:

1. Why did this behavior not show up during testing? and
2. How do we fix it?

The answer to the first question is straightforward. It is very difficult to simulate the actions of real-world users, their patterns of behavior, or the volumes of work they might perform in an artificial test environment. The only comprehensive way to understand how the system behaves under load is to instrument and monitor it while it is in production. This doesn't mean that you shouldn't perform any kind of performance testing. Rather, you should accept that performance testing is unlikely to provide a complete indicator of system behavior and be prepared to observe and correct performance issues when they arise in the live system.

The answer to the second question is less straightforward. To fix the problem requires understanding what the problem actually is. This can be difficult as it might only manifest itself under a particular set of circumstances. Again, instrumentation and logging are vitally important to determining these circumstances. However, having an insight into some of the most common misconceptions about cloud applications and the resultant impact that they can have on performance is also useful. That is the purpose of the cloud performance anti-patterns presented here. 

A performance anti-pattern illustrates an example of common practice that is likely to cause scalability problems once an application is placed under pressure. These practices might be followed without question in applications designed to run on-premises where expensive hardware and fast networks are prevalent. But the cloud is a different environment and applications have to be designed to cope with slower, more unpredictable networks and run on commodity hardware. In the cloud, scale-out is a more viable solution than scale-up, but if an application is not designed with scale-out in mind it can quickly reach the limits of its performance.

These anti-patterns represent some of the most frequent causes of issues that we have experienced in cloud-based systems, both during our own internal developments and in customer engagements. We have documented the reasons why they typically occur, their symptoms, and possible techniques that you can use to resolve them. We have included sample code depicting the original problem and a suggested solution. Part of this documentation includes a generalized detection strategy based on the sample code; you should be able to adapt the general guidance provided to your own circumstances. We have also described the impact of the solution and any knock-on consequences that it might have elsewhere in the system.

The current catalog of cloud performance anti-patterns contains the following items:

- **[Busy Database][BusyDatabase]** describes what might happen if you offload too much processing to an intelligent data store.

- **[Busy Front End][BusyFrontEnd]** describes the situation where all of the work is performed in a single tier of a cloud application.

- **[Chatty I/O][ChattyIO]** illustrates the effects of implementing a system that makes many small network requests.

- **[Extraneous Fetching][ExtraneousFetching]** highlights what can happen if an application retrieves data that it may or may not need in a speculative manner.

- **[Improper Instantiation][ImproperInstantiation]** describes the effects of repeatedly creating and destroying objects that are designed to be shared and reused.

- **[Monolithic Persistence][MonolithicPersistence]** illustrates the impact on database performance if the same data store is used as the repository for data that follows distinctly different usage patterns such as logging, session state, and business information.

- **[No Caching][NoCaching]** summarizes the effects of failing to cache information adequately (or at all).

- **[Synchronous I/O][SynchronousIO]** describes how performing I/O operations synchronously can consume resources and seriously impact scalability. 

[BusyDatabase]: ./busy-database/index.md
[BusyFrontEnd]: ./busy-front-end/index.md
[ChattyIO]: ./chatty-io/index.md
[ExtraneousFetching]: ./extraneous-fetching/index.md
[ImproperInstantiation]: ./improper-instantiation/index.md
[MonolithicPersistence]: ./monolithic-persistence/index.md
[NoCaching]: ./no-caching/index.md
[SynchronousIO]: ./synchronous-io/index.md
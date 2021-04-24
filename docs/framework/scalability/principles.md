---
title: Principles of the performance efficiency
description: Describes the performance efficiency guiding principles
author: a11smiles
ms.date: 04/23/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
ms.custom:
  - overview
---

# Performance efficiency principles

These principles guide you through improving performance efficiency.

- **Establish performance baselines**&mdash;    Baselines help to determine the current efficiency state of your application and its supporting infrastructure. Use the insights for improvements and determine if the application is meeting business goals. 

- **Invest in capacity planning**&mdash;Plan for  fluctuation in expected load that can occur because of world events. Test variations of load prior to events, including unexpected ones, to ensure that your application can scale. Make sure all regions can adequately scale to support total load, if a region fail. Take into consideration:
    - Technology and the SKU service limits.
    - SLAs when determining the services to use in the design. Also, the SLAs of those services.
    - Cost to determine the how much improvement will be realized in the application if costs are increased. Evaluate the cost is worth the investment. 

- [**Run performance testing in the scope of development**](performance-test.md)&mdash;Any development effort must go through continuous performance testing. The tests make sure that _any_ change to the codebase does not negatively affect the application's performance. Establish a regular cadence for running the tests. Run the test as part of a scheduled event or part of a continuous integration (CI) build pipeline. 

- [**Run load tests**](performance-test#load-testing)&mdash;Load testing measures your application's performance under predetermined amounts of load. 

- [**Run stress tests**](performance-test#stress-testing)&mdash;Stress testing measures the _maximum_ load your application and its infrastructure can support before it buckles.

- [**Identify bottlenecks**]()&mdash;A bottlenecks is an area within your application that can hinder performance. Typically, a bottleneck worsens as load increases. Bottlenecks can be the result of deficiencies in code or misconfiguration of a service.

- [**Continuously monitor**](monitor.md)&mdash;Monitor new services​ and the health of current workloads. While creating your monitoring strategy, consider scalability _and_ but resiliency of the infrastructure, application, and dependent services. For scalability, look at the metrics would allow you to provision resources dynamically and scale with demand. Troubleshoot an application's performance through continuous monitoring and reliable investigation.

- **Have a data-driven approach**&mdash;Base your decisions on the data captured from repeatable processes. Retain data monitor performance changes  _over time_, not just compared to the last measurement taken. 

- [**Identify improvement opportunities**](optimize.md)&mdash;Enable and use telemetry throughout your application. Compare your code to proven architectures in the [Cloud Design Patterns](../../patterns/index-patterns) and identify [anti-patterns](azure/architecture/antipatterns/) in your code. Optimize by considering other Azure services that may be more appropriate for your objectives. 
  

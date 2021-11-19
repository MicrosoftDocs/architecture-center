---
title: Testing tools
description: Review testing tools for performance efficiency. Identify baselines and goals for performance. Cache data, run benchmark tests, and use metrics.
author: v-aangie
ms.date: 12/02/2020
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
products:
  - devops
categories:
  - management-and-governance
ms.custom:
  - How are you handling user load?
  - article
---

# Testing tools

There are multiple stages in the development and deployment life cycle in which tests can be performed. Application code, infrastructure automation, and fault tolerance should all be tested. This can ensure that the application will perform as expected in every situation. You'll want to test early enough in the application life cycle to catch and fix errors. Errors are cheaper to repair when caught early and can be expensive or impossible to fix later.

Testing can be automated or manual. Automating tests is the best way to make sure that they are executed. Depending on how frequently tests are performed, they are typically limited in duration and scope. Manual testing is run much less frequently. For a list of tests that you should consider while developing and deploying applications, see [Testing your application and Azure environment](../devops/release-engineering-testing.md).

## Identify baselines and goals for performance

Knowing where you are (baseline) and where you want to be (goal) makes it easier to plan how to get there. Established baselines and goals will help you to stay on track and measure progress. Testing may also uncover a need to perform additional testing on areas that you may not have planned.

Baselines can vary based on connections or platforms used to accessing the application. It may be important to establish baselines that address the different connections, platforms, and elements such as time of day, or weekday versus weekend.

There are many types of goals when determining baselines for application performance. Some examples are, the time it takes to render a page, or a desired number of transactions if your site conducts e-commerce. The following list shows some examples of questions that may help you to determine goals.

What are your baselines and goals for:

- Establishing an initial connection to a service?
- An API endpoint complete response?
- Server response times?
- Latency between systems/microservices?
- Database queries?

## Caching data

Caching can dramatically improve performance, scalability, and availability. The more data that you have, the greater the benefits of caching become. Caching typically works well with data that is immutable or that changes infrequently. Examples include reference information such as product and pricing information in an e-commerce application, or shared static resources that are costly to construct. Some or all of this data can be loaded into the cache at application startup to minimize demand on resources and to improve performance.

Use performance testing and usage analysis to determine whether pre-populating or on-demand loading of the cache, or a combination of both, is appropriate. The decision should be based on the volatility and usage pattern of the data. Cache utilization and performance analysis are particularly important in applications that encounter heavy loads and must be highly scalable.

To learn more about how to use caching as a solution in testing, see [Caching](../../best-practices/caching.md#determine-how-to-cache-data-effectively).

### Use Azure Redis to cache data

Azure Cache for Redis is a caching service that can be accessed from any Azure application, whether the application is implemented as a cloud service, a website, or inside an Azure virtual machine. Caches can be shared by client applications that have the appropriate access key. It is a high-performance caching solution that provides availability, scalability, and security.

To learn more about using Azure Cache for Redis, see [Considerations for implementing caching in Azure](../../best-practices/caching.md#considerations-for-implementing-caching-in-azure).

## Content delivery network

Content delivery networks (CDNs) are typically used to deliver static content such as images, style sheets, documents, client-side scripts, and HTML pages. The major advantages of using a CDN are lower latency and faster delivery of content to users, regardless of their geographical location in relation to the datacenter where the application is hosted. CDNs can help to reduce load on a web application because the application does not have to service requests for the content that is hosted in the CDN. Using a CDN is a good way to minimize the load on your application, and maximize availability and performance. Consider adopting this strategy for all of the appropriate content and resources your application uses.

Decide how you will handle local development and testing when some static content is expected to be served from a CDN. For example, you could pre-deploy the content to the CDN as part of your build script. Alternatively, use compile directives or flags to control how the application loads the resources. For example, in debug mode, the application could load static resources from a local folder. In release mode, the application would use the CDN.

To learn more about CDNs, see [Best practices for using content delivery networks (CDNs)](../../best-practices/cdn.md).

## Benchmark testing

Benchmarking is the process of simulating different workloads on your application and measuring application performance for each workload. It is the best way to figure out what resources you will need to host your application. Use performance indicators to assess whether your application is performing as expected or not. Take into consideration [VM sizes](/azure/virtual-machines/premium-storage-performance#high-scale-vm-sizes) and [disk sizes](/azure/virtual-machines/premium-storage-performance#premium-storage-disk-sizes).

See the [Optimize IOPS, throughput, and latency](/azure/virtual-machines/premium-storage-performance#optimize-iops-throughput-and-latency-at-a-glance) table for guidance.

## Metrics

Metrics measure trends over time. They are available for interactive analysis in the Azure portal with Azure Metrics Explorer. Metrics also can be added to an Azure dashboard for visualization in combination with other data and used for near-real time alerting.

Performance testing gives you the ability to see specific details on the processing capabilities of applications. You'll most likely want a monitoring tool that allows you to discover proactively if the issues you find through testing are appearing in both your infrastructure and applications. [Azure Monitor Metrics](/azure/azure-monitor/platform/data-platform-metrics) is a feature of Azure Monitor that collects metrics from monitored resources into a time series database.

With [Azure Monitor](/azure/azure-monitor/overview), you can collect, analyze, and act on telemetry from your cloud and on-premises environments. It helps you understand how applications are performing and identifies issues affecting them and the resources they depend on.

For a list of Azure metrics, see [Supported metrics with Azure Monitor](/azure/azure-monitor/platform/metrics-supported).

## Next steps

> [!div class="nextstepaction"]
> [Performance monitoring](./checklist.md)

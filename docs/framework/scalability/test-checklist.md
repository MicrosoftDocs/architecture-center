---
title: Checklist - Testing for performance efficiency
titleSuffix: Azure Testing Review Framework
description: Checklist guidance for testing concerns for Azure performance efficiency.
author: v-aangie
ms.date: 01/08/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
ms.custom:
  - testing checklist
---

# Checklist - Testing for performance efficiency

Performance testing helps to maintain systems properly and fix defects before problems reach system users. It is part of the Performance Efficiency pillar in the [Microsoft Azure Well-Architected Framework](../index.md). Use this checklist to review your application architecture from a performance testing standpoint. 

## Performance testing

- **Ensure solid performance testing with shared *team* responsibility**. Successfully implementing meaningful performance tests requires a number of resources. It is not just a single developer or QA Analyst running some tests on their local machine. Instead, performance tests need a test environment (also known as a test bed) that tests can be executed against without interfering with production environments and data. Performance testing requires input and commitment from developers, architects, database administrators, and network administrators.

- **Identify a path forward to leveraging existing tests or the creation of new tests**. There are different types of performance testing: load testing, stress testing, API testing, client-side/browser testing, etc. It is important that you understand and articulate the different types of tests, along with their advantages and disadvantages, to the customer.

- **Perform testing in all stages in the development and deployment life cycle**.  Application code, infrastructure automation, and fault tolerance should all be tested. This can ensure that the application will perform as expected in every situation. You'll want to test early enough in the application life cycle to catch and fix errors. Errors are cheaper to repair when caught early and can be expensive or impossible to fix later. To learn more, see [Testing your application and Azure environment](../devops/release-engineering-testing.md).

- **Avoid experiencing poor performance with testing**. Two subsets of performance testing, load testing and stress testing, can determine the upper (close to capacity limit) and maximum (point of failure) limit, respectively, of the application's capacity. By performing these tests, you can determine the necessary infrastructure to support the anticipated workloads.

- **Plan for a load buffer to accommodate random spikes without overloading the infrastructure**. For example, if a normal system load is 100,000 requests per second, the infrastructure should support 100,000 requests at 80% of total capacity (i.e., 125,000 requests per second). If you anticipate that the application will continue to sustain 100,000 requests per second, and the current SKU (Stock Keeping Unit) introduces latency at 65,000 requests per second, you'll most likely need to upgrade your product to the next higher SKU. If there is a secondary region, you'll need to ensure that it also supports the higher SKU.

- **Test failover in multiregions**. Test the amount of time it would take for users to be rerouted to the paired region so that the region doesn't fail. Typically, a planned test failover can help determine how much time would be required to fully scale to support the redirected load.

- **Configure the environment based on testing results to sustain performance efficiency**. Scale out or scale in to handle increases and decreases in load. For example, you may know that you will encounter high levels of traffic during the day and low levels on weekends. You may configure the environment to scale out for increases in load or scale in for decreases before the load actually changes.

## Testing tools

- **Choose testing tools based on the type of performance testing you are attempting to execute**. There are various performance testing tools available for DevOps. Some tools like JMeter only perform testing against endpoints and tests HTTP statuses. Other tools such as K6 and Selenium can perform tests that also check data quality and variations. Application Insights, while not necessarily designed to test server load, can test the performance of an application within the user's browser.

- **Carry out performance profiling and load testing** during development, as part of test routines, and before final release to ensure the application performs and scales as required. This testing should occur on the same type of hardware as the production platform, and with the same types and quantities of data and user load as it will encounter in production.

- **Determine if it is better to use automated or manual testing**. Testing can be automated or manual. Automating tests is the best way to make sure that they are executed. Depending on how frequently tests are performed, they are typically limited in duration and scope. Manual testing is run much less frequently.

- **Cache data to improve performance, scalability, and availability**. The more data that you have, the greater the benefits of caching become. Caching typically works well with data that is immutable or that changes infrequently.

- **Decide how you will handle local development and testing when some static content is expected to be served from a content delivery network (CDN)**. For example, you could pre-deploy the content to the CDN as part of your build script. Alternatively, use compile directives or flags to control how the application loads the resources. For example, in debug mode, the application could load static resources from a local folder. In release mode, the application would use the CDN.

- **Simulate different workloads on your application and measure application performance for each workload**. This is the best way to figure out what resources you will need to host your application. Use performance indicators to assess whether your application is performing as expected or not.

## Next steps
> [!div class="nextstepaction"]
> [Performance testing](./performance-test.md)
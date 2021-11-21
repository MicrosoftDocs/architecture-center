---
title: Testing best practices for app reliability
description: Use best practices for reliability testing in Azure apps. Implement practices to meet your business requirements, so apps run in a healthy state with little downtime.
author: v-aangie
ms.date: 02/17/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
---

# Testing best practices for reliability in Azure applications

This article lists Azure best practices to enhance testing Azure applications for reliability. These best practices are derived from our experience with Azure reliability and the experiences of customers like yourself.

During the architectural phase, focus on implementing practices that meet your business requirements, and ensure that applications will run in a healthy state without significant downtime.

## Test regularly

Test regularly to validate existing thresholds, targets, and assumptions. Regular testing should be performed as part of each major change and if possible, on a regular basis. While most testing should be performed within the testing and staging environments, it is often beneficial to also run a subset of tests against the production system.

## Test for resiliency

To test resiliency, you should verify how the end-to-end workload performs under intermittent failure conditions. Consider performing the following tests:

- Performance testing
- Simulation testing
- Fault injection testing
- Load testing
- Operational readiness testing
- Failover and failback testing

## Design a backup strategy

Design a backup strategy that is tailored to the specific business requirements and circumstances of the application. At a high level, the approaches can be divided into these categories: 1) Redeploy on disaster, 2) Warm Spare (Active/Passive), and 3) Hot Spare (Active/Active).

## Design a disaster recovery strategy

When parts of the Azure network are inaccessible, you might not be able to access your application or data. In this situation, design a disaster recovery strategy to run most applications with reduced functionality.

## Codify steps to failover and fallback

Codify steps, preferably automatically, to failover and fallback the application to the primary region once a failover triggering issue has been addressed. Doing this should ensure capabilities exist to effectively respond to an outage in a way that limits impact.

## Plan for regional failures

Use Azure for creating applications that are distributed across regions. Such distribution helps to minimize the possibility that a failure in one region could affect other regions.

## Implement retry logic

Track the number of transient exceptions and retries over time to uncover issues or failures in your application's retry logic. A trend of increasing exceptions over time may indicate that the service is having an issue and may fail.

## Configure and test health probes

Configure and test health probes for your load balancers and traffic managers. Ensure that your health endpoint checks the critical parts of the system and responds appropriately.

## Segregate read and write interfaces

Achieve levels of scale and performance needed for your solution by segregating read and write interfaces by implementing the Command and Query Responsibility Segregation (CQRS) pattern.

## Next step

> [!div class="nextstepaction"]
> [Monitoring](./monitor-checklist.md)

> Go back to the main article: [Testing](test-checklist.md)

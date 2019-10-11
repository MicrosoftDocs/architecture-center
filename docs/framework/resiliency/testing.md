---
title: Testing
description: 
author: david-stanford
ms.date: 10/10/2019
ms.topic: article
ms.service: architecture-center
ms.subservice: cloud-design-principles
ms.custom: How do you test your applications to ensure they're fault tolerant? 
---

# Testing

To test resiliency, you should verify how the end-to-end workload performs under intermittent failure conditions.

Run tests in production using both synthetic and real user data. Test and production are rarely identical, so it's important to validate your application in production using a [blue-green](https://martinfowler.com/bliki/BlueGreenDeployment.html) or [canary deployment](https://martinfowler.com/bliki/CanaryRelease.html). This way, you're testing the application under real conditions, so you can be sure that it will function as expected when fully deployed.

As part of your test plan, include:

- Automated predeployment testing
- Fault injection testing
- Peak load testing
- Disaster recovery testing
- Third-party service testing

Testing is an iterative process. Test the application, measure the outcome, analyze and address any failures that result, and repeat the process.<!-- SetMe -->
[!include[a34ec312-6e4a-408b-b9ef-be034541f7bd](./guidance/a34ec312-6e4a-408b-b9ef-be034541f7bd.md)]

<!-- You perform testing in small, real-life situations. -->
[!include[e251193a-37cb-4116-a001-1bb74c08649a](./guidance/e251193a-37cb-4116-a001-1bb74c08649a.md)]

<!-- You are testing your workload by injecting faults. -->
[!include[1e7674b5-00c7-4ff8-9c43-269cc7c29680](./guidance/1e7674b5-00c7-4ff8-9c43-269cc7c29680.md)]

<!-- Perform Load Testing -->
[!include[0b1b8335-a3a2-405c-91dc-526abd02d841](./guidance/0b1b8335-a3a2-405c-91dc-526abd02d841.md)]


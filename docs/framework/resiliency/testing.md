---
title: Test apps for availability and resiliency
description: Testing is an iterative process. Test the application, measure the outcome, analyze and address any failures that result, and repeat the process.
author: v-aangie
ms.date: 02/17/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
ms.custom:
  - How do you test your applications to ensure they're fault tolerant?
  - article
---

# Testing applications for availability and resiliency

Applications should be tested to ensure *availability* and *resiliency*. Availability describes the amount of time when an application runs in a healthy state without significant downtime. Resiliency describes how quickly an application recovers from failure.

Being able to measure availability and resiliency can answer questions like, How much downtime is acceptable? How much does potential downtime cost your business? What are your availability requirements? How much do you invest in making your application highly available? What is the risk versus the cost? Testing plays a critical role in making sure your applications can meet these requirements.

## Key points

- Test regularly to validate existing thresholds, targets and assumptions.
- Automate testing as much as possible.
- Perform testing on both key test environments with the production environment.
- Verify how the end-to-end workload performs under intermittent failure conditions.
- Test the application against critical [non-functional requirements](./design-requirements.md) for performance.
- Conduct load testing with expected peak volumes to test scalability and performance under load.
- Perform chaos testing by injecting faults.

## When to test

Regular testing should be performed as part of each major change and if possible, on a regular basis to validate existing thresholds, targets and assumptions. While the majority of testing should be performed within the testing and staging environments, it is often beneficial to also run a subset of tests against the production system. Plan a 1:1 parity of key test environments with the production environment.

> [!NOTE]
> Automate testing where possible to ensure consistent test coverage and reproducibility. Automate common testing tasks and integrate them into your build processes. Manually testing software is tedious and susceptible to error, although manual explorative testing may also be conducted.

## Testing for resiliency

To test resiliency, you should verify how the end-to-end workload performs under intermittent failure conditions.

Run tests in production using both synthetic and real user data. Test and production are rarely identical, so it's important to validate your application in production using a [blue-green](https://martinfowler.com/bliki/BlueGreenDeployment.html) or [canary deployment](https://martinfowler.com/bliki/CanaryRelease.html). This way, you're testing the application under real conditions, so you can be sure that it will function as expected when fully deployed.

As part of your test plan, include:

- [Chaos engineering](./chaos-engineering.md)
- [Automated pre-deployment testing](../../checklist/dev-ops.md#testing)
- [Fault injection testing](#fault-injection-testing)
- [Peak load testing](../scalability/performance-test.md#load-testing)
- [Disaster recovery testing](./backup-and-recovery.md#failover-and-failback-testing)

## Performance testing

The primary goal of performance testing is to validate benchmark behavior for the application. Performance testing is the superset of both *load testing* and *stress testing*.

Load testing validates application scalability by rapidly and/or gradually increasing the load on the application until it reaches a threshold/limit. Stress testing involves various activities to overload existing resources and remove components to understand overall resiliency and how the application responds to issues.

## Simulation testing

Simulation testing involves creating small, real-life situations. Simulations demonstrate the effectiveness of the solutions in the recovery plan and highlight any issues that weren't adequately addressed.

As you perform simulation testing, follow best practices:

- Conduct simulations in a manner that doesn't disrupt actual business but feels like a real situation.
- Make sure that simulated scenarios are completely controllable. If the recovery plan seems to be failing, you can restore the situation back to normal without causing damage.
- Inform management about when and how the simulation exercises will be conducted. Your plan should detail the time frame and the resources affected during the simulation.

## Fault injection testing

For fault injection testing, check the resiliency of the system during failures, either by triggering actual failures or by simulating them. Here are some strategies to induce failures:

- Shut down virtual machine (VM) instances.
- Crash processes.
- Expire certificates.
- Change access keys.
- Shut down the DNS service on domain controllers.
- Limit available system resources, such as RAM or number of threads.
- Unmount disks.
- Redeploy a VM.

Your test plan should incorporate possible failure points identified during the design phase, in addition to common failure scenarios:

- Test your application in an environment as close to production as possible.
- Test failures in combination.
- Measure the recovery times, and be sure that your business requirements are met.
- Verify that failures don't cascade and are handled in an isolated way.

## Test under peak loads

Load testing is crucial for identifying failures that only happen under load, such as the back-end database being overwhelmed or service throttling. Test for peak load and anticipated increase in peak load, using production data or synthetic data that is as close to production data as possible. Your goal is to see how the application behaves under real-world conditions.

## Next step

> [!div class="nextstepaction"]
> [Backup and recovery](./backup-and-recovery.md)

## Related links

- For more test types, see [Test types](../../checklist/dev-ops.md#testing).
- To learn about load and stress tests, see [Performance testing](../scalability/performance-test.md).
- To learn about chaos testing, see [Chaos engineering](./chaos-engineering.md).

 Go back to the main article: [Testing](test-checklist.md)

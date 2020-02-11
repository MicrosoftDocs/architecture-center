---
title: Testing Azure applications for resiliency and availability
description: Testing is an iterative process. Test the application, measure the outcome, analyze and address any failures that result, and repeat the process.
author: david-stanford
ms.date: 10/16/2019
ms.topic: article
ms.service: architecture-center
ms.subservice: cloud-design-principles
ms.custom: How do you test your applications to ensure they're fault tolerant?
---

# Testing Azure applications for resiliency and availability

To test resiliency, you should verify how the end-to-end workload performs under intermittent failure conditions.

Run tests in production using both synthetic and real user data. Test and production are rarely identical, so it's important to validate your application in production using a [blue-green](https://martinfowler.com/bliki/BlueGreenDeployment.html) or [canary deployment](https://martinfowler.com/bliki/CanaryRelease.html). This way, you're testing the application under real conditions, so you can be sure that it will function as expected when fully deployed.

As part of your test plan, include:

- Automated predeployment testing
- Fault injection testing
- Peak load testing
- Disaster recovery testing
- Third-party service testing

## Simulation testing

Simulation testing involves creating small, real-life situations. Simulations demonstrate the effectiveness of the solutions in the recovery plan and highlight any issues that weren't adequately addressed.

As you perform simulation testing, follow best practices:

- Conduct simulations in a manner that doesn't disrupt actual business but feels like a real situation.
- Make sure that simulated scenarios are completely controllable. If the recovery plan seems to be failing, you can restore the situation back to normal without causing damage.
- Inform management about when and how the simulation exercises will be conducted. Your plan should detail the time frame and the resources affected during the simulation.

## Perform fault injection testing

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

For more information about failure scenarios, see [Failure and disaster recovery for Azure applications](/azure/architecture/framework/resiliency/backup-and-recovery).

## Test under peak loads

Load testing is crucial for identifying failures that only happen under load, such as the back-end database being overwhelmed or service throttling. Test for peak load and anticipated increase in peak load, using production data or synthetic data that is as close to production data as possible. Your goal is to see how the application behaves under real-world conditions.
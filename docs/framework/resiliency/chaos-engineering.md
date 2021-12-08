---
title: Chaos engineering
description: Understand chaos engineering fundamentals for improving the reliability of a service that's built on Azure.
author: v-aangie
ms.date: 02/17/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
ms.custom:
  - How do you chaos-engineer your applications to ensure that they're fault tolerant?
  - article
---

# Chaos engineering

Chaos engineering is a methodology that helps developers attain consistent reliability by hardening services against failures in production. Another way to think about chaos engineering is that it's about embracing the inherent chaos in complex systems and, through experimentation, growing confidence in your solution's ability to handle it.

A common way to introduce chaos is to deliberately inject faults that cause system components to fail. The goal is to observe, monitor, respond to, and improve your system's reliability under adverse circumstances. For example, taking dependencies offline (stopping API apps, shutting down VMs, etc.), restricting access (enabling firewall rules, changing connection strings, etc.), or forcing failover (database level, Front Door, etc.), is a good way to validate that the application is able to handle faults gracefully.

It's difficult to simulate the characteristics of a service's behavior at scale outside a production environment. The transient nature of cloud platforms can exacerbate this difficulty. Architecting your service to expect failure is a core approach to creating a modern service. Chaos engineering embraces the uncertainty of the production environment and strives to anticipate rare, unpredictable, and disruptive outcomes, so that you can minimize any potential impact on your customers.

## Key points

- Increase service resiliency and ability to react to failures.
- Apply chaos principles continuously.
- Create and organize a central chaos engineering team.
- Follow best practices for chaos testing.

## Increase resiliency

Chaos engineering is aimed at increasing your service's resiliency and its ability to react to failures. By conducting experiments in a controlled environment, you can identify issues that are likely to arise during development and deployment. During this process, be vigilant in adopting the following guidelines:

- Be proactive.
- Embrace failure.
- Break the system.
- Identify and address single points of failure early.
- Install guardrails and graceful mitigation.
- Minimize the blast radius.
- Build immunity.

Chaos engineering should be an integral part of development team culture and an ongoing practice, not a short-term tactical effort in response to a single outage.

Development team members are partners in the process. They must be equipped with the resources to triage issues, implement the testability that's required for fault injection, and drive the necessary product changes.

## When to apply chaos

Ideally, you should apply chaos principles continuously. There's constant change in the environments in which software and hardware run, so monitoring the changes is key. By constantly applying stress or faults on components, you can help expose issues early, before small problems are compounded by a number of other factors.

Apply chaos engineering principles when you're:

- Deploying new code.
- Adding dependencies.
- Observing changes in usage patterns.
- Mitigating problems.

## Process

Chaos engineering requires specialized expertise, technology, and practices. As with security and performance teams, the model of a central team supporting the service teams is a common, effective approach.

If you plan to practice the simulated handling of potentially catastrophic scenarios under controlled conditions, here's a simplified way to organize your teams:

|Attacker| Defender for Cloud|
|---|---|
|Inject faults| Assess|
|Provide hints|Analyze|
| |Mitigate|

### Goals

- Familiarize team members with monitoring tools.
- Recognize outage patterns.
- Learn how to assess the impact.
- Determine the root cause and mitigate accordingly.
- Practice log analysis.

### Overall method

1. Start with a hypothesis.
1. Measure baseline behavior.
1. Inject a fault or faults.
1. Monitor the resulting behavior.
1. Document the process and observations.
1. Identify and act on the result.

Periodically validate your process, architecture choices, and code. By conducting fault-injection experiments, you can confirm that monitoring is in place and alerts are set up, the *directly responsible individual* (DRI) process is effective, and your documentation and investigation processes are up to date. Keep in mind a few key considerations:

- Challenge system assumptions.
- Validate change (topology, platform, resources).
- Use service-level agreement (SLA) buffers.
- Use live-site outages as opportunities.

## Best practices

### Shift left

Shift-left testing means experiment early, experiment often. Incorporate fault-injection configurations and create resiliency-validation gates during the development stages and in the deployment pipeline.

### Shift right

Shift-right testing means that you verify that the service is resilient where it counts in a pre-production or production environment with actual customer load.  Adopt a proactive approach as opposed to reacting to failures. Be a part of determining and controlling requirements for the blast radius.

### Blast radius

Stop the experiment when it goes beyond scope. Unknown results are an expected outcome of chaos experiments. Strive to achieve balance between collecting substantial result data and affecting as few production users as possible. For an example of this principle in practice, see the [Bulkhead pattern](../../patterns/bulkhead.md) article.

### Error budget testing

Establish an error budget as an investment in chaos and fault injection. Your error budget is the difference between achieving 100% of the service-level objective (SLO) and achieving the *agreed-upon* SLO.

## Considerations for chaos testing

The following questions and answers discuss considerations about chaos engineering, based on its application inside Azure.

**Have you identified faults that are relevant to the development team?**
***

Work closely with the development teams to ensure the relevance of the injected failures. Use past incidents or issues as a guide. Examine dependencies and evaluate the results when those dependencies are removed.

An external team can't hypothesize faults for your team. A study of failures from an artificial source might be relevant to your team's purposes, but the effort must be justified.

**Have you injected faults in a way that accurately reflects production failures?**
***

Simulate production failures. Treat injected faults in the same way that you would treat production-level faults. Enforcing a tighter limit on the blast radius will enable you to simulate a production environment. Each fault-injection effort must be accompanied by tooling that's designed to inject the types of faults that are relevant to your team's scenarios. Here are two basic ways:

- Inject faults in a non-production environment, such as [Canary](../devops/release-engineering-testing.md#acceptance-testing) or [Test In Production](https://azure.microsoft.com/resources/videos/azure-friday-testing-in-production-with-azure-app-service/) (TIP).
- Partition the production service or environment.

Halt all faults and roll back the state to its last-known good configuration if the state seems severe.

**Have you built confidence incrementally?**
***

Start by hardening the core, and then expand out in layers. At each point, lock in progress with automated regression tests. Each team should have a long-term strategy based on a progression that makes sense for the team's circumstances.

By applying the [shift left](#shift-left) strategy, you can help ensure that any obstacles to developer usage are removed early and the testing results are actionable.

The process must be very *low tax*. That is, the process must make it easy for developers to understand what happened and to fix the issues. The effort must fit easily into their normal workflow, not burden them with one-off special activities.

## Next step

> [!div class="nextstepaction"]
> [Best practices](./test-best-practices.md)

## Related links

- For information on release testing, see [Testing your application and Azure environment](../devops/release-engineering-testing.md).
- For more information, see [Bulkhead pattern](../../patterns/bulkhead.md).

Go back to the main article: [Testing](test-checklist.md)

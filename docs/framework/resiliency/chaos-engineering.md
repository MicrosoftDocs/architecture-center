---
title: Chaos engineering
description: Chaos engineering fundamentals for improving the reliability of a service built on Azure.
author: absheik
ms.date: 04/03/2020
ms.topic: article
ms.service: architecture-center
ms.subservice: well-architected
ms.custom: How do you chaos-engineer your applications to ensure that they're fault tolerant?
---

# Chaos engineering

Chaos engineering is a methodology that helps developers attain consistent reliability by hardening services against failures in production. A common way to introduce chaos is to deliberately inject faults that cause system components to fail. The goal is to observe, monitor, respond to, and improve your system's reliability under adverse circumstances.

## Context

It's difficult to simulate the characteristics of a service's behavior at scale outside a production environment. The transient nature of cloud platforms can exacerbate this difficulty. Architecting your service to expect failure is a core approach to creating a modern service. Chaos engineering embraces the uncertainty of the production environment and strives to anticipate rare, unpredictable, and disruptive outcomes, so that you can minimize any potential impact on your customers.

## Principles

Chaos engineering is aimed at increasing your service’s resiliency and its ability to react to failures. By conducting experiments in a controlled environment, you can identify issues that are likely to arise during development and deployment. During this process, be vigilant in adopting the following guidelines:

- Be proactive.
- Embrace failure.
- Break the system.
- Identify and address single points of failure early.
- Install guardrails and graceful mitigations.
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

|Attacker|	Defender|
|---|---|
|Inject faults|	Assess|
|Provide hints|Analyze|
|	|Mitigate|

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
-	Challenge system assumptions.
-	Validate change (topology, platform, resources).
-	Use service-level agreement (SLA) buffers.
-	Use live-site outages as opportunities.

## Best practices

#### Shift left

Shift-left testing means experiment early, experiment often. Incorporate fault-injection configurations and create resiliency-validation gates during the development stages and in the deployment pipeline.

#### Shift right
Shift-right testing means that you verify that the service is resilient where it counts in a pre-production or production environment with actual customer load.  Adopt a proactive approach as opposed to reacting to failures. Be a part of determining and controlling requirements for the blast radius.

#### Blast radius
Stop the experiment when it goes beyond scope. Unknown results are an expected outcome of chaos experiments. Strive to achieve balance between collecting substantial result data and affecting as few production users as possible. For an example of this principle in practice, see the [Bulkhead pattern](../../patterns/bulkhead.md) article.

#### Error budget testing
Establish an error budget as an investment in chaos and fault injection. Your error budget is the difference between achieving 100% of the service-level objective (SLO) and achieving the *agreed-upon* SLO.

## Considerations
The following sections discuss additional considerations about chaos engineering, based on its application inside Azure.

### Identify faults that are relevant to the development team
Work closely with the development teams to ensure the relevance of the injected failures. Use past incidents or issues as a guide. Examine dependencies and evaluate the results when those dependencies are removed.

An external team can't hypothesize faults for your team. A study of failures from an artificial source might be relevant to your team's purposes, but the effort must be justified.  

### Inject faults in a way that accurately reflects production failures
Simulate production failures. Treat injected faults in the same way that you would treat production-level faults. Enforcing a tighter limit on the blast radius will enable you to simulate a production environment. Each fault-injection effort must must be accompanied by tooling that's designed to inject the types of faults that are relevant to your team's scenarios. Here are two basic ways:

-	Inject faults in a non-production environment, such as Canary or Test In Production (TIP).
-	Partition the production service or environment.

Halt all faults and roll back the state to its last-known good configuration if the state seems severe.

### Build confidence incrementally
Start by hardening the core, and then expand out in layers. At each point, lock in progress with automated regression tests. Each team should have a long-term strategy based on a progression that makes sense for the team's circumstances.

By applying the shift left strategy, you can help ensure that any obstacles to developer usage are removed early and the testing results are actionable.

The process must be very *low tax*. That is, the process must make it easy for developers to understand what happened and to fix the issues. The effort must fit easily into their normal workflow, not burden them with one-off special activities.

## Faults

The following table lists faults that you can apply to inject chaos. The list represents commonly injected faults and isn't intended to be exhaustive. 

:::row:::
    :::column:::
        **Resource pressure**
    :::column-end:::
    :::column:::
        CPU
    :::column-end:::
    :::column:::
        
    :::column-end:::
:::row-end:::
:::row:::
    :::column:::
        
    :::column-end:::
    :::column:::
        Memory
    :::column-end:::
    :::column:::
        *Physical*
    :::column-end:::
:::row-end:::
:::row:::
    :::column:::
        
    :::column-end:::
    :::column:::
        
    :::column-end:::
    :::column:::
        *Virtual*
    :::column-end:::
:::row-end:::
:::row:::
    :::column:::
        
    :::column-end:::
    :::column:::
        
    :::column-end:::
    :::column:::
        *bad checksum*
    :::column-end:::
:::row-end:::
:::row:::
    :::column:::
        
    :::column-end:::
    :::column:::
        Hard disk
    :::column-end:::
    :::column:::
        *Capacity*
    :::column-end:::
:::row-end:::
:::row:::
    :::column:::
        
    :::column-end:::
    :::column:::
        
    :::column-end:::
    :::column:::
        *Read*
    :::column-end:::
:::row-end:::
:::row:::
    :::column:::
        
    :::column-end:::
    :::column:::
        
    :::column-end:::
    :::column:::
        *Write*
    :::column-end:::
:::row-end:::
:::row:::
    :::column:::
        
    :::column-end:::
    :::column:::
        
    :::column-end:::
    :::column:::
        *Availability*
    :::column-end:::
:::row-end:::
:::row:::
    :::column:::
        
    :::column-end:::
    :::column:::
        
    :::column-end:::
    :::column:::
        *Data corruption*
    :::column-end:::
:::row-end:::
:::row:::
    :::column:::
        
    :::column-end:::
    :::column:::
        
    :::column-end:::
    :::column:::
        *Read / Write Latency*
    :::column-end:::
:::row-end:::
:::row:::
    :::column:::
        **Network**
    :::column-end:::
    :::column:::
        Layers
    :::column-end:::
    :::column:::
        *Transport (TCP/UDP)*
    :::column-end:::
:::row-end:::
:::row:::
    :::column:::
        
    :::column-end:::
    :::column:::
        
    :::column-end:::
    :::column:::
        *Application layer (HTTP)*
    :::column-end:::
:::row-end:::
:::row:::
    :::column:::
        
    :::column-end:::
    :::column:::
        Types
    :::column-end:::
    :::column:::
        *Disconnect*
    :::column-end:::
:::row-end:::
:::row:::
    :::column:::
        
    :::column-end:::
    :::column:::
        
    :::column-end:::
    :::column:::
        *Latency*
    :::column-end:::
:::row-end:::
:::row:::
    :::column:::
        
    :::column-end:::
    :::column:::
        
    :::column-end:::
    :::column:::
        *Alter response codes (HTTP)*
    :::column-end:::
:::row-end:::
:::row:::
    :::column:::
        
    :::column-end:::
    :::column:::
        
    :::column-end:::
    :::column:::
        *Packet reorder / loss (TCP/UDP)*
    :::column-end:::
:::row-end:::
:::row:::
    :::column:::
        
    :::column-end:::
    :::column:::
        
    :::column-end:::
    :::column:::
        *# of connections (active / passive)*
    :::column-end:::
:::row-end:::
:::row:::
    :::column:::
        
    :::column-end:::
    :::column:::
        
    :::column-end:::
    :::column:::
        *DOS attack*
    :::column-end:::
:::row-end:::
:::row:::
    :::column:::
        
    :::column-end:::
    :::column:::
        Filters
    :::column-end:::
    :::column:::
        *Domain / IP / Subnet*
    :::column-end:::
:::row-end:::
:::row:::
    :::column:::
        
    :::column-end:::
    :::column:::
        
    :::column-end:::
    :::column:::
        *URL path*
    :::column-end:::
:::row-end:::
:::row:::
    :::column:::
        
    :::column-end:::
    :::column:::
        
    :::column-end:::
    :::column:::
        *Port / Protocol*
    :::column-end:::
:::row-end:::
:::row:::
    :::column:::
        
    :::column-end:::
    :::column:::
        
    :::column-end:::
    :::column:::
        *DNS Host Name resolution*
    :::column-end:::
:::row-end:::
:::row:::
    :::column:::
        **Process**
    :::column-end:::
    :::column:::
        Stop / Kill
    :::column-end:::
    :::column:::
        
    :::column-end:::
:::row-end:::
:::row:::
    :::column:::
        
    :::column-end:::
    :::column:::
        Restart
    :::column-end:::
    :::column:::
        
    :::column-end:::
:::row-end:::
:::row:::
    :::column:::
        
    :::column-end:::
    :::column:::
        Stop service
    :::column-end:::
    :::column:::
        
    :::column-end:::
:::row-end:::
:::row:::
    :::column:::
        
    :::column-end:::
    :::column:::
        Start
    :::column-end:::
    :::column:::
        
    :::column-end:::
:::row-end:::
:::row:::
    :::column:::
        
    :::column-end:::
    :::column:::
        Crash
    :::column-end:::
    :::column:::
        
    :::column-end:::
:::row-end:::
:::row:::
    :::column:::
        
    :::column-end:::
    :::column:::
        Hang
    :::column-end:::
    :::column:::
        
    :::column-end:::
:::row-end:::
:::row:::
    :::column:::
        **Virtual Machine**
    :::column-end:::
    :::column:::
        Stop
    :::column-end:::
    :::column:::
        
    :::column-end:::
:::row-end:::
:::row:::
    :::column:::
        
    :::column-end:::
    :::column:::
        Restart
    :::column-end:::
    :::column:::
        
    :::column-end:::
:::row-end:::
:::row:::
    :::column:::
        
    :::column-end:::
    :::column:::
        BSOD
    :::column-end:::
    :::column:::
        
    :::column-end:::
:::row-end:::
:::row:::
    :::column:::
        
    :::column-end:::
    :::column:::
        Change date
    :::column-end:::
    :::column:::
        
    :::column-end:::
:::row-end:::
:::row:::
    :::column:::
        
    :::column-end:::
    :::column:::
        Re-image
    :::column-end:::
    :::column:::
        
    :::column-end:::
:::row-end:::
:::row:::
    :::column:::
        
    :::column-end:::
    :::column:::
        Live Migration
    :::column-end:::
    :::column:::
        
    :::column-end:::
:::row-end:::
:::row:::
    :::column:::
        **Platform**
    :::column-end:::
    :::column:::
        Quorum loss
    :::column-end:::
    :::column:::
        
    :::column-end:::
:::row-end:::
:::row:::
    :::column:::
        
    :::column-end:::
    :::column:::
        Data loss
    :::column-end:::
    :::column:::
        
    :::column-end:::
:::row-end:::
:::row:::
    :::column:::
        
    :::column-end:::
    :::column:::
        Move primary node
    :::column-end:::
    :::column:::
        
    :::column-end:::
:::row-end:::
:::row:::
    :::column:::
        
    :::column-end:::
    :::column:::
        Remove replica
    :::column-end:::
    :::column:::
        
    :::column-end:::
:::row-end:::
:::row:::
    :::column:::
        **Functions**
    :::column-end:::
    :::column:::
        Latency
    :::column-end:::
    :::column:::
        
    :::column-end:::
:::row-end:::
:::row:::
    :::column:::
        
    :::column-end:::
    :::column:::
        Exceptions
    :::column-end:::
    :::column:::
        
    :::column-end:::
:::row-end:::
:::row:::
    :::column:::
        
    :::column-end:::
    :::column:::
        Status codes
    :::column-end:::
    :::column:::
        
    :::column-end:::
:::row-end:::
:::row:::
    :::column:::
        
    :::column-end:::
    :::column:::
        Intercept / Denylist calls
    :::column-end:::
    :::column:::
        
    :::column-end:::
:::row-end:::
:::row:::
    :::column:::
        
    :::column-end:::
    :::column:::
        Disk capacity
    :::column-end:::
    :::column:::
        
    :::column-end:::
:::row-end:::
:::row:::
    :::column:::
        **Application specific**
    :::column-end:::
    :::column:::
        Intercept / Re-route calls
    :::column-end:::
    :::column:::
        *No access to service code*
    :::column-end:::
:::row-end:::
:::row:::
    :::column:::
        **Hardware**
    :::column-end:::
    :::column:::
        Machine
    :::column-end:::
    :::column:::
        *Storage*
    :::column-end:::
:::row-end:::
:::row:::
    :::column:::
        
    :::column-end:::
    :::column:::
        Network devices
    :::column-end:::
    :::column:::
        
    :::column-end:::
:::row-end:::
:::row:::
    :::column:::
        
    :::column-end:::
    :::column:::
        Rack
    :::column-end:::
    :::column:::
        
    :::column-end:::
:::row-end:::
:::row:::
    :::column:::
        
    :::column-end:::
    :::column:::
        UPS
    :::column-end:::
    :::column:::
        
    :::column-end:::
:::row-end:::
:::row:::
    :::column:::
        
    :::column-end:::
    :::column:::
        Datacenter
    :::column-end:::
    :::column:::
        
    :::column-end:::
:::row-end:::

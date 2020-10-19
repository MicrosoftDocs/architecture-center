---
title: Chaos engineering
description: Chaos engineering fundamentals for improving the reliability of a service built on Azure.
author: absheik
ms.date: 04/03/2020
ms.topic: article
ms.service: architecture-center
ms.subservice: well-architected
ms.custom: How do you chaos engineer your applications to ensure they're fault tolerant?
---

# Chaos engineering

Chaos engineering is a methodology that helps developers attain consistent reliability by hardening services against failures in production. A common way to introduce chaos is to deliberately inject fault that causes system components to fail. The goal is to observe, monitor, respond to, and improve your system's reliability under these circumstances.

## Context

It's very difficult to simulate the characteristics of a service's behavior outside a production environment at scale. The transient nature of a cloud platform exacerbates this problem. Architecting your service to expect failure is a core tenant of a modern service. Chaos engineering embraces the uncertainty of production and strives to precipitate rare, unpredictable, and disruptive outcomes early, so customer impact is minimized.

## Principles

Chaos engineering is aimed at increasing your service’s resiliency and the ability to react to failures. By conducting experiments in a controlled environment, you can identify issues during development and deployment.

- Be Proactive
- Embrace failure
- Break the system
- Identify and address single points of failure early
- Instill guardrails and graceful mitigations
- Minimize blast radius
- Build immunity
- Chaos engineering should be a part of the development team culture and an ongoing practice, not a short-term tactical effort in response to an outage.

Development team are partners in the process. They must have resources to triage issues, implement testability required for fault injection, and drive the necessary product changes.

## When to apply chaos
Ideally chaos should be applied all the time.  There is constant change in the environments in which software and hardware runs. So, monitoring the change is key. Constant application of stress or faults on components will help expose issues early before a small issue gets compounded by a number of other factors.

- Deploying new code.
- Adding dependencies.
- Usage pattern changing.
- Mitigating problems.

## Process
Chaos engineering requires specialized expertise, technology, and practices. Similar to security and performance teams, the model of a central team supporting the service teams is a common effective approach.

Here is one way of organizing teams that are practicing simulated handling of potentially catastrophic scenarios under controlled conditions.

|Attacker|	Defender|
|---|---|
|Inject faults|	Assess|
|Provide hints|Analyze|
|	|Mitigate|

### Goals 
-	Familiarize the members with monitoring tools
-	Recognize outage patterns
-	Learn how to assess the impact
-	Determine the root-cause and mitigate accordingly
-	Practice log analysis

### Overall method
1.	Start with a hypothesis.
2.	Measure baseline behavior.
3.	Inject a fault or faults.
4.	Monitor the resulting behavior.
5.	Document the process and the observations.
6.	Identify and act on the result.

Validate the process, architecture choices, and code, periodically. Fault injection experiments help confirm that monitoring is in place and alerts are set up, the Directly Responsible Individual (DRI) process is effective, and that documentation and investigation steps are up to date.
-	Challenge system assumptions.
-	Validate change (topology, platform, resources).
-	Use Service Level Agreement (SLA) buffers.
-	Use live-site outages as opportunities.

## Best practices

#### Shifting left

Experiment early, experiment often. Incorporate fault injection configurations and create resiliency validation gates during your development stages and in the deployment pipeline.

#### Shifting right
Verify that the service is resilient where it counts in a pre-production or production environment with actual customer load.  Adopt a proactive approach as opposed to reacting to failures. Be a part of determining and controlling requirements for the blast radius.

#### Blast radius
Stop the experiment when it goes beyond scope. An expected outcome of experiments is unknown results. Strive to achieve balance between collecting substantial result data while affecting as few production users as possible. The [Bulkhead pattern](../../patterns/bulkhead.md) practices that principle.

#### Error Budget Testing
Establish an error budget as an investment in chaos and fault injection. Your error budget is difference between 100% and agreed-upon Service Level Objective (SLO).

## Considerations
Here are some considerations based on application of chaos engineering inside Azure.

### Identify faults that are relevant to the development team
Work closely with the development teams to ensure the relevance of the failures injected. Use past incidents or issues as a guide. Examine dependencies and evaluate the results when those dependencies are removed.

An external team cannot hypothesize faults for the team. A study of failures from an artificial source may be relevant to the team but the effort must be justified.  

### Inject the faults in a way that accurately reflects production failures
Simulate production failures. Treat the injected faults as production-level faults. A tighter limit on the blast radius will enable you to simulate a production environment. Each fault injection effort must have tooling designed explicitly to inject the types of faults that are relevant. Here are two basic ways:

-	Inject faults in a non-production environment like Canary or Test In Production (TIP).
-	Partition the production service or environment.

Halt all faults and roll state back to its last-known good configuration if the state seems severe.

### Build confidence incrementally
Starting with hardening the core and then expanding out in layers. At each point progress should be locked in with automated regression tests. Each team should have a long-term strategy based on a progression that makes sense for their circumstances.

Applying the shift left strategy ensure any obstacles for developer usage are removed and the results of the testing are actionable

It must be very low tax.
It must be easy for developers to understand what happened and fix the issues.  This must fit in their normal workflow easily, not a one-off special activity.

## Faults

Faults that can be leveraged to inject chaos.  



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

> [!NOTE]
> This is not intended to be an exhaustive list, but a representation of commonly injected faults.

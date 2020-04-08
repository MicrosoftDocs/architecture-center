---
title: Chaos Engineering
description: Chaos Engineering fundamentals for improving reliability of a service built on Azure
author: absheik
ms.date: 04/03/2020
ms.topic: article
ms.service: architecture-center
ms.subservice: cloud-design-principles
ms.custom: How do you Chaos engineer your applications to ensure they're fault tolerant?
---

# Chaos Engineering

Chaos Engineering is a practice used for enabling developers to attain consistent reliability by hardening their services against failures in production. Chaos engineering using fault injection is an approach of causing your systems components to fail deliberately.  The goal is to observe, monitor, respond to and improve your systems reliability under these circumstances.

## Principles

Following the practices of Chaos Engineering will increase your service's resiliency, promote ability to act, and improve team morale. Reduce the uncertainty of production by leaning into Chaos and transforming rare, unpredictable, and disruptive outcomes into controlled experiments you identify before your customers are impacted.

- Proactive​
- Embrace failure​
- Break the system​
- Identify and address single points of failure early
- Instill guardrails and graceful mitigations
- Minimize blast radius
- Build immunity​
- Adjust the engineering process
​

#### Shifting left

Experiment early, experiment often, incorporating fault injection configurations and creating resiliency validation gates in your development stages.  

#### Shifting right
Is an opportunity to verify that the service is resilient where it counts.  Enables a proactive as opposed to reactive approach improving DRI morale when done during business hours. Help with determining and controlling blast radius.  

#### Blast radius
Being able to quickly stop an experiment and contain it to specific services [Bulkhead pattern](/azure/architecture/patterns/bulkhead). Recognizing that experimentation means unknown results and strive to achieving balance between collecting substantial result data while affecting as few production users as possible.  

#### Error (chaos) Budget
Error budget can be used to invest in Chaos and Fault injection. Difference between 100% and agreed upon Service Level Objective(SLO) is your error budget.

### Best practices for chaos engineering
The following are best practices based on application of chaos engineering inside Azure

1. **The faults must matter to the development team**
    - This is about what is injected.

        For a development team to spend bandwidth looking at failures from an artificial source the failures must meet a very high bar for relevance. A team acting outside of a dev group can't just inject hypothetical faults and expect them to be looked at. Work closely with the dev teams to ensure the importance of the failures injected.  
1. **The faults must be injected in a way that accurately reflects what would happen in production**
    - This is about how faults are injected.

        Developers must believe they are real, and the best way to do that is in production. It may take steps to build the confidence to get there, but that should be the goal.

        The ability to inject faults is essential to Chaos Engineering. Faults can be injected in many ways, however each successful effort had tooling designed explicitly to inject the types of faults their teams cared about.
1. **It must be possible to limit the blast radius**
    - Real users can't be put at risk.

        The better you can limit blast radius the more you can test in production, which is where you need to be to find the real bugs. This is accomplished in two basic ways:  

        - Inject in a non-prod (TIP) environment.
        - Partitioning of the prod service or environment.

        Implement a rip cord or a big red stop button that would halt all faults and roll things back to its last known good configuration if things get into a bad state.
1. **The barrier for developer usage must be low and the results actionable**
    - It must be very low tax.

        It must be easy for developers to understand what happened and fix the issues.  This must fit in their normal workflow easily, not a one off special activity.

1. **An incremental approach should be used to build confidence**
    - Starting with hardening the core and then expanding out in layers. At each point progress should be locked in with automated regression tests. Each team should have a long term strategy based on a progression that makes sense for their circumstances.
1. **Chaos engineering should be a part of the development team culture and an ongoing practice, not a short-term tactical effort in response to an outage**
    - Development team must be partners in the process. They must have resources committed to look at the issues found, and must be active partners who are willing to make product changes as necessary to implement testability required for Fault Injection.
1. **Chaos engineering requires specialized expertise, technology, and practices** 
    - Like security and performance teams, the model of a central team supporting the service teams works well.

## Game Day

Teams practicing simulated handling of potentially catastrophic scenarios under controlled conditions.  

|Attacker|Defender|
|----|---|
|Inject faults|Assess|
|Provide hints| Analyze|
||Mitigate|

### Goals of game day

- Familiarize with monitoring tools​
- Recognize outage patterns​
- Train on assessing the impact​
- Root-cause / mitigation mindset​
- Practice log analysis

## When to Apply Chaos

- Deploy new code
- Adding dependencies
- Usage pattern changing
- Mitigating problems

Ideally chaos should be applied all the time.  In todays services world there is constant change in the environments software and hardware runs in, so monitoring of change is paramount and constant application of stress or faults on components will help expose issues early before a small issue gets compounded by a number of other factors.

## Stay Ahead of Chaos

- Challenge system assumptions​
- Validate change (topology, platform, resources, etc.)​
- Use SLA Buffers for good​
- Embrace Live-site Outages


## Faults

Faults that can be leveraged to inject chaos.  

|  |  |  |
| -- | -- | -- |
| **Resource pressure** | CPU |  |
|  | Memory | *Physical* <hr> *Virtual* <hr> *bad checksum* |
|  | Hard disk | *Capacity* <hr> *Read* <hr> *Write* <hr> *Availability* <hr> *Data corruption* <hr> *Read / Write Latency* |
| **Network** | Layers | *Transport (TCP/UDP)* <hr> *Application layer (HTTP)* |
|  | Types | *Disconnect* <hr> *Latency* <> *Alter response codes (HTTP)* <hr> *Packet reorder / loss (TCP/UDP)* <hr> *# of connections (active / passive)* <hr> *DOS attack* |
|  | Filters | *Domain / IP / Subnet* <hr> *URL path* <hr> *Port / Protocol* <hr> *DNS Host Name resolution* |
| **Process** | Stop / Kill |  |
|  | Restart |  |
|  | Stop service  |  |
|  | Start  |  |
|  | Crash  |  |
|  | Hang |  |
| **Virtual Machine** | Stop |  |
|  | Restart |  |
|  | BSOD |  |
|  | Change date |  |
|  | Re-image  |  |
|  | Live Migration  |  |
| **Platform** | Quorum loss |  |
|  | Data loss |  |
|  | Move primary node |  |
|  | Remove replica |  |
| **Application specific** | Intercept / Re-route calls | *No access to service code* |
| **Hardware** | Machine | *Storage* |
|  | Network devices |  |
|  | Rack |  |
|  | UPS  |  |
|  | Datacenter |  |

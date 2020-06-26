---
title: Chaos engineering
description: Chaos engineering fundamentals for improving reliability of a service built on Azure
author: absheik
ms.date: 04/03/2020
ms.topic: article
ms.service: architecture-center
ms.subservice: well-architected
ms.custom: How do you Chaos engineer your applications to ensure they're fault tolerant?
---

# Chaos Engineering

Chaos engineering is a methodology used to enable developers to attain consistent reliability by hardening the services against failures in production. A common way to introduce chaos is by deliberately injecting fault that causes system components to fail. The goal is to observe, monitor, respond to, and improve your systems reliability under these circumstances.

## Context
Characteristics of a service behavior are very difficult to simulate outside of production environment at scale.  Transient nature of cloud platform exasperates this problem.  Architecting services expecting failure is a core tenant of modern service.  Chaos engineering embraces the uncertainty of production and strives to precipitate rare, unpredictable, and disruptive outcomes early so customer impact is minimized.


## Principles

Chaos engineering is aimed at increasing your service’s resiliency and the ability to react to failures. By conducting experiments in a controlled environment, you can identify issues during development and deployment.

- Be Proactive​
- Embrace failure​
- Break the system​
- Identify and address single points of failure early
- Instill guardrails and graceful mitigations
- Minimize blast radius
- Build immunity​
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
Stop the experiment when it goes beyond scope. An expected outcome of experiments is unknown results. Strive to achieve balance between collecting substantial result data while affecting as few production users as possible. The [Bulkhead pattern](/azure/architecture/patterns/bulkhead) practices that principle.

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

|  |  |  |
| -- | -- | -- |
| **Resource pressure** | CPU |  |
|  | Memory | *Physical* <hr> *Virtual* <hr> *bad checksum* |
|  | Hard disk | *Capacity* <hr> *Read* <hr> *Write* <hr> *Availability* <hr> *Data corruption* <hr> *Read / Write Latency* |
| **Network** | Layers | *Transport (TCP/UDP)* <hr> *Application layer (HTTP)* |
|  | Types | *Disconnect* <hr> *Latency* <hr> *Alter response codes (HTTP)* <hr> *Packet reorder / loss (TCP/UDP)* <hr> *# of connections (active / passive)* <hr> *DOS attack* |
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


> [!NOTE]
> This is not intended to be an exhaustive list, but a representation of commonly injected faults.  


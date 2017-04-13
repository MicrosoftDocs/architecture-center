---
layout: LandingPage
ms.topic: article
---

# Azure Application Architecture Guide

The cloud is changing the way applications are designed. Instead of monoliths, applications are decomposed into smaller, decentralized services. These services communicate through APIs or by using asynchronous messaging or eventing. Applications scale horizontally, adding new instances as demand requires. 

These trends bring new challenges. Application state is distributed. Operations are done in parallel and asynchronously. The system as a whole must be resilient when failures occur. Deployments must be automated and predictable. Monitoring and telemetry are critical for gaining insight into the system.

<table>
<thead>
    <tr><th>Traditional on-premises</th><th>Modern cloud</th></tr>
</thead>
<tbody>
<tr><td>Monolithic, centralized<br/>
Design for predictable scalability<br/>
Relational database<br/>
Strong consistency<br/>
Serial and synchronized processing<br/>
Design to avoid failures (MTBF)<br/>
Occasional big updates<br/>
Manual management<br/>
Snowflake servers</td>
<td>
Decomposed, de-centralized<br/>
Design for elastic scale<br/>
Polyglot persistence (mix of storage technologies)<br/>
Eventual consistency<br/>
Parallel and asynchronous processing<br/>
Design for failure. (MTTR)<br/>
Frequent small updates<br/>
Automated self-management<br/>
Immutable infrastructure<br/>
</td>
</tbody>
</table>


## How this guide is structured

This guide presents a structured approach for designing applications on Azure that are scalable, resilient, and highly available. It is intended for architects and engineers who are designing solutions for Azure. 

<object data="./images/guide-steps.svg" type="image/svg+xml"></object>

The guide is organized as a series of steps from the architecture design to the implementation. Each step involves decisions, starting with the most fundamental: What **architecture style** are you building? A microservices architecture? A more traditional N-tier application? Or perhaps a Big Data solution. [Learn about architecture styles...][arch-styles] 

Two technology choices should be decided early on, because they will affect the entire architecture. These are the choice of **compute** and **storage** technologies. The term "compute" refers to the hosting model for the computing resources that your applications runs on. Storage includes databases but also storage for message queues, caches, IoT data, unstructured log data, and anything else that an application might persist to storage. 

Learn about compute options...

Learn about storage options...

Ten **design principles** for cloud applications. Keep these high-level principles in mind throughout the design process. [Read the design principles...][design-principles] 

[arch-styles]: ./architecture-styles/index.md
[design-principles]: ./design-principes/index.md

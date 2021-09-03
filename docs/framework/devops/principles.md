---
title: Operational excellence design principles
description: Understand the design principles for operational excellence within the Azure Well-Architected Framework.
author: david-stanford
ms.date: 12/07/2020
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
---

# Operational excellence principles

Considering and improving how software is developed, deployed, operated, and maintained is one part of achieving a higher competency in operations. Equally important is providing a team culture of experimentation and growth, solutions for rationalizing the current state of operations, and incident response plans. The principles of operational excellence are a series of considerations that can help achieve excellent operational practices.

To assess your workload using the tenets found in the Azure Well-Architected Framework, see the [Microsoft Azure Well-Architected Review](/assessments/?id=azure-architecture-review&mode=pre-assessment).

<a id="methodologies">**DevOps methodologies**</a>

The contraction of "Dev" and "Ops" refers to replacing siloed Development and Operations to create multidisciplinary teams that now work together with shared and efficient practices and tools. Essential DevOps practices include agile planning, continuous integration, continuous delivery, and monitoring of applications.

<a id="roles">**Separation of roles**</a>

A DevOps model positions the responsibility of operations with developers. Still, many organizations do not fully embrace DevOps and maintain some degree of team separation between operations and development, either to enforce clear segregation of duties for regulated environments or to share operations as a business function.

**Team collaboration**

It is essential to understand if developers are responsible for production deployments end-to-end, or if a handover point exists where responsibility is passed to an alternative operations team, potentially to ensure strict segregation of duties such as the Sarbanes-Oxley Act where developers cannot touch financial reporting systems.

It is crucial to understand how operations and development teams collaborate to address operational issues and what processes exist to support and structure this collaboration. Moreover, mitigating issues might require various teams outside of development or operations, such as networking and external parties. The processes to support this collaboration should also be understood.

**Workload isolation**

The goal of workload isolation is to associate an application's specific resources to a team to independently manage all aspects of those resources.

<a id="lifecycles">**Operational lifecycles**</a>

Reviewing operational incidents where the response and remediation to issues either failed or could have been optimized is vital to improving overall operational effectiveness. Failures provide a valuable learning opportunity, and in some cases, these learnings can also be shared across the entire organization. Finally, Operational procedures should be updated based on outcomes from frequent testing.

<a id="metadata">**Operational metadata**</a>

Azure Tags provide the ability to associate critical metadata as a name-value pair, such as billing information (e.g., cost center code), environment information (e.g., environment type), with Azure resources, resource groups, and subscriptions. See [Tagging Strategies](/azure/cloud-adoption-framework/ready/azure-best-practices/naming-and-tagging#naming-and-tagging-strategy)  for best practices.

**Optimize build and release processes**

From provisioning with Infrastructure as Code, building and releasing with CI/CD pipelines, automated testing, and embracing software engineering disciplines across your entire environment. This approach ensures the creation and management of environments throughout the software development lifecycle is consistent, repeatable, and enables early detection of issues.

**Monitor the entire system and understand operational health**

Implement systems and processes to monitor build and release processes, infrastructure health, and application health. Telemetry is critical to understanding the health of a workload and whether the service is meeting the business goals.

**Rehearse recovery and practice failure**

Run DR drills on a regular cadence and use engineering practices to identify and remediate weak points in application reliability. Regular rehearsal of failure will validate the effectiveness of recovery processes and ensure teams are familiar with their responsibilities.

**Embrace operational improvement**

Continuously evaluate and refine operational procedures and tasks while striving to reduce complexity and ambiguity. This approach enables an organization to evolve processes over time, optimizing inefficiencies, and learning from failures.

**Use loosely coupled architecture**

Enable teams to independently test, deploy, and update their systems on demand without depending on other teams for support, services, resources, or approvals.

**Incident management**

When incidents occur, have well thought out plans and solutions for incident management, incident communication, and feedback loops. Take the lessons learned from each incident and build telemetry and monitoring elements to prevent future occurrences. 

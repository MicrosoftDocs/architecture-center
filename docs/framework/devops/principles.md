---
title: Operational excellence design principles
description: Operational Excellence Design Principles
author: neilpeterson
ms.date: 12/07/2020
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
---

# Operational excellence principles

Considering and improving how software is developed, deployed, operated, and maintained is one part of achieving a higher competency in operations. Equally important is providing a team culture of experimentation and growth, solutions for rationalizing the current state of operations, and incident response plans. The principles of operational excellence are a series of considerations that can help achieve excellent operational practices.

To assess your workload using the tenets found in the Azure Well-Architected Framework, see the [Microsoft Azure Well-Architected Review](/assessments/?id=azure-architecture-review&mode=pre-assessment).

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

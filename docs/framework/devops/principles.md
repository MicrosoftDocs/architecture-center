---
title: Operational Exclience Design Principles
description: Operational Exclience Design Principles
author: neilpeterson
ms.date: 09/28/2020
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
---

# Operational excellence principles

The following Design Principles provide context for questions, why a certain aspect is important, and how is it applicable to Operational Excellence.

## Optimize build and release processes

From provisioning with Infrastructure as Code, building and releasing with CI/CD pipelines, automated testing, and embracing software engineering disciplines across your entire environment. This approach ensures the creation and management of environments throughout the software development lifecycle is consistent, repeatable, and enables early detection of issues.

## Monitor the entire system and understand operational health

Implement systems and processes to monitor build and release processes, infrastructure health, and application health. Telemetry is critical to understanding the health of a workload and whether the service is meeting the business goals.

## Rehearse recovery and practice failure

Run DR drills on a regular cadence and use chaos engineering practices to identify and remediate weak points in application reliability. Regular rehearsal of failure will validate the effectiveness of recovery processes and ensure teams are familiar with their responsibilities.

## Embrace operational improvement

Continuously evaluate and refine operational procedures and tasks while striving to reduce complexity and ambiguity. This approach enables an organization to evolve processes over time, optimizing inefficiencies, and learning from failures.

## Use loosely coupled architecture

Enable teams to independently test, deploy, and update their systems on demand without depending on other teams for support, services, resources, or approvals.
---
title: Operational excellence DevOps culture
description: Operational excellence DevOps culture
author: neilpeterson
ms.date: 03/02/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
---

# DevOps culture and methodologies

## What is DevOps

The contraction of "Dev" and "Ops" refers to replacing siloed Development and Operations to create multidisciplinary teams that now work together with shared and efficient practices and tools. Essential DevOps practices include agile planning, continuous integration, continuous delivery, and monitoring of applications.

## Roles and responsibilities

Exploring where technical delivery capabilities reside helps to qualify operational model boundaries and estimate the cost of operating the application, and defining a budget and cost model.

### Sereration of roles

A DevOps model positions the responsibility of operations with developers. Still, many organizations do not fully embrace DevOps and maintain some degree of team separation between operations and development, either to enforce clear segregation of duties for regulated environments or to share operations as a business function.

### Team colaboration

It is essential to understand if developers are responsible for production deployments end-to-end, or if a handover point exists where responsibility is passed to an alternative operations team, potentially to ensure strict segregation of duties such as the Sarbanes-Oxley Act where developers cannot touch financial reporting systems.

It is crucial to understand how operations and development teams collaborate to address operational issues and what processes exist to support and structure this collaboration. Moreover, mitigating issues might require various teams outside of development or operations, such as networking and external parties. The processes to support this collaboration should also be understood.

## Workload isolation

The goal of workload isolation is to associate an application's specific resources to a team to independently manage all aspects of those resources(Workload isolation).

## Operational lifecycles

Reviewing operational incidents where the response and remediation to issues either failed or could have been optimized is vital to improving overall operational effectiveness. Failures provide a valuable learning opportunity, and in some cases, these learnings can also be shared across the entire organization. Finally, Operational procedures should be updated based on outcomes from frequent testing.

## Operational metadata

Azure Tags provide the ability to associate critical metadata as a name-value pair, such as billing information (e.g., cost center code), environment information (e.g., environment type), with Azure resources, resource groups, and subscriptions. See Tagging Strategies for best practices.
---
title: Compliance and governance considerations for your workload
description: Describes considerations around compliance and governance requirements and how they may impact your workload.
author: david-stanford
ms.date: 11/01/2019
ms.topic: article
ms.service: architecture-center
ms.subservice: cloud-design-principles
ms.custom: 
---

# Compliance and governance considerations for your workload

## Have you defined security policies according to your company’s security needs, and tailored it to the type of applications or sensitivity of the data

Use Azure Security Center for security management and advanced threat protection across hybrid cloud workloads. Review Prevent, detect, and respond to threats guidance.

## Resource creation management

Susceptibility to users that may abuse the service by creating more resources than they need.

Action:
Control resource creation using Resource Manager.

## Data residency

Data residency is a particular issue that businesses face as they move more and more information into the cloud. The cloud provides flexibility for data storage, file sharing and the use of different SaaS applications, but it presents challenges when it comes to establishing and maintaining data control. It is having clear control over their data that businesses need to be able to prove in order to meet internal and customer requirements, standards and legal obligations, such as the General Data Protection Regulation (GDPR).

## Standards

Standards provide people and organizations with a basis for mutual understanding, and are used as tools to facilitate communication, measurement, commerce and manufacturing.

## Usage and spending

Inability to provide a view to people with different responsibilities (financial controller, executives, project owners) in your organization.

Action:
Use Cost Management metrics with dashboards to view key cost metrics and business-trend highlights to help make important business decisions.

## Custom policies

Risk of resources not staying compliant with corporate standards and service-level agreements (SLAs).

Action:
Use Custom Azure Policy to enforce different rules and effects over resources to ensure that resources stay compliant with corporate standards and SLAs.

## Policy to resources at scale

Inability to provide RBAC assignments over multiple subscriptions.

Action:
Employ Azure Policy scoping to apply governance conditions to multiple subscriptions (management groups) all at once.

## Audit policy compliance

Risk of resources getting created in wrong location, enforcing common and consistent tag usage, or auditing existing resources for appropriate configurations and setting.

Action:
Use Azure Policy compliance monitoring to understand the compliance state of environment.
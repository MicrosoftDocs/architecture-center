---
title: Authorization for your workload
description: Describes considerations to make when authorizing traffic into your workload.
author: david-stanford
ms.date: 11/01/2019
ms.topic: article
ms.service: architecture-center
ms.subservice: cloud-design-principles
ms.custom: 
---

# Authorization for your workload

## Role-based access control(RBAC)

Use role-based access control (RBAC) to grant access based on Azure Active Directory identities and groups.

Role-based: If you want to authorize based on users. A user can either be an administrator, creator, or reader. If you want to authorize an action based on a particular resource, consider resource based. For example, the app can check whether a user is the owner for of a resource.

## Common authorization patterns

Authorization is a security mechanism used to determine user/client privileges or access levels related to system resources, including computer programs, files, services, data and application features. Authorization is normally preceded by authentication for user identity verification.

## Auditing authorization

Conducting internal security audits help companies keep their compliance programs up to date and aimed in the right direction. An effective security risk assessment can prevent breaches, reduce the impact of realized breaches, and keep your company's name from appearing in the spotlight for all the wrong reasons.
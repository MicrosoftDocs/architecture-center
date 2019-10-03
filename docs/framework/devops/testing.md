---
title: Testing for DevOps
description: Describes testing considerations to make when in regards to DevOps when desinging your workload.
author: david-stanford
ms.date: 11/01/2019
ms.topic: article
ms.service: architecture-center
ms.subservice: cloud-design-principles
ms.custom: 
---

# Testing for DevOps

## DR and fault injection

Experimentation on a system to uncover its weaknesses. Breaking things on purpose is preferable to being surprised when things break.

## Testing in production

Use App Service deployment slots for testing in production.

## BCP (Business Continuity Process)/DR (Disaster Recovery) drills

Review guidance on disaster recovery for Azure applications. Use Azure Site Recovery drills.
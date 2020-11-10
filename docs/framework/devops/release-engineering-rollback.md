---
title: Release Engineering Rollback and Rollforward 
description: Release Engineering Rollback and Rollforward 
author: neilpeterson
ms.date: 09/28/2020
ms.topic: article
ms.service: architecture-center
ms.subservice: well-architected
---

# Release Engineering: Rollback and Rollforward

## Rollback plan

Use App Service deployment slots to fall back on last-known good menu.

The most important step is to implement an architecture that supports the need to rollback. For instance, componentized, service-based architectures lend themselves well to this. Persistent message queues and asynchronous services allow you to bring components down for rollback without affecting the main user base. Work towards something like the Blue-Green release pattern such that your application can stay available whilst you are working on one half of the system.

If a deployment fails, your application could become unavailable. To minimize downtime, design a rollback process to go back to a last-known good version. Include a strategy to roll back changes to databases and any other services your app depends on.

If you're using Azure App Service, you can set up a last-known good site slot and use it to roll back from a web or API app deployment.

## Git

## Web Apps

## Azure Kubernetes Service

## Others
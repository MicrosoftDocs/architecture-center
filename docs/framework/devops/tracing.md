---
title: Tracing and debugging
description: Provides requirements and use cases for tracing operations and debugging software releases as it relates to monitoring, and diagnostics. 
author: v-stacywray
ms.date: 11/16/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
products:
  - azure
categories:
  - management-and-governance
  - security
ms.custom:
  - article
---

# Tracing and debugging

When a user reports an issue, the user is often aware only of the immediate effect that the issue has on their operations. The user can only report the results of their own experience back to the person who is responsible for maintaining the system. These experiences are a visible symptom of one or more fundamental problems.

## Root cause analysis

 In many cases, an analyst must dig through the chronology of the underlying operations to establish the root cause of the problem. This process is called a *root cause analysis*.

A root cause analysis may uncover inefficiencies in application design. In these situations, you can try to rework the affected elements and deploy them as part of a later release. This process requires careful control, and you should monitor the updated components closely.

## Requirements for tracing and debugging

For tracing unexpected events and other problems, consider the following requirements:

- Monitoring data must provide enough information to enable an analyst to trace the origin of an issue and reconstruct the sequence of events that lead up to the issue.
- Data must be sufficient for the analyst to identify a root cause.
- A root cause enables the developer to make the necessary changes to prevent the issue from recurring.

## Requirements for data collection

Troubleshooting involves the following data collection requirements:

- Trace all methods and their parameters used in an operation to create a model that shows the logical *flow* through the system when a customer makes a specific request.
- Capture and log exceptions, and warnings that the system generates because of this flow.

To support debugging, the system should provide the following data:

- Hooks that enable you to capture `state` information at critical points in the system.
- Step-by-step information as selected operations continue.

> [!NOTE]
> Capturing detailed data can cause extra load on the system and should be a temporary process. Only capture detailed data when an unusual series of events occur, which are difficult to replicate. Alternately, only capture detailed data when you're monitoring a new release to ensure that new elements in the system function as expected.

## Next steps

> [!div class="nextstepaction"]
> [Auditing](./auditing.md)
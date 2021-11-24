---
title: Issue tracking
description: Provides requirements and use cases for issue tracking as it relates to monitoring, and diagnostics. 
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

# Issue tracking

If unexpected events occur in the system, customers and other users may report these issues.

Issue tracking involves:

- Managing issues.
- Associating issues with efforts to resolve underlying problems in the system.
- Informing customers of possible resolutions.

## Requirements for issue tracking

You can often track issues using a separate system that lets you record and report the details of problems that users report. These details can include:

- Tasks the user was doing.
- Symptoms of the problem.
- Sequence of events.
- Error or warning messages.

## Requirements for data collection

The user who initially reported the issue is considered the primary data source. This user can provide more information, such as:

- A crash dump, if the application includes a component that runs on the user's desktop.
- A screenshot.
- The date and time the error occurred.
- The user's location.

You can use this information to help debug and create a backlog for future software releases.

## Analyze data

Consider the following scenarios when you analyze issue-tracking data:

- Different users may report the same problem. The issue-tracking system should associate common reports.
- Record the debugging progress against each issue report.
- Inform customers of the solution when you've resolved the issue.
- If a user reports an issue that has a known solution in the issue-tracking system, inform the user of the solution immediately.

## Next steps

> [!div class="nextstepaction"]
> [Tracing and debugging](./tracing.md)

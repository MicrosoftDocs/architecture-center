---
title: Auditing
description: Provides requirements and use cases for auditing software releases as it relates to monitoring, and diagnostics. 
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

# Auditing

Depending on the application, there may be legal requirements for auditing users' operations and recording all data access. Auditing can provide evidence that links customers to specific requests. Affirming validity is an important factor in many online business systems to help maintain trust between the customer and the business responsible for the application, or service.

## Requirements for auditing

An analyst can trace the sequence of business operations that users perform so that you can reconstruct users' actions. Tracing the sequence of operations may be necessary as a matter of record, or as part of a forensic investigation.

Audit information is highly sensitive. This information includes data that identifies the users of the system and the tasks that they're doing. Reports contain sensitive audit information available only to trusted analysts. An analyst can generate a range of reports. For example, reports may list the following activities:

- All users' activities occurring during a specified time frame.
- The chronology of a single user's activity.
- The sequence of operations performed against one or more resources.

## Requirements for data collection

The primary sources of auditing information can include:

- The security system that manages user authentication.
- Trace logs that record user activity.
- Security logs that track all network requests.

Regulatory requirements may dictate the format of the audit data and the way it's stored. For example, it may not be possible to clean the data in any way. It must be recorded in its original format. Access to the data repository must be protected to prevent tampering.

## Analyze audit data

An analyst must access all the raw data in its original form. Aside from the common audit report requirement, the tools for analyzing this data are specialized and external to the system.

## Next steps

> [!div class="nextstepaction"]
> [DevOps Checklist](../../checklist/dev-ops.md)
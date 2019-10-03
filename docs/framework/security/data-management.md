---
title: Securely managing your data.
description: Describes security considerations to take into account for the management of the data in your workload.
author: david-stanford
ms.date: 11/01/2019
ms.topic: article
ms.service: architecture-center
ms.subservice: cloud-design-principles
ms.custom: 
---

# Securely managing your data

## Database access

Inability to grant access to databases based on the originating IP address of each request.

Action:
Use firewall rules to restrict database access. Utilize Virtual Network service endpoints to secure databases to only your virtual networks.

## Database authentication

Inability to prove a user’s identity.

Action:
Use database authentication. Employ Azure Managed Database Services for built-in security, automatic monitoring, threat detection, automatic tuning, and turnkey global distribution.

## Database auditing

Inability to maintain regulatory compliance, understand database activity, and gain insight into discrepancies and anomalies.

Action:
Enable database auditing. Use Azure Managed Database Services for built-in security, automatic monitoring, threat detection, automatic tuning, and turnkey global distribution.


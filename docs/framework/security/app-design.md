---
title: Application design with a security focus
description: Describes how to design your application while focusing on security.
author: david-stanford
ms.date: 11/01/2019
ms.topic: article
ms.service: architecture-center
ms.subservice: cloud-design-principles
ms.custom: 
---

# Application design with a security focus

## Distributed denial-of-service protection

Use WAF in front of a web app. Review Azure DDoS Protection guidance. Utilize Azure Key Vault to manage secrets, such as connectionstring.

## Role-based access controls (RBAC)

Use RBAC with Azure AD for Azure subscription. Utilize Azure Security Center for threat detection and protection.

## Secret management

## Keys in source code

This includes passwords / API keys / etc.

## Infosec team

## Seperation of duties
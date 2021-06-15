---
title: Architectural considerations for a multitenant solution
titleSuffix: Azure Architecture Center
description: This article introduces the considerations you need to give when planning a multitenant architecture.
author: johndowns
ms.author: jodowns
ms.date: 04/28/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
products:
 - azure
categories:
 - management-and-governance
 - security
ms.category:
  - fcp
ms.custom:
  - guide
---

# Architectural considerations for a multitenant solution

When you're considering a multitenant architecture, there are a number of decisions you need to make and elements you need to consider.

In a multitenant architecture, you share some or all of your resources between tenants. This means that a multitenant architecture can give you cost and operational efficiency. However, multitenancy introduces complexities, including:

- How do you define what a _tenant_ is for your specific solution? Does a tenant correspond to a customer, a user, or another construct like a family or a team?
- Which tenancy model will you use, and how much isolation will you have between tenants?
- What commercial pricing models will your solution offer, and how will your pricing models affect your multitenancy requirements?
- What level of service do you need to provide to your tenants? Consider performance, resiliency, security, and compliance requirements like data residency.
- How do you plan to grow your business or solution, and will it scale to the number of tenants you expect?
- Do any of your tenants have unusual or special requirements? For example, does your biggest customer need higher performance or stronger guarantees than others?
- How will you monitor, manage, automate, scale, and govern your Azure environment, and how will multitenancy impact this?

In this series, we outline the considerations you should give, and some of the tradeoffs you need to make, when you are planning a multitenant architecture. The content in this series is particularly relevant for technical decision-makers, like Chief Technology Officers and architects, but anyone who works with multitenant architectures should have some familiarity with these principles and tradeoffs.

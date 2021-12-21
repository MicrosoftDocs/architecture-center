---
title: Tradeoffs for security
description: You make have to make some tradeoffs when creating a secure workload, such as with reliability, performance efficiency, cost, or operational excellence.
author: PageWriter-MSFT
ms.date: 09/08/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
products:
  - azure
categories:
  - security
ms.custom:
  - article
---

# Tradeoffs for security

Security provides confidentiality, integrity, and availability assurances of an organization's data and systems. When designing a system you can almost never compromise on security controls. When you enhance security of an architecture there might be impact on reliability, performance efficiency, cost, and operational excellence. This article describes some of those considerations.

## Security vs Reliability

Reliable applications are resilient and highly available. Every architectural component factors in achieving your requirements for reliability. Workload security is often woven into many layers of the workload's architecture, operations, and runtime requirements; and may come with their own implications on resiliency or availability.

For example, identity providers and authorization services are critical dependencies to consider. This includes the identity service (Microsoft Identity Platform) and any libraries that help facilitate the use of those services. At some points in the architecture, a failure at an identity layer is terminal. At other points, reliability can be still achieved through strategies such as caching, taking advantage of TTLs on access tokens, and others. OAuth2 claims validation can happen mostly disconnected from the claims provider. However, not all authorization can be achieved that way. In those situations reliability may be traded in favor of complete security.

Many workloads may quickly degrade in functionality with the loss of critical security controls. Consider evaluating at each component of your architecture to detect that condition.

Other security considerations that might impact reliability are:

- Poor or manual certifications or key rotation practices. Failure to do those tasks can lead to reliability issues.
- Expired service principals. For example, a deployment pipeline that used a service principal might fail at a later date, if that principal's access key has expired. Using managed identities helps keep reliability high while also maintaining least privileges on that identity.
- High availability is often achieved by redundancy (actively or passively), and security controls also need to align with the failover mechanism. For example, failing over from one storage account to another for reliability may impact how the client's active authorization session is handled. Using managed identity with Azure AD integration for storage access can result in a higher reliability because the client doesn't have to manage SAS tokens when switching to the new storage account.

## Security vs Cost Optimization

Increasing security of the workload will almost always lead to higher cost. There are some ways to optimize cost.

- Maximum security may not always be practical for all environments. Evaluate the security requirements in pre-production and production environments. Are services such as Azure DDoS Protection, Microsoft Sentinel, Dedicated HSMs, Microsoft Defender for Cloud needed in pre-production? Is inner loop mocking of security controls sufficient? If resources are not publicly accessible, can you dial down some controls for cost savings? Always make those choices, *if and only if*, the lowered environment still meets the business requirements.

- Premium security features can increase the cost. There are areas you can reduce cost by using native security features. For example, avoid implementing custom roles if you can use built-in roles.

- Every security control has an opportunity to impact workflows, and workflows that involve people can be expensive.  A security control that stops work from being done should be evaluated as necessary or unnecessarily redundant. Total cost of ownership (TCO) includes operational costs for developers, operators, IT SecOps and onerous security protocols. Reach agreement about where "less" can br "sufficient" to optimize costs.

- TCO includes the time needed do tasks. Optimizing that time will optimize cost. Using platform features can lower TCO and enhance the security posture. Instead of training an engineer to manually review logs and correlate access patterns, use intelligence in services, such as Microsoft Defender for Cloud  or Sentinel alerts.

## Security vs Operational Excellence

Operational Excellence involves understanding business and workload behavior, and applying appropriate amounts of automation, and observability into those processes.

- Release management

    Your organization defines its quality gates (manual or automated) as part of its safe deployment practices. Evaluate whether each gate is required or optional, taking into consideration whether it's valuable to perform, at the added cost of complexity (and time) for that release. Adding security checks into the process makes the checks more valuable at that point in the process than any gains (usually simplicity and time) by not having them in place.

- Organizational policies

    Teams can often benefit from collaborating and using cross-functional skills in all stages of workload life cycle,  from development all the way through production. However, organizational policy or regulatory concerns may prevent such wide-reaching access. Consider, where possible, isolating those systems that do need heightened access policies from those that do not. Avoid applying "one size fits all" model to all components in the system. It's easier to optimize operations in systems that allow more unregulated access. For systems that demand regulated access, complexity is expected to increase leading to higher cost.

- Supportability considerations

    The most "serviceable" architectures are the ones that are the most transparent to everyone involved, and those often have the least number of security controls. Adding security controls to your architecture like filtered telemetry feeds, redacted logs, runtime system access restrictions, and so on can all impact the supportability of a solution. Adding security controls often require adding compensating or compromised solutions for observability into the platform.

## Related link

> Go back to the main article: [Security](overview.md)

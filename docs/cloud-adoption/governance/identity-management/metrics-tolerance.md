---
title: "Fusion: Metrics, indicators, and risk tolerance"
description: Explanation of the concept identity management in relation to cloud governance
author: BrianBlanchard
ms.date: 1/3/2019
---

# Fusion: Metrics, indicators, and risk tolerance 

This article is intended to help you quantify business risk tolerance as it relates to identity management. Defining metrics and indicators helps you create a business case for making an investment in the maturity of the Identity Management discipline.

## Metrics

Identity management focuses identifying, authenticating, and authorizing individuals, groups of users, or automated processes, and providing them appropriate access to resources in your cloud deployments. The following information is useful when adopting this discipline of cloud governance:

- **Identity systems size**. Total number of users, groups, or other objects managed through your identity systems.
- **Extent of federation**. Number of identity management systems federated with your organization's systems.  
- **Overall size of directory services infrastructure**. Number of directory forests, domains, and tenants used by your organization.
- **Extent of cloud-deployed directory services**. Number of directory forests, domains, and tenants you've deployed to the cloud.
- **Cloud deployed Active Directories**. Number of Active Directory servers deployed to the cloud.
- **Cloud deployed organizational units**. Number of Active Directory Organizational Units deployed to cloud.
- **Elevated users**. Number of user accounts with elevated access to resources or management tools.
- **Use of RBAC**. Number of subscriptions, resource groups, or individual resources not managed through role-based access control (RBAC).
- **Authentication claims**. Number of successful and failed user authentication attempts.
- **Authorization claims**. Number of successful and failed attempts by users to access resources.


## Risk tolerance indicators

Risks related to identity management are largely related to the complexity of your organization's identity infrastructure. If all of your users and groups are managed using a single directory or cloud native identity provider using minimal integration with other services, your risk level will likely be small. However, as your business needs grow your identity management systems may need to support more complicated scenarios, such as multiple directories to support your internal organization or federation with external identity providers. As these systems become more complex, risk increases.

In the early stages of cloud adoption, work with your business to identify [business risks](business-risks.md) related to identity, then determine an acceptable baseline for identity risk tolerance. This section of the Fusion guidance provides examples, but the detailed risks and baselines for your company or deployments may be different.

Once you have a baseline, establish minimum benchmarks representing an unacceptable increase in your identified risks. These benchmarks act as triggers for when you need to take action to mitigate these risks. The following are a few examples of how identity related metrics, such as those discussed above, can justify an increased investment in the identity management discipline.

- [content coming]

## Next steps

Using the [Cloud Management template](./template.md), document metrics and tolerance indicators that align to the current cloud adoption plan.

Building on risks and tolerance, establish a [process for governing and communicating security policy adherence](processes.md).

> [!div class="nextstepaction"]
> [Monitor and Enforce Policy Statements](./processes.md)

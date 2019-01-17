---
title: "Fusion: Identity management sample policy statements"
description: Explanation of the concept identity management in relation to cloud governance
author: BrianBlanchard
ms.date: 1/4/2019
---

# Fusion: Identity management sample policy statements

The following policy statements provide examples of how to mitigate specific business risks through design guidance, as well as the implementation of specific tools you can use for identity governance monitoring and enforcement.

## Lack of access controls

**Business risk**: Insufficient or ad-hoc access control settings can introduce risk of unauthorized access to sensitive or mission critical resources.

**Policy statement**: All assets deployed to the cloud should be controlled using identities and roles approved by current governance policies.

**Design guidance**: [Azure Active Directory conditional access](https://docs.microsoft.com/en-us/azure/active-directory/conditional-access/overview) is the default access control mechanism in Azure.

## Overprovisioned access

**Business risk**: Users and groups with control over resources beyond their area of responsibility can can result in unauthorized modifications leading to outages or security vulnerabilities.

**Policy statement**: A least privilege access model is to be applied to any resources involved in mission critical applications or protected data. Elevated permissions should be an an exception, and any such exceptions must be recorded with the Cloud Governance Team. Exceptions will be audited regularly.

**Design guidance**: Consult the [Azure Identity Management best practices](https://docs.microsoft.com/en-us/azure/security/azure-security-identity-management-best-practices) to implement  a role-based access control (RBAC) strategy that restricts access based on the [need to know](https://en.wikipedia.org/wiki/Need_to_know) and [least privilege security](https://en.wikipedia.org/wiki/Principle_of_least_privilege) principles.


## Lack of shared management accounts between on-premises and the cloud

**Business risk**: IT management or administrative staff with accounts on your on-premises Active Directory may not have sufficient access to cloud resources may not be able to efficiently resolve operational or security issues.

**Policy statement**: All groups in the on-premises Active Directory infrastructure that have elevated privileges should be mapped to an approved RBAC role.

**Design guidance**: Implement a hybrid identity solution between your cloud-based Azure Active Directory's and your on-premise Active Directory, and add the required on-premises groups to the RBAC roles necessary to do their work.

## Weak authentication mechanisms

**Business risk**: Identity management systems with insufficiently secure user authentication methods, such as basic user/password combinations, can lead to compromised or hacked passwords, providing a major risk of unauthorized access to secure cloud systems.

**Policy statement**: All accounts are required to login to secured resources using a multi-factor authentication (MFA) method.

**Design guidance**: For Azure Active Directory, implement [Azure Multi-Factor Authentication](https://docs.microsoft.com/en-us/azure/active-directory/authentication/concept-mfa-howitworks) as part of your user authorization process.

## Isolated identity providers

**Business risk**: Incompatible identity providers can result in the inability to share resources or services with customers or other business partners.

**Policy statement**: Deployment of any applications that require customer authentication must use an approved identity provider that is compatible with the primary identity provider for internal users.

**Design guidance**: Implement [Azure Active Directory Federation](https://docs.microsoft.com/en-us/azure/active-directory/hybrid/whatis-fed) between your internal and customer identity providers.

## Identity reviews

**Business risk**: Over time business change, the addition of new cloud deployments or other security concerns can increase the risks of unauthorized access to secure resources.

**Policy statement**: Cloud Governance processes must include quarterly review with identity management teams to identify malicious actors or usage patterns that should be prevented by cloud asset configuration

**Design guidance**: Establish a quarterly security review meeting that includes both governance team members and IT staff responsible for managing identity services. Review existing security data and metrics to establish gaps in current identity management policy and tooling, and update policy to mitigate any new risks.

## Next steps

Use the samples mentioned in this article as a starting point to develop policies that address specific business risks that align with your cloud adoption plans.

To begin developing your own custom policy statements related to identity management, download the [Identity Management template](template.md).

To accelerate adoption of this discipline, see the list of [Azure Design Guides](../design-guides/overview.md). Find one that most closely aligns with your environment. Then modify the design to incorporate your specific corporate policy decisions.

> [!div class="nextstepaction"]
> [Implement an Azure Design Guide](../design-guides/overview.md)

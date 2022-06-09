---
title: Identity considerations
description: TODO
author: johndowns
ms.date: 06/01/2022
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: best-practice
categories:
  - identity
products:
  - azure-active-directory
  - azure-active-directory-b2c
ms.custom:
  - guide
---

# Identity considerations

Almost every cloud application needs to work with user identities. Identity is the foundation of modern security practices, and application user identity is a critical part of your solution's architecture.

For the majority of solutions, you should consider using a managed identity provider (IdP) instead of building or operating your own. In this article, we describe the challenges of building or running your own identity provider.

> [!NOTE]
> Using a fully managed identity platform, like Azure Active Directory (Azure AD), Azure AD B2C, or another similar system is the best approach to follow.
> 
> Your solution requirements might lead you to use a framework or off-the-shelf identity solution that you host and run yourself. While this mitigates some of the issues described in this article, many of the problems we describe are still your responsibility even if you operate a pre-built identity product.
> 
> You should avoid ever building your own identity system from scratch.

## Implement identity and federation protocols

Modern identity protocols are complex. OAuth 2, OpenID Connect, and other protocols have been designed by industry experts to ensure that they mitigate real-world attacks and vulnerabilities. The protocols also evolve over time to adapt to changes in technologies, attack strategies, and user expectations. Identity specialists, with expertise in the protocols and how they're used, are in the best position to implement and validate systems that follow these protocols.

It's also common to [federate IdPs together](../patterns/federated-identity.yml). Identity federation protocols are complex to establish, manage, and maintain, and again requires specialist knowledge and experience.

## Adopt modern identity features

Users expect an identity system to include a range of advanced features, which might include any of the following features:

- Passwordless authentication, where users can use secure approaches to sign in that don't require them to enter a credential.
- Multifactor authentication (MFA), which prompts the user to authenticate themselves in multiple ways, such as by using a mobile app or a code that's sent by email or SMS.
- Auditing, which tracks every event that happens in the identity platform including successful, failed, and aborted sign-in attempts.
- Conditional access, which creates a risk profile around sign-in attempts based on the user's identity, the location of the sign-in attempt, previous sign-in activity, application and data sensitivity, and other factors.
- Just-in-time access control, which temporarily allows users to sign in based on an approval process, and then removes the authorization automatically.

If you're building an identity component as part of your solution, it's unlikely you will be able to justify the work involved in implementing these features, and in maintaining them. Additionally, some of the features require additional work, such as integration with email and SMS messaging providers to send MFA codes, and this requires you to do more work.

Managed identity platforms also can provide an improved set of security features based on the volume of sign-in requests they receive. For example, the following features work best when there's a large number of customers using a managed, multitenant identity platform:

- Risky sign-in detection, such as sign-in attempts from botnets and [impossible travel](/defender-cloud-apps/anomaly-detection-policy#impossible-travel), and using machine learning techniques to classify sign-in attempts as valid or invalid.
- Common credential detection, such as insecure passwords that are frequently used by other users and therefore subject to a heightened risk of compromise.
- Compromised credential monitoring, which monitors sources on the dark web for leaked credentials and prevents their use.

If you build or run your own identity platform, you won't be able to take advantage of these features.

<!-- TODO here down -->
## Avoid storing credentials

When you run your own IdP, you end up with a database of credentials (usually hashed and salted, but still, credentials). This makes you an ideal target for attack - just look at the news. Holding credentials is a liability, not an asset. And just because you've hashed and salted credentials doesn't mean you're safe - it's not that hard for these protections to be circumvented with modern hardware and techniques.

## Build a reliable and performant identity system

Your identity system must be reliable. If your identity system goes down, your solution probably can't function. So it's important to use a service that has a high SLA and reliability.

Your identity system must be performant. Depending on your application architecture, every session or every request is likely to flow through the IdP. Ensure you use a service that can scale to support load and your growth.

## Test and re-test your security

If you run an identity system, it's incumbent on you to keep it secured, to run penetration tests, and to have all changes tightly controlled and reviewed.

## Focus on your core value

Building an IdP is almost certainly not what differentiates you from your competitors. Focus on building the components that actually add business value, and leave complex and fraught areas like identity to experts.

## Next steps

- TODO

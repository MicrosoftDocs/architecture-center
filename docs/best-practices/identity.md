---
title: Identity providers
description: Learn why it's important to use a managed identity platform instead of building or running your own.
author: johndowns
ms.date: 06/08/2022
ms.author: jodowns
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

# Identity providers

Almost every cloud application needs to work with user identities. Identity is the foundation of modern security practices, and application user identity is a critical part of your solution's architecture.

For most solutions, consider using a managed identity provider (IdP) instead of building or operating your own. In this article, we describe the challenges of building or running your own identity provider.

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
- Conditional access, which creates a risk profile around sign-in attempts based on a number of factors. The factors might include the user's identity, the location of the sign-in attempt, previous sign-in activity, application and data sensitivity, and other factors.
- Just-in-time access control, which temporarily allows users to sign in based on an approval process, and then removes the authorization automatically.

If you're building an identity component as part of your solution, it's unlikely you'll be able to justify the work involved in implementing these features, and in maintaining them. Additionally, some of the features require extra work, such as integration with email and SMS messaging providers to send MFA codes.

Managed identity platforms also can provide an improved set of security features based on the volume of sign-in requests they receive. For example, the following features work best when there's a large number of customers using a managed, multitenant identity platform:

- Risky sign-in detection, such as sign-in attempts from botnets and [impossible travel](/defender-cloud-apps/anomaly-detection-policy#impossible-travel), and using machine learning techniques to classify sign-in attempts as valid or invalid.
- Common credential detection, such as insecure passwords that are frequently used by other users and therefore subject to a heightened risk of compromise.
- Compromised credential monitoring, which monitors sources on the dark web for leaked credentials and prevents their use.

If you build or run your own identity platform, you won't be able to take advantage of these features.

## Avoid storing credentials

When you run your own identity provider, you have to store a database of credentials. You should never store raw credentials, or even encrypted credentials. Instead, you should cryptographically hash and salt the credentials before storing them, which makes them more difficult to attack. However, even hashed and salted credentials are vulnerable to a variety of attack types.

Regardless of how you protect the individual credentials, maintaining a database of credentials makes you a target for attacks. Recent years have shown that both large and small organizations have had their credential databases targeted for attack. **Consider credential storage to be a liability, not an asset.**

## Build a reliable and performant identity system

Because identity systems are such a key part of modern cloud applications, they must be reliable. If your identity system is unavailable, the rest of your solution might well be impacted and either operate in a degraded fashion or fail to operate at all. By using a managed identity provider with a service level agreement, you can increase your confidence that your identity system will remain operational when you need it. For example, [Azure Active Directory offers a 99.99% uptime SLA for the Basic and Premium service tiers](https://azure.microsoft.com/support/legal/sla/active-directory/), which covers both the login and token issuing processes.

Similarly, an identity system must be performant, and able to scale to the level of growth that your system might experience. Depending on your application architecture, it's possible that every request might require interaction with your identity provider, and any performance issues will be apparent to your users. Managed identity providers are incentivized to scale to large user loads, and architect their solutions to absorb large volumes of traffic, including traffic generated by different forms of attacks.

## Test and retest your security

If you run an identity system, it becomes your responsibility to keep it secured. Examples of the concerns you need to consider include:

* Penetration testing needs to be performed regularly, and requires specalist expertise.
* Your employees, and anybody else with access to the system, might need to be vetted.
* All changes to your solution must be tightly controlled and reviewed by experts.

## Focus on your core value

It's expensive and complex to maintain a secure, reliable, and performant identity platform. In the most situations, an identity provider isn't the component that adds value to your solution, or that differentiates you from your competitors. By outsourcing your identity requirements to a specialized identity provider, you can focus on architecting and building the components of your solution that add value to your business and your customers.

## Next steps

- TODO

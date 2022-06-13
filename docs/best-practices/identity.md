---
title: Identity platforms
description: Learn why it's important to use a managed identity service instead of building or running your own.
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

# Identity platforms

Almost every cloud application needs to work with user identities. Identity is the foundation of modern security practices like [zero trust](https://www.microsoft.com/security/business/zero-trust), and application user identity is a critical part of your solution's architecture.

For most solutions, we strongly recommend using an identity as a service (IDaaS) platform instead of building or operating your own. In this article, we describe the challenges of building or running your own identity system.

> [!IMPORTANT]
> By using a fully managed identity platform or IDaaS, like Azure Active Directory (Azure AD), Azure AD B2C, or another similar system, you can mitigate many of the issues described in this article, and we recommend this approach wherever possible.
> 
> Your solution requirements might lead you to use a framework or off-the-shelf identity solution that you host and run yourself. While using a prebuilt identity platform mitigates some of the issues described in this article, many of the problems we describe are still your responsibility.
> 
> You should avoid ever building your own identity system from scratch.

## Implement identity and federation protocols

Modern identity protocols are complex. [OAuth 2, OpenID Connect, and other protocols](/azure/active-directory/develop/active-directory-v2-protocols) have been designed by industry experts to ensure that they mitigate real-world attacks and vulnerabilities. The protocols also evolve over time to adapt to changes in technologies, attack strategies, and user expectations. Identity specialists, with expertise in the protocols and how they're used, are in the best position to implement and validate systems that follow these protocols.

It's also common to [federate IdPs together](../patterns/federated-identity.yml). Identity federation protocols are complex to establish, manage, and maintain, and again requires specialist knowledge and experience.

## Adopt modern identity features

Users expect an identity system to include a range of advanced features, which might include the following features:

- Passwordless authentication, where users can use secure approaches to sign in that don't require them to enter a credential.
- Multifactor authentication (MFA), which prompts the user to authenticate themselves in multiple ways. For example, a user might sign in by using a password and also an authenticator app on their mobile device, or a code that's sent by email.
- Auditing, which tracks every event that happens in the identity platform including successful, failed, and aborted sign-in attempts. You might also need to log sufficient detail to forensically analyze the sign-in attempt later.
- Conditional access, which creates a risk profile around a sign-in attempt based on various factors. The factors might include the user's identity, the location of the sign-in attempt, previous sign-in activity, and the sensitivity of the data or application.
- Just-in-time access control, which temporarily allows users to sign in based on an approval process, and then removes the authorization automatically.

If you're building an identity component yourself as part of your business solution, it's unlikely you'll be able to justify the work involved in implementing these features, and in maintaining them. Some of these features also require extra work, such as integration with email messaging providers to send MFA codes, and storing and retaining audit logs for a sufficient time period.

IDaaS platforms also can provide an improved set of security features based on the volume of sign-in requests they receive. For example, the following features work best when there's a large number of customers using a single identity platform:

- Risky sign-in detection, such as sign-in attempts from botnets, [impossible travel](/defender-cloud-apps/anomaly-detection-policy#impossible-travel), and the use of machine learning techniques to classify sign-in attempts as valid or invalid.
- Common credential detection, such as passwords that are frequently used by other users and therefore subject to a heightened risk of compromise.
- Compromised credential monitoring, which monitors sources on the dark web for leaked credentials and prevents their use.
- Ongoing monitoring of the threat landscape and the current vectors that attackers use.

If you build or run your own identity system, you won't be able to take advantage of these features.

## Avoid storing credentials

When you run your own identity system, you have to store a database of credentials. You should never store credentials in clear text, or even encrypted credentials.

Instead, you might consider cryptographically hashing and salting credentials before storing them, which makes them more difficult to attack. However, even hashed and salted credentials are vulnerable to several types of attack.

Regardless of how you protect the individual credentials, maintaining a database of credentials makes you a target for attacks. Recent years have shown that both large and small organizations have had their credential databases targeted for attack.

**Consider credential storage to be a liability, not an asset.** By using an IDaaS, you outsource the problem of credential storage to experts who can invest the time and resources in securely managing credentials.

## Use a reliable and performant identity system

Because identity systems are such a key part of modern cloud applications, they must be reliable. If your identity system is unavailable, the rest of your solution might well be impacted and either operate in a degraded fashion or fail to operate at all. By using an IDaaS with a service level agreement, you can increase your confidence that your identity system will remain operational when you need it. For example, [Azure Active Directory offers a 99.99% uptime SLA for the Basic and Premium service tiers](https://azure.microsoft.com/support/legal/sla/active-directory/), which covers both the sign-in and token issuing processes.

Similarly, an identity system must be performant, and able to scale to the level of growth that your system might experience. Depending on your application architecture, it's possible that every request might require interaction with your identity system, and any performance issues will be apparent to your users. IDaaS systems are incentivized to scale to large user loads, and architect their solutions to absorb large volumes of traffic, including traffic generated by different forms of attacks.

## Test your security and apply tight controls

If you run an identity system, it becomes your responsibility to keep it secured. Examples of the controls you need to consider implementing include:

* Penetration testing needs to be performed regularly, and requires specialized expertise.
* Your employees, and anybody else with access to the system, might need to be vetted.
* All changes to your solution must be tightly controlled and reviewed by experts.

These controls are often expensive and difficult to implement.

## Focus on your core value

It's expensive and complex to maintain a secure, reliable, and performant identity platform. In the most situations, an identity system isn't a component that adds value to your solution, or that differentiates you from your competitors. By outsourcing your identity requirements to a system built by experts, you can focus on architecting and building the components of your solution that add business value for your customers.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

 - [John Downs](http://linkedin.com/in/john-downs) | Senior Customer Engineer, FastTrack for Azure

Other contributors:

 - [Jelle Druyts](http://linkedin.com/in/jelle-druyts-0b76823) | Principal Customer Engineer, FastTrack for Azure
 - [LaBrina Loving](http://linkedin.com/in/chixcancode) | Principal Customer Engineering Manager, FastTrack for Azure
 - [Arsen Vladimirskiy](http://linkedin.com/in/arsenv) | Principal Customer Engineer, FastTrack for Azure

## Next steps

- [What is Azure Active Directory?](/azure/active-directory/fundamentals/active-directory-whatis)
- [What is Azure Active Directory B2C?](/azure/active-directory-b2c/overview)

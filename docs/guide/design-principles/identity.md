---
title: Use a fully managed identity service platform
titleSuffix: Azure Architecture Center
description: Learn why it's important to use an identity as a service (IDaaS) platform instead of building or running your own.
author: johndowns
ms.date: 07/21/2022
ms.author: jodowns
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: guide
categories:
  - identity
products:
  - azure-active-directory
  - azure-active-directory-b2c
ms.custom:
  - guide
---

# Use a fully managed identity service platform

Almost every cloud application needs to work with user identities. Identity is the foundation of modern security practices like [zero trust](https://www.microsoft.com/security/business/zero-trust), and user identity for applications is a critical part of your solution's architecture.

For most solutions, we strongly recommend using an identity as a service (IDaaS) platform, a fully managed identity solution, instead of building or operating your own. In this article, we describe the challenges of building or running your own identity system.

## Recommendations

> [!IMPORTANT]
> By using an IDaaS, like Azure Active Directory (Azure AD), Azure AD B2C, or another similar system, you can mitigate many of the issues that are described in this article. We recommend this approach wherever possible.
> 
> Your solution requirements might lead you to use a framework or off-the-shelf identity solution that you host and run yourself. While using a prebuilt identity platform mitigates some of the issues that are described in this article, handling many of these issues is still your responsibility with such a solution.
> 
> You should avoid using an identity system that you build from scratch.

### Avoid storing credentials

When you run your own identity system, you have to store a database of credentials. You should never store credentials in clear text, or even as encrypted data.

Instead, you might consider cryptographically hashing and salting credentials before storing them, which makes them more difficult to attack. However, even hashed and salted credentials are vulnerable to several types of attack.

Regardless of how you protect the individual credentials, maintaining a database of credentials makes you a target for attacks. Recent years have shown that both large and small organizations have had their credentials databases targeted for attack.

*Consider credential storage to be a liability, not an asset.* By using an IDaaS, you outsource the problem of credential storage to experts who can invest the time and resources in securely managing credentials.

### Implement identity and federation protocols

Modern identity protocols are complex. Industry experts have designed OAuth 2, OpenID Connect, and other protocols to ensure that they mitigate real-world attacks and vulnerabilities. The protocols also evolve to adapt to changes in technologies, attack strategies, and user expectations. Identity specialists, with expertise in the protocols and how they're used, are in the best position to implement and validate systems that follow these protocols. For more information about the protocols and the platform, see [OAuth 2.0 and OpenID Connect (OIDC) in the Microsoft identity platform](/azure/active-directory/develop/active-directory-v2-protocols).

It's also common to federate identity systems. Identity federation protocols are complex to establish, manage, and maintain, and they require specialist knowledge and experience. For more information, see [Federated identity pattern](../../patterns/federated-identity.yml).

### Adopt modern identity features

Users expect an identity system to have a range of advanced features, including:

- Passwordless authentication, which uses secure approaches to sign in that don't require users to enter credentials.

- Single sign-on (SSO), which allows users to sign in by using an identity from their employer, school, or another organization.

- Multifactor authentication (MFA), which prompts users to authenticate themselves in multiple ways. For example, a user might sign in by using a password and also by using an authenticator app on a mobile device or a code that's sent by email.

- Auditing, which tracks every event that happens in the identity platform, including successful, failed, and aborted sign-in attempts. To forensically analyze a sign-in attempt later might require a detailed log.

- Conditional access, which creates a risk profile around a sign-in attempt that's based on various factors. The factors might include the user's identity, the location of the sign-in attempt, previous sign-in activity, and the sensitivity of the data or application.

- Just-in-time access control, which temporarily allows users to sign in based on an approval process, and then removes the authorization automatically.

If you're building an identity component yourself as part of your business solution, it's unlikely you'll be able to justify the work involved in implementing these features—and in maintaining them. Some of these features also require extra work, such as integration with messaging providers to send MFA codes, and storing and retaining audit logs for a sufficient time period.

IDaaS platforms can also provide an improved set of security features that are based on the volume of sign-in requests that they receive. For example, the following features work best when there's a large number of customers who use a single identity platform:

- Detection of risky sign-in events, such as sign-in attempts from botnets
- Detection of [impossible travel](/defender-cloud-apps/anomaly-detection-policy#impossible-travel) between a user's activities
- Detection of common credentials, such as passwords that are frequently used by other users, which are therefore subject to a heightened risk of compromise
- Use of machine learning techniques to classify sign-in attempts as valid or invalid
- Monitoring of the so-called *dark web* for leaked credentials and preventing their exploitation
- Ongoing monitoring of the threat landscape and the current vectors that attackers use

If you build or run your own identity system, you can't take advantage of these features.

### Use a reliable, high-performance identity system

Because identity systems are such a key part of modern cloud applications, they must be reliable. If your identity system is unavailable, then the rest of your solution might be affected and either operate in a degraded fashion or fail to operate at all. By using an IDaaS with a service level agreement, you can increase your confidence that your identity system will remain operational when you need it. For example, Azure AD offers an SLA for uptime for the Basic and Premium service tiers, which covers both the sign-in and token issuing processes. For more information, see [SLA for Azure Active Directory (Azure AD)](https://azure.microsoft.com/support/legal/sla/active-directory/).

Similarly, an identity system must perform well and be able to scale to the level of growth that your system might experience. Depending on your application architecture, it's possible that every request might require interaction with your identity system, and any performance issues will be apparent to your users. IDaaS systems are incentivized to scale to large user loads. They're designed to absorb large volumes of traffic, including traffic generated by different forms of attacks.

### Test your security and apply tight controls

If you run an identity system, it's your responsibility to keep it secured. Examples of the controls you need to consider implementing include:

* Periodic penetration testing, which requires specialized expertise.
* Vetting of employees and anybody else with access to the system.
* Tight control of all changes to your solution with all changes reviewed by experts.

These controls are often expensive and difficult to implement.

### Use cloud-native security controls

When you use Azure AD as your solution's identity provider, you can take advantage of cloud-native security features like [managed identities for Azure resources](/azure/active-directory/managed-identities-azure-resources/overview).

If you choose to use a separate identity platform, you need to consider how your application can take advantage of managed identities and other Azure AD features while simultaneously integrating with your own identity platform.

### Focus on your core value

It's expensive and complex to maintain a secure, reliable, and responsive identity platform. In most situations, an identity system isn't a component that adds value to your solution, or that differentiates you from your competitors. It's good to outsource your identity requirements to a system that's built by experts. That way, you can focus on designing and building the components of your solution that add business value for your customers.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

 - [John Downs](http://linkedin.com/in/john-downs) | Senior Customer Engineer, FastTrack for Azure

Other contributors:

 - [Jelle Druyts](http://linkedin.com/in/jelle-druyts-0b76823) | Principal Customer Engineer, FastTrack for Azure
 - [LaBrina Loving](http://linkedin.com/in/chixcancode) | Principal Customer Engineering Manager, FastTrack for Azure
 - [Gary Moore](https://linkedin.com/in/gwmoore) | Programmer/Writer
 - [Arsen Vladimirskiy](http://linkedin.com/in/arsenv) | Principal Customer Engineer, FastTrack for Azure
 
*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [What is Azure Active Directory?](/azure/active-directory/fundamentals/active-directory-whatis)
- [What is Azure Active Directory B2C?](/azure/active-directory-b2c/overview)
- [Explore identity and Azure AD](/training/modules/explore-identity-azure-active-directory)
- [Design an identity security strategy](/training/modules/design-identity-security-strategy)
- [Implement Microsoft identity](/training/paths/m365-identity-associate)
- [Manage identity and access in Azure Active Directory](/training/paths/manage-identity-and-access)

## Related resources

- [Authenticate using Azure AD and OpenID Connect](../../multitenant-identity/authenticate.yml)
- [Federated identity pattern](../../patterns/federated-identity.yml)
- [Hybrid identity](../../solution-ideas/articles/hybrid-identity.yml)
- [Identity architecture design](../../identity/identity-start-here.yml)
- [Resilient identity and access management with Azure AD](../../guide/resilience/resilience-overview.yml)

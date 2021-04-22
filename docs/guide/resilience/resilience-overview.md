---
title: Resilient identity and access management with Azure Active Directory (Azure AD)
description: Read this guide to learn how architects, IT administrators, and developers can build resilience to disruption of their identity systems.
author: BarbaraSelden
manager: daveba
ms.service: architecture-center
ms.topic: conceptual
ms.date: 04/22/2021
ms.author: baselden
ms.custom: fcp
---

# Resilient identity and access management with Azure AD

Identity and access management (IAM) is a process, policy, and technology framework that covers management of identities and what they can access. IAM includes components that support authentication and authorization of user and other accounts in a system.

IAM resilience is the ability to endure disruption to system components and recover with minimal impact to business, users, customers, and operations. Disruption can come from any component of an IAM system. To build a resilient IAM system, assume disruptions will occur and plan for them.

To promote IAM resilience:

- Reduce dependencies, complexity, and single points of failure.
- Ensure comprehensive error handling.

Whatever the source of disruption, recognizing and planning for contingencies is important. However, adding additional identity systems, with their dependencies and complexity, could reduce rather than increase resilience.

When planning for resilience of an IAM solution, consider the following elements:

- The applications that rely on your IAM system.
- The public infrastructures that your authentication calls use, including telecom companies, internet service providers, and public key providers.
- Your cloud and on-premises identity providers.
- Other services that rely on your IAM, and APIs that connect the services.
- Any other on-premises components in your system.

## Architecture

![Diagram showing an overview of administering IAM resilience.](media/resilience-in-infrastructure/admin-resilience-overview.png)

The previous diagram shows several ways to increase IAM resilience. The linked articles explain the methods in detail.

- Manage dependencies
- Reduce authentication calls
- Use long-lived revocable tokens
- Reduce external API dependencies
- Define resilient authentication
- Access on-premises apps

- [Build resilience with credential management](/azure/active-directory/fundamentals/resilience-in-credentials)
- [Build resilience with device states](/azure/active-directory/fundamentals/resilience-with-device-states)
- [Build resilience by using Continuous Access Evaluation (CAE)](/azure/active-directory/fundamentals/resilience-with-continuous-access-evaluation)
- [Build resilience in external user authentication](/azure/active-directory/fundamentals/resilience-b2b-authentication)
- [Build resilience in your hybrid authentication](/azure/active-directory/fundamentals/resilience-in-hybrid)
- [Build resilience in application access with Application Proxy](/azure/active-directory/fundamentals/resilience-on-premises-access)

### Reduce potential authentication disruption

Every call to the authentication system is subject to disruption if any component of the call fails. When authentication is disrupted because of underlying component failures, users can't access their applications. Therefore, reducing the number of authentication calls and the number of dependencies in those calls is important to resilience.

In a token-based authentication system like Azure AD, a user's client application must acquire a security token from the identity system before it can access an application or other resource. During the validity period, a client can present the same token multiple times to access the application.

When the token presented to the application expires, the application rejects the token, and the client must acquire a new token from Azure AD. Acquiring a new token potentially requires user interaction like credential prompts or other requirements. Reducing the frequency of authentication calls with longer-lived tokens decreases unnecessary interactions. However, you must balance token life with the risk created by fewer policy evaluations.

Developers can help control how often applications request tokens. Work with your developers to ensure they're using Azure AD Managed Identities for their applications wherever possible.

For more information on managing token lifetimes, see this article on [optimizing reauthentication prompts](../authentication/concepts-azure-multi-factor-authentication-prompts-session-lifetime.md).

## Next steps

- [Build resilience in your IAM infrastructure](/azure/active-directory/fundamentals/resilience-in-infrastructure)
- [Build IAM resilience in your applications](/azure/active-directory/fundamentals/resilience-app-development-overview)
- [Build resilience in your customer facing applications (CIAM) systems](/azure/active-directory/fundamentals/resilience-b2c)

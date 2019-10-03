---
title: Identity management for your workload
description: Describes how to manage identities in your workload.
author: david-stanford
ms.date: 11/01/2019
ms.topic: article
ms.service: architecture-center
ms.subservice: cloud-design-principles
ms.custom: 
---

# Identity management for your workload

## Secrets

Safeguarding confidential source, connection strings, certificates, secrets etc. required in the deployment pipeline ensures security of end products.

## Isolation

With DevOps, organizations aim to improve operational processes in terms of security, reliability and efficiency. In DevOps environments, since software components are often developed in parallel but separately, you’ll require certain network configurations.

## Identity strategy

Many consider identity to be the primary perimeter for security. This is a shift from the traditional focus on network security. Network perimeters keep getting more porous, and that perimeter defense can’t be as effective as it was before the explosion of BYOD devices and cloud applications. Azure Active Directory (Azure AD) is the Azure solution for identity and access management. Azure AD is a multitenant, cloud-based directory and identity management service from Microsoft. It combines core directory services, application access management, and identity protection into a single solution.

Manage accounts from one single location, regardless of where an account is created. Enable single sign-on. Otherwise, it becomes an administrative problem not only for IT but also for users who have to remember multiple passwords. Turn on conditional access because focusing on who can access a resource is not sufficient anymore. Enable password management and use appropriate security policies to prevent abuse.

## System to manage identity

Don't take this decision lightly, for the following reasons: It's the first decision for an organization that wants to move to the cloud. The authentication method is a critical component of an organization’s presence in the cloud. It controls access to all cloud data and resources. It's the foundation of all the other advanced security and user experience features in Azure AD. The authentication method is difficult to change after it's implemented.

## Credential policies in place

Limiting the lifespan of a credential reduces the risk from and effectiveness of password-based attacks and exploits, by condensing the window of time during which a stolen credential is valid.

Password rotation, etc.

## Enabled Single Sign-on (SSO)

Exposure to scenarios where users have multiple passwords, increasing the likelihood of users reusing passwords or using weak passwords.

Action:
Enable Single Sign-On (SSO).

## Self-service password reset & password management

Susceptibility to a higher call volume to the service desk due to password issues.

Action:
Deploy password management.

## Multi-factor authentication (MFA)

Risk of not complying with industry standards, such as PCI DSS version 3.2 and credential theft type of attack, such as Pass-the- Hash (PtH).

Action:
Enforce MFA for users.

## enforce identity for SaaS apps, integrating with custom apps

Risk of a credential-theft type of attack, such as weak authentication and session management described in Open Web Application Security Project (OWASP) Top 10.

Action:
Guide developers to leverage identity capabilities for SaaS apps.


---
title: Comparing AWS and Azure security and identity services
description: A comparison of security and identity services between Azure and AWS
author: doodlemania2
ms.date: 05/21/2020
ms.topic: reference
ms.service: architecture-center
ms.subservice: cloud-fundamentals
products:
  - azure-active-directory
---

# Security and identity on Azure and AWS

## Directory service and Azure Active Directory

Azure splits up directory services into the following offerings:

- [Azure Active Directory](/azure/active-directory/fundamentals/active-directory-whatis): cloud-based directory and identity management service.

- [Azure Active Directory B2B](/azure/active-directory/external-identities/what-is-b2b): enables access to your corporate applications from partner-managed identities.

- [Azure Active Directory B2C](/azure/active-directory-b2c/overview): service offering support for single sign-on and user management for consumer-facing applications.

- [Azure Active Directory Domain Services](/azure/active-directory-domain-services/overview): hosted domain controller service, allowing Active Directory compatible domain join and user management functionality.

## Web application firewall

In addition to the [Application Gateway Web Application Firewall](/azure/application-gateway/waf-overview), you can also use web application firewalls from third-party vendors like [Barracuda Networks](https://azuremarketplace.microsoft.com/marketplace/apps/barracudanetworks.waf).

## See also

- [Getting started with Microsoft Azure security](/azure/security)

- [Azure Identity Management and access control security best practices](/azure/security/azure-security-identity-management-best-practices)

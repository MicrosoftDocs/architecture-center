---
title: Conditional Access for Zero Trust
description: An introduction to a design and framework for implementing Zero Trust principles by using Azure AD Conditional Access. 
author: clajes
ms.author: clajes
ms.date: 04/11/2023
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
products:
  - azure-active-directory
categories:
  - security
  - identity
ms.custom: fcp
---

# Conditional Access for Zero Trust

The articles in this section provide a design and framework for implementing [Zero Trust](https://www.microsoft.com/security/business/zero-trust) principles by using Conditional Access to control access to cloud services. The guidance is based on years of experience with helping customers control access to their resources.  

The framework presented here represents a structured approach that you can use to get a good balance between security and usability while ensuring that user access is controlled.

The guidance suggests a structured approach for helping to secure access that's based on personas. It also includes a breakdown of suggested personas and defines the Conditional Access policies for each persona.

## Intended audience

This guidance is intended for individuals who: 
- Design security and identity solutions to control access to Azure protected resources. 
- Maintain solutions after they're delivered.

The intended audience has a basic working knowledge of Azure Active Directory (Azure AD) and a general understanding of multi-factor authentication, Conditional Access, identity, and security concepts.

Knowledge in the following areas is also recommended:
- Microsoft Endpoint Manager
- Azure AD identity management
- Azure AD Conditional Access and multi-factor authentication for guest users (B2B)
- Azure AD security policies and resource protection
- The B2B invitation process

## Requirements

Every company has different requirements and security policies. When you create an architecture and follow this suggested framework for Conditional Access, you need to take your company's requirements into account. The guidance includes principles that are related to Zero Trust that you can use as input when you create an architecture. You can then address specific company requirements and policies and adjust the architecture accordingly.

For example, a company might have these requirements:
- All access must be protected by at least two factors.
- No data on unmanaged devices.
- Require a compliant device for access to resources, whenever possible.
- Guest user access must be governed by Identity Governance using access packages and access reviews.
- Access to cloud services must be based on passwordless authentication.

## Conditional Access guidance

This section includes the following articles:
- [Conditional Access design principles and dependencies](./conditional-access-design.yml) provides recommended principles that, together with your company's requirements, serve as input to the suggested persona-based architecture.
- [Conditional Access architecture and personas](./conditional-access-architecture.yml) introduces the persona-based approach for structuring Conditional Access policies. It also provides suggested personas that you can use as a starting point.
- [Conditional Access framework and policies](./conditional-access-framework.md) provides specific details on how to structure and name Conditional Access policies that are based on the personas.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.* 

Principal author:

 - [Claus Jespersen](https://www.linkedin.com/in/claus-jespersen-25b0422/) | Principal Consultant ID&Sec
 
*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps 
- [Learning path: Implement and manage identity and access](/training/paths/implement-manage-identity-access)
- [What is Conditional Access?](/azure/active-directory/conditional-access/overview)
- [Common Conditional Access policies](/azure/active-directory/conditional-access/concept-conditional-access-policy-common)

## Related resources 
- [Conditional Access design principles and dependencies](./conditional-access-design.yml)
- [Conditional Access architecture and personas](./conditional-access-architecture.yml)
- [Conditional Access framework and policies](./conditional-access-framework.md)
- [Azure Active Directory IDaaS in security operations](/azure/architecture/example-scenario/aadsec/azure-ad-security)

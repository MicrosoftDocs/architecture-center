---
title: Conditional Access for Zero Trust
description: Review an introduction to a design and framework for implementing Zero Trust principles by using Azure AD Conditional Access. 
author: clajes
ms.author: clajes
ms.date: 01/26/2022
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

The articles in this section provide a design and framework for implementing Zero Trust principles by using Conditional Access to control access to cloud services. The guidance is based on years of experience with helping customers control access to their resources.  

The framework presented here represents a structured approach that you can use to get a good balance between security and usability while ensuring that user access is controlled.

The guidance suggests a structured approach for helping to secure access based on personas. It also includes breakdown of suggested personas and defines the Conditional Access policies for each persona.

## Intended audience

This guidance is intended for individuals who: 
- Design security and identity solutions to control access to Azure protected resources. 
- Maintain the solution after it's delivered.

The intended audience has a basic working knowledge of Azure Active Directory (Azure AD) and a general understanding of multi-factor authentication, conditional access, identity, and security concepts.

Knowledge in following areas is also recommended:
- Microsoft Endpoint Manager
- Azure AD identity management
- Azure AD Conditional Access and multi-factor authentication for guest users (B2B)
- Azure AD security policies and resource protection
- The B2B invitation process

## Requirements

Every company has different requirements and security policies. When you create an architecture and follow this suggested framework for Conditional Access, you need to take your company's requirements into account. This guidance doesn't include specific requirements that vary depending on the company. It includes principles related to Zero Trust that you can use as input when you create an architecture. You can then address specific company requirements and policies into account and adjust the architecture accordingly.

For example, a company might have these requirements:
- All access must be protected by at least two factors.
- No data on unmanaged devices.
- No guest access allowed.
- Access to cloud services must be based on passwordless authentication.

## Conditional Access guidance

This guidance includes the following articles:
- [Conditional access design principles and dependencies](/azure/architecture/guide/security/conditional-access-design) 
- [Conditional access architecture and personas](/azure/architecture/guide/security/conditional-access-architecture)
- [Conditional access framework and policies](/azure/architecture/guide/security/conditional-access-framework) 

The design principles sub-section lists recommended principles to follow that together with the companies requirements will server as input to the suggested architecture based on personas.

The Personas section introduce the persona based approach as the basis on how to structure Conditional Access policies as well as shows some suggested personas that can be used as a starting point.

The Conditional Access framework and policy section goes into specific details on how to structure and name Conditional Access policies based on the personas chosen.

## Related resources

[What is Conditional Access](https://docs.microsoft.com/azure/active-directory/conditional-access/overview)

[Common Conditional Access Policies](https://docs.microsoft.com/azure/active-directory/conditional-access/concept-conditional-access-policy-common)



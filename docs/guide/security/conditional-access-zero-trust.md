---
title: Conditional Access overview
description: Review a high-level design and framework for Azure AD Conditional Access. Conditional Access provides access to cloud services based on a Zero-Trust approach. 
author: clajes
ms.author: clajes
ms.date: 01/25/2022
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

# Conditional Access overview

This article introduces the Conditional Access guidance based on Zero Trust principles.

## Introduction

This document describes a high-level design and framework for Azure AD Conditional Access which is the central policy engine for access to cloud services based on a Zero Trust approach. The guidance is based on years of experiences from engagements where Microsoft has helped customers secure access to their resources based on Zero Trust Principles.  

The Conditional Access policy framework presented as part of this guidance represents a structured approach for customers to follow to ensure that they can get a good balance between security and usability while ensuring that any interactive/user access is secured

## Document Purpose

The purpose of this document is to help companies understand how they can secure access to resources based on Zero Trust principles.

Not only does the guidance suggest a structured approach on how to secure the access based on personas. it also includes breakdown of suggested personas and shows what the related Conditional Access policies would be for each persona.

## Intended Audience

This guidance is intended for employees and individuals in companies who are responsible for designing and arhitecting security and identity solutions for access control to Azure protected resources well as for people maintaining the solution after it’s delivered.

It assumes a basic working knowledge of Azure AD, and a general understanding of MFA, conditional access, identity, and security concepts.

Knowledge about the following areas is suggested to follow the topics discussed and recommendations and design decisions.

- Azure Active Directory
- Microsoft Endpoint Manager
- Azure AD Identity Management
- Azure AD Conditional Access and MFA for Guest users (B2B)
- Azure AD Security Policies and resource protection
- B2B Invitation process

## Requirements

Companies have different individual requirements and security policies that must be taken into account when forming an architecture and following a suggested framework for Conditional Access. This guidance does not include specific requirements as they will vary from one company to another. Rather the guidance includes principles related to Zero Trust and take this as input to forming the architecture.

Readers are encouraged to include specific company requirements and policies to and adjust accordingly.

Example of requirements for company CONTOSO:

CONTOSO to provide more input in this section

- All access must be protected by at least two factors
- No data on unmanaged devices
- No guest access allowed (if so)
- Access to cloud services must be based on password-less authentication


## Next steps

The Conditional Access guidance is broken down into the following sub-sections

- Conditional access design principles and dependencies 
- Conditional access architecture and personas 
- Conditional access framework and policies 

The design principles sub-section lists recommended principles to follow that together with the companies requirements will server as input to the suggested architecture based on personas.

The Personas section introduce the persona based approach as the basis on how to structure Conditional Access policies as well as shows some suggested personas that can be used as a starting point.

The Conditional Access framework and policy section goes into specific details on how to structure and name Conditional Access policies based on the personas chosen.

## Related resources

[What is Conditional Access](https://docs.microsoft.com/azure/active-directory/conditional-access/overview)

[Common Conditional Access Policies](https://docs.microsoft.com/azure/active-directory/conditional-access/concept-conditional-access-policy-common)



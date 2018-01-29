---
title: Azure tenant design guide
description: Describes the different design patterns for Azure AD tenants
author: telmosampaio
---

# Azure tenant design guide

The definition of a tenant in the Microsoft cloud differs depending on the type of service being used. For SaaS offerings, such as Office 365 and EMS, a tenant tied to a regional location that hosts the physical servers Microsoft uses to provide the SaaS offering. For PaaS and IaaS services, a single tenant can be used to provide services in different Azure regions.

The main point to consider is that a tenant provides identity services for a given customer. And you refer to the tenant as an Azure Active Directory ([Azure AD][azure-ad]) tenant.

In this guide you will learn how to design the usage of tenants in your Azure environment.

## Overview

An Azure AD tenant provides a security boundary for identity services and namespace used for one or more [Azure subscriptions][subscription]. You want to have as few tenants as possible, to simplify management. However, there are specific scenarios where you may need more than one scenario.

- **Resources in different Azure regions**. Azure provides four distinct types of cloud environments today: public, sovereign, government, and private. In the public cloud, you can use a single tenant to host services in any public region. However, to use sovereign and government clouds you need a specific tenant just for that cloud environment. TODO: what about private (Stack)?

- **Applications that require management level access to Azure AD**. Certain applications may require access to Azure AD to create service principals and subscriptions. You do not want to test those applications in a production environment, to avoid unnecessary changes to Azure AD. For that reason, you should consider using a separate Azure AD tenant to develop and test such applications.

- **Active Directory integration**. Azure AD uses a flat directory model. You can only have one domain, without a parent or child. And you can only synchronized accounts from a single Active Directory domain to an Azure AD tenant. If you have a multi domain or multi forest AD environment, you should consider if there is a need to synchronize all domains, and if so, you need to create different Azure AD tenants TODO: validate this

- **Existing subscriptions**. When you create a new Azure subscription using a Microsoft account instead of an accoutn from your own organization, Azure creates a tenant for you under the onmicrosoft.com namspace. IN a bottom-up and opportunistic scenario, yuou encounter different people in the organization creating their own subscroptions, which leads to multiple tenants. You want to avoid scenarios like this, but it is almost impossible to do so. THerefore, you can [transfer a subscriptiont][transfer] to a different tenant at ay point in time.

- **Security concerns**. TODO: research the settings to allow global admins to add themselves to all subscriptions in a tenant

## Design patterns

### Single tenant

### Multiple tenants

### Office365 tenant

## Guidelines

- identify existing 'rogue' subscriptions
- identify needs for multiple tenants
- if the other multi-tenancy needs are not met, use single tenant

## FAQ

<!-- links -->

[azure-ad]: azure/active-directory/active-directory-administer
[add-azure-ad]: /azure/active-directory/develop/active-directory-howto-tenant
[subscription]: ./subscription.md
[trasnfer]: /azure/active-directory/active-directory-how-subscriptions-associated-directory